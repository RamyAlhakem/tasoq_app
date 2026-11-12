import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/domain/models/wholesale_product_filter_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';

enum WholesaleProductListState { idle, loading, loaded, empty, error }

mixin WholesaleProductListingMixin on ChangeNotifier {
  static const int kLimit = 10;

  WholesaleProductListModel? _resultModel;
  WholesaleProductListModel? get resultModel => _resultModel;
  List<WholesaleProduct> get products => _resultModel?.products ?? const [];

  WholesalePriceBounds? _priceBounds;
  WholesalePriceBounds? get priceBounds => _priceBounds;

  WholesaleProductFilterModel _filter = const WholesaleProductFilterModel();
  WholesaleProductFilterModel get filter => _filter;
  bool get isFilterApplied => _filter.activeFilterCount > 0;
  bool get isSortApplied => _filter.isSortApplied;

  bool _hasLoaded = false;
  bool _isListLoading = false;
  bool get isListLoading => _isListLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  WholesaleProductListState get listState {
    if (!_hasLoaded) return WholesaleProductListState.idle;
    if (_isListLoading && products.isEmpty) return WholesaleProductListState.loading;
    if (_errorMessage != null && products.isEmpty) return WholesaleProductListState.error;
    if (products.isEmpty) return WholesaleProductListState.empty;
    return WholesaleProductListState.loaded;
  }

  Future<ApiResponseModel> fetchProductPage({
    required int page,
    required int limit,
    required Map<String, dynamic> filterParams,
  });

  void onPaginationFailed(String message) {}

  void applyFilter(WholesaleProductFilterModel filter) => _filter = filter;

  void applySort(WholesaleSortOption sort) => _filter = _filter.copyWith(sort: sort);

  void clearFilter() => _filter = _filter.cleared();

  void setFilter(WholesaleProductFilterModel filter) => _filter = filter;

  void resetList({bool notify = false}) {
    _resultModel = null;
    _hasLoaded = false;
    _isListLoading = false;
    _errorMessage = null;
    _filter = _filter.cleared();
    if (notify) notifyListeners();
  }

  Future<void> loadProducts({required int page}) async {
    if (page == 1) {
      _hasLoaded = true;
      _isListLoading = true;
      _errorMessage = null;
      _resultModel = null;
      notifyListeners();
    }

    final ApiResponseModel apiResponse = await fetchProductPage(
      page: page, limit: kLimit, filterParams: _filter.toQueryParams(),
    );

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleProductListModel parsed = WholesaleProductListModel.fromJson(apiResponse.response?.data);
      parsed.products ??= [];

      _priceBounds = parsed.priceBounds ?? _priceBounds;

      if (page == 1) {
        _resultModel = parsed;
      } else {
        _resultModel?.products?.addAll(parsed.products ?? []);
        _resultModel?.offset = parsed.offset;
        _resultModel?.limit = parsed.limit;
        _resultModel?.totalSize = parsed.totalSize;
      }
      _errorMessage = null;
    } else {
      final String message = _messageOf(apiResponse);
      if (page == 1) {
        _errorMessage = message;
      } else {
        onPaginationFailed(message);
      }
    }

    _isListLoading = false;
    notifyListeners();
  }

  String _messageOf(ApiResponseModel apiResponse) {
    final dynamic error = apiResponse.error;
    if (error is String && error.isNotEmpty) return error;
    return 'something_went_wrong';
  }
}
