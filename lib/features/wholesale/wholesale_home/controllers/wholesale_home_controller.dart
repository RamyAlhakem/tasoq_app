import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_recent_order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/services/wholesale_home_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/data_sync_helper.dart';

class WholesaleHomeController extends ChangeNotifier {
  final WholesaleHomeServiceInterface wholesaleHomeServiceInterface;

  WholesaleHomeController({required this.wholesaleHomeServiceInterface});

  static const int _railLimit = 10;

  List<WholesaleCategoryTab>? _categoryTabs;
  final Map<WholesaleProductRailEnum, List<WholesaleProduct>> _productRails = {};
  final Map<WholesaleSellerRailEnum, List<WholesaleSeller>> _sellerRails = {};
  List<WholesaleRecentOrder>? _recentOrders;
  List<WholesaleSeller>? _recentlyViewedSellers;

  List<WholesaleCategoryTab>? get categoryTabs => _categoryTabs;
  List<WholesaleProduct>? get mostDemandedProducts => _productRails[WholesaleProductRailEnum.mostDemanded];
  List<WholesaleProduct>? get bestPriceProducts => _productRails[WholesaleProductRailEnum.bestPrice];
  List<WholesaleSeller>? get topWholesalers => _sellerRails[WholesaleSellerRailEnum.topWholesaler];
  List<WholesaleSeller>? get verifiedSellers => _sellerRails[WholesaleSellerRailEnum.verifiedSeller];
  List<WholesaleRecentOrder>? get recentOrders => _recentOrders;
  List<WholesaleSeller>? get recentlyViewedSellers => _recentlyViewedSellers;

  static const List<WholesaleSellerRailEnum> _homeSellerRails = [WholesaleSellerRailEnum.topWholesaler, WholesaleSellerRailEnum.verifiedSeller];

  final Map<WholesaleHomeTabScope, _CategoryRails> _categoryRails = {
    for (final WholesaleHomeTabScope scope in WholesaleHomeTabScope.values) scope: _CategoryRails(),
  };

  int? categoryIdFor(WholesaleHomeTabScope scope) => _categoryRails[scope]!.categoryId;

  List<WholesaleProduct>? productRailFor(WholesaleHomeTabScope scope, WholesaleProductRailEnum rail) {
    final _CategoryRails state = _categoryRails[scope]!;
    return state.categoryId == null ? _productRails[rail] : state.productRails[rail];
  }

  List<WholesaleSeller>? sellerRailFor(WholesaleHomeTabScope scope, WholesaleSellerRailEnum rail) {
    final _CategoryRails state = _categoryRails[scope]!;
    if (state.categoryId != null) return state.sellerRails[rail];
    return rail == WholesaleSellerRailEnum.recommended ? _recommendedSellers : _sellerRails[rail];
  }

  List<WholesaleSeller>? _recommendedSellers;

  bool get isLoaded => _categoryTabs != null
      && _productRails.length == WholesaleProductRailEnum.values.length
      && _sellerRails.length == _homeSellerRails.length;

  Future<void> fetchWithCache({required bool isLoggedIn}) async {
    if (isLoaded) {
      await getRecommendedSellers();
      return;
    }
    await getAllHomeSections(isLoggedIn: isLoggedIn);
  }

  Future<void> getAllHomeSections({required bool isLoggedIn}) async {
    await Future.wait([
      getCategoryTabs(),
      for (final WholesaleProductRailEnum rail in WholesaleProductRailEnum.values) getProductRail(rail),
      for (final WholesaleSellerRailEnum rail in _homeSellerRails) getSellerRail(rail),
      getRecommendedSellers(),
      getRecentOrders(isLoggedIn: isLoggedIn),
      getRecentlyViewedSellers(isLoggedIn: isLoggedIn),
    ]);
  }

  void resetUserData() {
    _recentOrders = [];
    _recentlyViewedSellers = [];
    _recommendedSellers = null;
    notifyListeners();
  }

  Future<void> getRecommendedSellers() async {
    final ApiResponseModel apiResponse = await wholesaleHomeServiceInterface.getRecommendedSellerList(limit: _railLimit);
    _recommendedSellers = _rowsOf(apiResponse, (json) => WholesaleSellerListModel.fromJson(json).sellers ?? []) ?? _recommendedSellers ?? [];
    notifyListeners();
  }

  Future<void> getCategoryTabs() async {
    await DataSyncHelper.fetchAndSyncData(
      fetchFromLocal: () => wholesaleHomeServiceInterface.getHomeCategoryList(source: DataSourceEnum.local),
      fetchFromClient: () => wholesaleHomeServiceInterface.getHomeCategoryList(source: DataSourceEnum.client),
      onResponse: (data, source) {
        try {
          _categoryTabs = WholesaleCategoryTab.listFromJson(data);
        } catch (_) {}
        notifyListeners();
      },
    );

    if (_categoryTabs == null) {
      _categoryTabs = [];
      notifyListeners();
    }
  }

  Future<void> getProductRail(WholesaleProductRailEnum rail) async {
    await DataSyncHelper.fetchAndSyncData(
      fetchFromLocal: () => wholesaleHomeServiceInterface.getProductRail(rail: rail, source: DataSourceEnum.local, limit: _railLimit),
      fetchFromClient: () => wholesaleHomeServiceInterface.getProductRail(rail: rail, source: DataSourceEnum.client, limit: _railLimit),
      onResponse: (data, source) {
        try {
          _productRails[rail] = WholesaleProductListModel.fromJson(data).products ?? [];
        } catch (_) {}
        notifyListeners();
      },
    );

    if (_productRails[rail] == null) {
      _productRails[rail] = [];
      notifyListeners();
    }
  }

  Future<void> getSellerRail(WholesaleSellerRailEnum rail) async {
    await DataSyncHelper.fetchAndSyncData(
      fetchFromLocal: () => wholesaleHomeServiceInterface.getSellerRail(rail: rail, source: DataSourceEnum.local, limit: _railLimit),
      fetchFromClient: () => wholesaleHomeServiceInterface.getSellerRail(rail: rail, source: DataSourceEnum.client, limit: _railLimit),
      onResponse: (data, source) {
        try {
          _sellerRails[rail] = WholesaleSellerListModel.fromJson(data).sellers ?? [];
        } catch (_) {}
        notifyListeners();
      },
    );

    if (_sellerRails[rail] == null) {
      _sellerRails[rail] = [];
      notifyListeners();
    }
  }

  Future<void> filterByCategory(WholesaleHomeTabScope scope, int? categoryId) async {
    final _CategoryRails state = _categoryRails[scope]!;
    if (state.categoryId == categoryId) return;

    state.categoryId = categoryId;
    state.productRails.clear();
    state.sellerRails.clear();
    notifyListeners();

    if (categoryId != null) await _getCategoryRails(scope, categoryId);
  }

  Future<void> refreshCategoryRails(WholesaleHomeTabScope scope) async {
    final int? categoryId = _categoryRails[scope]!.categoryId;
    if (categoryId != null) await _getCategoryRails(scope, categoryId);
  }

  Future<void> _getCategoryRails(WholesaleHomeTabScope scope, int categoryId) async {
    await Future.wait([
      for (final WholesaleProductRailEnum rail in scope.productRails) _getCategoryProductRail(scope, rail, categoryId),
      for (final WholesaleSellerRailEnum rail in scope.sellerRails) _getCategorySellerRail(scope, rail, categoryId),
    ]);
  }

  Future<void> _getCategoryProductRail(WholesaleHomeTabScope scope, WholesaleProductRailEnum rail, int categoryId) async {
    final _CategoryRails state = _categoryRails[scope]!;

    await DataSyncHelper.fetchAndSyncData(
      fetchFromLocal: () => wholesaleHomeServiceInterface.getProductRail(rail: rail, source: DataSourceEnum.local, limit: _railLimit, categoryId: categoryId),
      fetchFromClient: () => wholesaleHomeServiceInterface.getProductRail(rail: rail, source: DataSourceEnum.client, limit: _railLimit, categoryId: categoryId),
      onResponse: (data, source) {
        if (state.categoryId != categoryId) return;
        try {
          state.productRails[rail] = WholesaleProductListModel.fromJson(data).products ?? [];
        } catch (_) {}
        notifyListeners();
      },
    );

    if (state.categoryId == categoryId && state.productRails[rail] == null) {
      state.productRails[rail] = [];
      notifyListeners();
    }
  }

  Future<void> _getCategorySellerRail(WholesaleHomeTabScope scope, WholesaleSellerRailEnum rail, int categoryId) async {
    final _CategoryRails state = _categoryRails[scope]!;

    await DataSyncHelper.fetchAndSyncData(
      fetchFromLocal: () => wholesaleHomeServiceInterface.getSellerRail(rail: rail, source: DataSourceEnum.local, limit: _railLimit, categoryId: categoryId),
      fetchFromClient: () => wholesaleHomeServiceInterface.getSellerRail(rail: rail, source: DataSourceEnum.client, limit: _railLimit, categoryId: categoryId),
      onResponse: (data, source) {
        if (state.categoryId != categoryId) return;
        try {
          state.sellerRails[rail] = WholesaleSellerListModel.fromJson(data).sellers ?? [];
        } catch (_) {}
        notifyListeners();
      },
    );

    if (state.categoryId == categoryId && state.sellerRails[rail] == null) {
      state.sellerRails[rail] = [];
      notifyListeners();
    }
  }

  Future<void> getRecentOrders({required bool isLoggedIn}) async {
    if (!isLoggedIn) {
      _recentOrders = [];
      notifyListeners();
      return;
    }

    final ApiResponseModel apiResponse = await wholesaleHomeServiceInterface.getRecentOrderList(limit: _railLimit);
    _recentOrders = _rowsOf(apiResponse, WholesaleRecentOrder.listFromJson) ?? _recentOrders ?? [];
    notifyListeners();
  }

  Future<void> getRecentlyViewedSellers({required bool isLoggedIn}) async {
    if (!isLoggedIn) {
      _recentlyViewedSellers = [];
      notifyListeners();
      return;
    }

    final ApiResponseModel apiResponse = await wholesaleHomeServiceInterface.getRecentlyViewedShopList();
    _recentlyViewedSellers = _rowsOf(apiResponse, (json) => WholesaleSellerListModel.fromJson(json).sellers ?? []) ?? _recentlyViewedSellers ?? [];
    notifyListeners();
  }

  Future<List<WholesaleSeller>?> searchRecentlyViewedSellers(String search) async {
    final ApiResponseModel apiResponse = await wholesaleHomeServiceInterface.getRecentlyViewedShopList(search: search);
    return _rowsOf(apiResponse, (json) => WholesaleSellerListModel.fromJson(json).sellers ?? []);
  }

  List<T>? _rowsOf<T>(ApiResponseModel apiResponse, List<T> Function(Map<String, dynamic> json) parse) {
    if (apiResponse.response?.statusCode == 200) {
      return parse(apiResponse.response?.data);
    }
    ApiChecker.checkApi(apiResponse);
    return null;
  }
}

class _CategoryRails {
  int? categoryId;
  final Map<WholesaleProductRailEnum, List<WholesaleProduct>> productRails = {};
  final Map<WholesaleSellerRailEnum, List<WholesaleSeller>> sellerRails = {};
}
