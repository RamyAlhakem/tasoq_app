import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/controllers/wholesale_product_listing_mixin.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/domain/models/wholesale_product_filter_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/domain/models/wholesale_coupon_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/domain/models/wholesale_shop_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/domain/services/wholesale_shop_service_interface.dart';

class WholesaleShopController extends ChangeNotifier with WholesaleProductListingMixin {
  final WholesaleShopServiceInterface wholesaleShopServiceInterface;

  WholesaleShopController({required this.wholesaleShopServiceInterface});

  String _slug = '';
  String get slug => _slug;

  WholesaleShopDetails? _shopDetails;
  WholesaleShopDetails? get shopDetails => _shopDetails;

  bool _isShopLoading = false;
  bool get isShopLoading => _isShopLoading;

  bool _shopNotFound = false;
  bool get shopNotFound => _shopNotFound;

  String? _shopErrorMessage;
  String? get shopErrorMessage => _shopErrorMessage;

  String _query = '';
  String get query => _query;

  String? _paginationError;
  String? get paginationError => _paginationError;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  List<WholesaleCoupon>? _coupons;
  List<WholesaleCoupon>? get coupons => _coupons;

  List<WholesaleProduct>? _topSellingProducts;
  List<WholesaleProduct>? get topSellingProducts => _topSellingProducts;

  List<WholesaleProduct>? _featuredProducts;
  List<WholesaleProduct>? get featuredProducts => _featuredProducts;

  bool get isOverviewLoading => _coupons == null || _topSellingProducts == null || _featuredProducts == null;

  void setTabIndex(int index) {
    if (_tabIndex == index) return;
    _tabIndex = index;
    notifyListeners();
  }

  int? get shopId => filter.shopId;

  bool get canLoadProducts => shopId != null;

  Future<void> bind({required String slug, int? shopId}) async {
    _slug = slug;
    _shopDetails = null;
    _shopNotFound = false;
    _shopErrorMessage = null;
    _query = '';
    resetList();
    setFilter(filter.copyWith(shopId: shopId, clearShopId: shopId == null));
    _isShopLoading = true;
    notifyListeners();

    _coupons = null;
    _topSellingProducts = null;
    _featuredProducts = null;

    final Future<void> products = shopId != null ? _loadForShop() : Future.value();

    await _loadShopDetails();
    await products;
  }

  Future<void> _loadForShop() async {
    await Future.wait([
      loadProducts(page: 1),
      _loadCoupons(),
      _loadRail(const WholesaleProductFilterModel(sort: WholesaleSortOption.bestSelling), (rows) => _topSellingProducts = rows),
      _loadRail(const WholesaleProductFilterModel(featuredOnly: true), (rows) => _featuredProducts = rows),
    ]);
  }

  Future<void> _loadCoupons() async {
    final ApiResponseModel apiResponse = await wholesaleShopServiceInterface.getShopCouponList(_slug);

    _coupons = apiResponse.response?.statusCode == 200
        ? (WholesaleCouponResponseModel.fromJson(apiResponse.response?.data).coupons ?? []) : [];
    notifyListeners();
  }

  Future<void> _loadRail(WholesaleProductFilterModel railFilter, void Function(List<WholesaleProduct>) assign) async {
    final int? id = filter.shopId;
    if (id == null) {
      assign([]);
      notifyListeners();
      return;
    }

    final ApiResponseModel apiResponse = await wholesaleShopServiceInterface.getShopProductList(
      shopId: id, page: 1, limit: _railLimit, filterParams: railFilter.toQueryParams(),
    );

    assign(apiResponse.response?.statusCode == 200 ? (WholesaleProductListModel.fromJson(apiResponse.response?.data).products ?? []) : []);
    notifyListeners();
  }

  Future<void> _loadShopDetails() async {
    _isShopLoading = true;
    _shopNotFound = false;
    _shopErrorMessage = null;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleShopServiceInterface.getShopDetails(_slug);

    if (apiResponse.response?.statusCode == 200) {
      _shopDetails = WholesaleShopDetails.parse(apiResponse.response?.data);

      final int? resolvedId = _shopDetails?.id;
      if (resolvedId != null && resolvedId != filter.shopId) {
        setFilter(filter.copyWith(shopId: resolvedId));
        _isShopLoading = false;
        notifyListeners();
        await _loadForShop();
        return;
      }
    } else if (apiResponse.response?.statusCode == 404) {
      _shopNotFound = true;
    } else {
      _shopErrorMessage = _shopMessageOf(apiResponse);
    }

    _isShopLoading = false;
    notifyListeners();
  }

  Future<void> retryShopDetails() => _loadShopDetails();

  static const int _railLimit = 6;

  Future<void> search(String query) async {
    _query = query.trim();
    await loadProducts(page: 1);
  }

  Future<void> clearSearch() async {
    if (_query.isEmpty) return;
    _query = '';
    await loadProducts(page: 1);
  }

  @override
  Future<ApiResponseModel> fetchProductPage({
    required int page,
    required int limit,
    required Map<String, dynamic> filterParams,
  }) async {
    final int? id = filter.shopId;
    if (id == null) {
      return ApiResponseModel.withError('something_went_wrong');
    }

    return await wholesaleShopServiceInterface.getShopProductList(
      shopId: id, page: page, limit: limit, name: _query, filterParams: filterParams,
    );
  }

  @override
  void onPaginationFailed(String message) => _paginationError = message;

  void consumePaginationError() => _paginationError = null;

  String _shopMessageOf(ApiResponseModel apiResponse) {
    final dynamic error = apiResponse.error;
    if (error is String && error.isNotEmpty) return error;
    return 'something_went_wrong';
  }
}
