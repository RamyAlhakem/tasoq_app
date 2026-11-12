import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/controllers/wholesale_product_listing_mixin.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/domain/services/wholesale_product_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';

class WholesaleProductController extends ChangeNotifier with WholesaleProductListingMixin {
  final WholesaleProductServiceInterface wholesaleProductServiceInterface;

  WholesaleProductController({required this.wholesaleProductServiceInterface});

  String _categoryTabQuery = '';

  Future<void> loadCategoryTabProducts({
    int? categoryId,
    int? subCategoryId,
    int? subSubCategoryId,
    String search = '',
  }) async {
    _categoryTabQuery = search;
    resetList();
    setFilter(filter.copyWith(
      categoryIds: categoryId != null ? {categoryId} : {},
      subCategoryIds: subCategoryId != null ? {subCategoryId} : {},
      subSubCategoryIds: subSubCategoryId != null ? {subSubCategoryId} : {},
    ));
    await loadProducts(page: 1);
  }

  @override
  Future<ApiResponseModel> fetchProductPage({
    required int page,
    required int limit,
    required Map<String, dynamic> filterParams,
  }) async {
    return await wholesaleProductServiceInterface.getProductList(page: page, limit: limit, name: _categoryTabQuery, filterParams: filterParams);
  }

  static const int allCategoryKey = 0;
  static const int _defaultLimit = 10;

  final Map<int, WholesaleProductListModel?> _categoryProductMap = {};
  final Set<int> _fetchingCategoryIds = {};

  final DebounceHelper _categoryProductDebounce = DebounceHelper(milliseconds: 350);

  WholesaleProductListModel? categoryProductsFor(int? categoryId) => _categoryProductMap[categoryId ?? allCategoryKey];

  void clearCategoryProductFor(int? categoryId) => _categoryProductMap.remove(categoryId ?? allCategoryKey);

  void clearCategoryProductCache() {
    _categoryProductMap.clear();
    _fetchingCategoryIds.clear();
  }

  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  void selectCategory(int? categoryId) {
    if (_selectedCategoryId == categoryId) return;

    _selectedCategoryId = categoryId;
    notifyListeners();
    getCategoryProductsDebounced(categoryId);
  }

  void getCategoryProductsDebounced(int? categoryId) {
    final int key = categoryId ?? allCategoryKey;

    if (_categoryProductMap[key] != null || _fetchingCategoryIds.contains(key)) return;

    _categoryProductDebounce.run(() => getCategoryProducts(categoryId, 1));
  }

  Future<void> getCategoryProducts(int? categoryId, int offset) async {
    final int key = categoryId ?? allCategoryKey;

    if (offset == 1) {
      if (_fetchingCategoryIds.contains(key)) return;

      _fetchingCategoryIds.add(key);
      _categoryProductMap[key] = null;
      notifyListeners();

      final ApiResponseModel apiResponse = await wholesaleProductServiceInterface
          .getCategoryProductList(categoryId: categoryId, offset: 1, limit: _defaultLimit);

      if (apiResponse.response?.statusCode == 200) {
        _categoryProductMap[key] = WholesaleProductListModel.fromJson(apiResponse.response?.data);
      } else {
        _categoryProductMap[key] = WholesaleProductListModel(products: []);
        ApiChecker.checkApi(apiResponse);
      }

      _fetchingCategoryIds.remove(key);
      notifyListeners();

    } else {
      final ApiResponseModel apiResponse = await wholesaleProductServiceInterface
          .getCategoryProductList(categoryId: categoryId, offset: offset, limit: _defaultLimit);

      if (apiResponse.response?.statusCode == 200) {
        final WholesaleProductListModel parsed = WholesaleProductListModel.fromJson(apiResponse.response?.data);
        _categoryProductMap[key]?.totalSize = parsed.totalSize;
        _categoryProductMap[key]?.offset = parsed.offset;
        _categoryProductMap[key]?.products?.addAll(parsed.products ?? []);
      } else {
        ApiChecker.checkApi(apiResponse);
      }

      notifyListeners();
    }
  }

  bool _isPaginating = false;
  bool get isPaginating => _isPaginating;

  bool get hasNextPage {
    final WholesaleProductListModel? model = categoryProductsFor(_selectedCategoryId);
    if (model?.totalSize == null) return false;

    final int lastPage = (model!.totalSize! / (model.limit ?? _defaultLimit)).ceil();
    return (model.offset ?? 1) < lastPage;
  }

  Future<void> loadNextPage() async {
    if (_isPaginating || !hasNextPage) return;

    final int? categoryId = _selectedCategoryId;
    final int nextOffset = (categoryProductsFor(categoryId)!.offset ?? 1) + 1;

    _isPaginating = true;
    notifyListeners();

    await getCategoryProducts(categoryId, nextOffset);

    _isPaginating = false;
    notifyListeners();
  }

  WholesaleProductListModel? _recentlyViewedModel;
  WholesaleProductListModel? get recentlyViewedModel => _recentlyViewedModel;
  List<WholesaleProduct>? get recentlyViewedProducts => _recentlyViewedModel?.products;

  WholesaleProductListModel? _recentlyViewedSearchModel;
  WholesaleProductListModel? get recentlyViewedSearchModel => _recentlyViewedSearchModel;

  bool _isLoadingRecentlyViewed = false;

  Future<void> getRecentlyViewedProducts({required bool isLoggedIn, int offset = 1, bool reload = false, String search = ''}) async {
    final bool isSearch = search.isNotEmpty;

    if (!isLoggedIn) {
      _recentlyViewedModel = WholesaleProductListModel(products: []);
      _recentlyViewedSearchModel = null;
      notifyListeners();
      return;
    }

    if (offset == 1) {
      if (isSearch) {
        _recentlyViewedSearchModel = null;
      } else {
        _recentlyViewedSearchModel = null;
        if (_isLoadingRecentlyViewed) return;
        if (_recentlyViewedModel != null && !reload) {
          notifyListeners();
          return;
        }

        _isLoadingRecentlyViewed = true;
        _recentlyViewedModel = null;
      }
      notifyListeners();
    }

    final ApiResponseModel apiResponse = await wholesaleProductServiceInterface.getRecentlyViewedProductList(offset: offset, search: search);

    if (isSearch && _recentlyViewedSearchModel == null && offset != 1) return;

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleProductListModel parsed = WholesaleProductListModel.fromJson(apiResponse.response?.data);
      parsed.products ??= [];

      if (offset == 1) {
        if (isSearch) {
          _recentlyViewedSearchModel = parsed;
        } else {
          _recentlyViewedModel = parsed;
        }
      } else {
        final WholesaleProductListModel? target = isSearch ? _recentlyViewedSearchModel : _recentlyViewedModel;
        target?.products?.addAll(parsed.products!);
        target?.offset = parsed.offset;
        target?.totalSize = parsed.totalSize;
      }
    } else {
      if (offset == 1) {
        if (isSearch) {
          _recentlyViewedSearchModel = WholesaleProductListModel(products: []);
        } else {
          _recentlyViewedModel = WholesaleProductListModel(products: []);
        }
      }
      ApiChecker.checkApi(apiResponse);
    }

    if (!isSearch) _isLoadingRecentlyViewed = false;
    notifyListeners();
  }

  void clearRecentlyViewedSearch() => _recentlyViewedSearchModel = null;

  final Map<String, WholesaleProductListModel?> _sellerProductMap = {};
  final Set<String> _fetchingSellerSlugs = {};

  WholesaleProductListModel? sellerProductsFor(String slug) => _sellerProductMap[slug];

  void clearSellerProductsFor(String slug) => _sellerProductMap.remove(slug);

  Future<void> getSellerProducts(String slug, {int offset = 1, bool reload = false}) async {
    if (offset == 1) {
      if (_fetchingSellerSlugs.contains(slug)) return;
      if (_sellerProductMap[slug] != null && !reload) return;

      _fetchingSellerSlugs.add(slug);
      _sellerProductMap[slug] = null;
      notifyListeners();

      final ApiResponseModel apiResponse = await wholesaleProductServiceInterface
          .getSellerProductList(slug, offset: 1, limit: _defaultLimit);

      if (apiResponse.response?.statusCode == 200) {
        _sellerProductMap[slug] = WholesaleProductListModel.fromJson(apiResponse.response?.data);
      } else {
        _sellerProductMap[slug] = WholesaleProductListModel(products: []);
        if (apiResponse.response?.statusCode != 404) ApiChecker.checkApi(apiResponse);
      }

      _fetchingSellerSlugs.remove(slug);
      notifyListeners();

    } else {
      final ApiResponseModel apiResponse = await wholesaleProductServiceInterface
          .getSellerProductList(slug, offset: offset, limit: _defaultLimit);

      if (apiResponse.response?.statusCode == 200) {
        final WholesaleProductListModel parsed = WholesaleProductListModel.fromJson(apiResponse.response?.data);
        _sellerProductMap[slug]?.totalSize = parsed.totalSize;
        _sellerProductMap[slug]?.offset = parsed.offset;
        _sellerProductMap[slug]?.products?.addAll(parsed.products ?? []);
      } else {
        ApiChecker.checkApi(apiResponse);
      }

      notifyListeners();
    }
  }

  final Map<String, WholesaleProductListModel?> _similarProductMap = {};
  final Set<String> _fetchingSimilarSlugs = {};

  WholesaleProductListModel? similarProductsFor(String slug) => _similarProductMap[slug];

  void clearSimilarProductsFor(String slug) => _similarProductMap.remove(slug);

  Future<void> getSimilarProducts(String slug, {int offset = 1, bool reload = false}) async {
    if (offset == 1) {
      if (_fetchingSimilarSlugs.contains(slug)) return;
      if (_similarProductMap[slug] != null && !reload) return;

      _fetchingSimilarSlugs.add(slug);
      _similarProductMap[slug] = null;
      notifyListeners();

      final ApiResponseModel apiResponse = await wholesaleProductServiceInterface
          .getSimilarProductList(slug, offset: 1, limit: _defaultLimit);

      if (apiResponse.response?.statusCode == 200) {
        _similarProductMap[slug] = WholesaleProductListModel.fromJson(apiResponse.response?.data);
      } else {
        _similarProductMap[slug] = WholesaleProductListModel(products: []);
        if (apiResponse.response?.statusCode != 404) ApiChecker.checkApi(apiResponse);
      }

      _fetchingSimilarSlugs.remove(slug);
      notifyListeners();

    } else {
      final ApiResponseModel apiResponse = await wholesaleProductServiceInterface.getSimilarProductList(slug, offset: offset, limit: _defaultLimit);

      if (apiResponse.response?.statusCode == 200) {
        final WholesaleProductListModel parsed = WholesaleProductListModel.fromJson(apiResponse.response?.data);
        _similarProductMap[slug]?.totalSize = parsed.totalSize;
        _similarProductMap[slug]?.offset = parsed.offset;
        _similarProductMap[slug]?.products?.addAll(parsed.products ?? []);
      } else {
        ApiChecker.checkApi(apiResponse);
      }

      notifyListeners();
    }
  }

  final Map<String, WholesaleProductListModel?> _railProductMap = {};
  final Set<String> _fetchingRailKeys = {};

  static String _railKey(WholesaleProductRailEnum rail, int? categoryId) => '${rail.name}:${categoryId ?? allCategoryKey}';

  WholesaleProductListModel? railProductsFor(WholesaleProductRailEnum rail, {int? categoryId}) => _railProductMap[_railKey(rail, categoryId)];

  void clearRailProductCache() {
    _railProductMap.clear();
    _fetchingRailKeys.clear();
  }

  Future<void> getRailProducts(WholesaleProductRailEnum rail, {int? categoryId, int offset = 1, bool reload = false}) async {
    final String key = _railKey(rail, categoryId);
    final Map<String, dynamic> filterParams = {
      'sort_by': rail.sortBy,
      if (categoryId != null) 'category_id': categoryId,
    };

    if (offset == 1) {
      if (_fetchingRailKeys.contains(key)) return;
      if (_railProductMap[key] != null && !reload) return;

      _fetchingRailKeys.add(key);
      _railProductMap[key] = null;
      notifyListeners();

      final ApiResponseModel apiResponse = await wholesaleProductServiceInterface
          .getProductList(page: 1, limit: _defaultLimit, filterParams: filterParams);

      if (apiResponse.response?.statusCode == 200) {
        _railProductMap[key] = WholesaleProductListModel.fromJson(apiResponse.response?.data);
      } else {
        _railProductMap[key] = WholesaleProductListModel(products: []);
        ApiChecker.checkApi(apiResponse);
      }

      _fetchingRailKeys.remove(key);
      notifyListeners();

    } else {
      final ApiResponseModel apiResponse = await wholesaleProductServiceInterface
          .getProductList(page: offset, limit: _defaultLimit, filterParams: filterParams);

      if (apiResponse.response?.statusCode == 200) {
        final WholesaleProductListModel parsed = WholesaleProductListModel.fromJson(apiResponse.response?.data);
        _railProductMap[key]?.totalSize = parsed.totalSize;
        _railProductMap[key]?.offset = parsed.offset;
        _railProductMap[key]?.products?.addAll(parsed.products ?? []);
      } else {
        ApiChecker.checkApi(apiResponse);
      }

      notifyListeners();
    }
  }

  @override
  void dispose() {
    _categoryProductDebounce.dispose();
    super.dispose();
  }
}
