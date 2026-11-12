import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_response_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_price_quote_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_purchase_options_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/services/wholesale_product_details_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_color_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';

class WholesaleProductDetailsController extends ChangeNotifier {
  final WholesaleProductDetailsServiceInterface wholesaleProductDetailsServiceInterface;

  WholesaleProductDetailsController({required this.wholesaleProductDetailsServiceInterface});

  WholesaleProductDetailsModel? _product;
  WholesaleProductDetailsModel? get product => _product;

  bool _isNotFound = false;
  bool get isNotFound => _isNotFound;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Map<String, String> _selection = {};
  Map<String, String> get selection => Map.unmodifiable(_selection);

  WholesalePriceQuote? _quote;
  WholesalePriceQuote? get quote => _quote;

  int _quantity = 1;
  int get quantity => _quantity;

  final Set<String> _restockRequestedVariants = {};
  bool isRestockRequested(String? variantKey) => _restockRequestedVariants.contains(variantKey ?? '');
  void markRestockRequested(String? variantKey) {
    if (_restockRequestedVariants.add(variantKey ?? '')) notifyListeners();
  }

  List<String> _selectedOptionImages = [];
  List<String> get selectedOptionImages => List.unmodifiable(_selectedOptionImages);

  List<ColorsModel>? _colorCatalogue;

  Future<void> getProductDetails(String slug, {List<ColorsModel>? colorCatalogue, bool reload = false}) async {
    if (_isLoading) return;
    if (_product != null && !reload) return;

    _isLoading = true;
    _isNotFound = false;
    _product = null;
    _colorCatalogue = colorCatalogue;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleProductDetailsServiceInterface.getProductDetails(slug);

    if (apiResponse.response?.statusCode == 200) {
      final dynamic data = apiResponse.response?.data;
      final dynamic content = data is Map ? (data['content'] is Map ? data['content']['data'] : data['data']) : null;

      if (content is Map) {
        _product = WholesaleProductDetailsModel.fromJson(Map<String, dynamic>.from(content));
        _applyDefaults();
      } else {
        _isNotFound = true;
      }
    } else if (apiResponse.response?.statusCode == 404) {
      _isNotFound = true;
    } else {
      _isNotFound = true;
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  void _applyDefaults() {
    final WholesalePurchaseOptions? options = _product?.purchaseOptions;

    _selection.clear();
    _selectedOptionImages = [];
    _quote = _product?.defaultQuote;

    options?.defaultSelection.forEach((axisKey, value) {
      _selection[axisKey] = _postedValue(axisKey, value);
    });

    final int minimum = _quote?.minimumQuantity ?? options?.minimumOrderQty ?? _product?.minimumOrderQuantity ?? 1;
    _quantity = (_quote?.inCart ?? false) && (_quote?.inCartQuantity ?? 0) > 0 ? _quote!.inCartQuantity : minimum;

    _refreshSelectedOptionImages();
  }

  String _postedValue(String axisKey, String rawValue) {
    if (!_isColorAxis(axisKey)) return rawValue;
    return WholesaleColorHelper.codeForName(_colorCatalogue, rawValue) ?? rawValue;
  }

  bool _isColorAxis(String axisKey) {
    final List<WholesaleVariationAxis> axes = _product?.purchaseOptions?.axes ?? const [];
    for (final WholesaleVariationAxis axis in axes) {
      if (axis.key == axisKey) return axis.isColorAxis;
    }
    return false;
  }

  void selectOption(WholesaleVariationAxis axis, WholesaleAxisOption option) {
    final String posted = _postedValue(axis.key, option.value);
    if (_selection[axis.key] == posted) return;

    _selection[axis.key] = posted;
    _refreshSelectedOptionImages();
    notifyListeners();
    refreshQuote();
  }

  Future<void> setQuantity(int quantity, {bool debounce = true}) async {
    if (quantity < 1 || _quantity == quantity) return;

    _quantity = quantity;
    notifyListeners();

    if (debounce) {
      _quoteDebounce.run(refreshQuote);
    } else {
      _quoteDebounce.dispose();
      await refreshQuote();
    }
  }

  Future<void> selectTier(WholesalePriceTier tier) => setQuantity(tier.minQty, debounce: false);

  Future<void> applyDiscountHighlight(WholesaleDiscountHighlightItem item) async {
    final String? axisKey = _product?.purchaseOptions?.discountHighlights?.axisKey;
    final String raw = item.variationValue ?? item.value ?? '';
    if (axisKey == null || raw.isEmpty) return;

    _selection[axisKey] = _postedValue(axisKey, raw);

    if ((item.minQty ?? 0) > 0) _quantity = item.minQty!;

    _refreshSelectedOptionImages();
    notifyListeners();

    _quoteDebounce.dispose();
    await refreshQuote();
  }

  final DebounceHelper _quoteDebounce = DebounceHelper(milliseconds: 250);

  bool _isQuoting = false;
  bool get isQuoting => _isQuoting;

  int _quoteRequestId = 0;

  Future<void> refreshQuote() async {
    final int? productId = _product?.id;
    if (productId == null) return;

    final int requestId = ++_quoteRequestId;
    _isQuoting = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleProductDetailsServiceInterface
        .getPriceQuote(productId, quantity: _quantity, variation: _selection);

    if (requestId != _quoteRequestId) return;

    if (apiResponse.response?.statusCode == 200) {
      final dynamic data = apiResponse.response?.data;
      final dynamic content = data is Map ? (data['content'] is Map ? data['content']['data'] : data['data']) : null;

      if (content is Map) {
        _quote = WholesalePriceQuote.fromJson(Map<String, dynamic>.from(content));
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isQuoting = false;
    notifyListeners();
  }

  Color? swatchFor(WholesaleAxisOption option) => WholesaleColorHelper.swatchForName(_colorCatalogue, option.value);

  bool isSelected(WholesaleVariationAxis axis, WholesaleAxisOption option) =>
      _selection[axis.key] == _postedValue(axis.key, option.value);

  void _refreshSelectedOptionImages() {
    final Map<String, Map<String, List<String>>> images = _product?.purchaseOptions?.images ?? const {};

    for (final MapEntry<String, String> entry in _selection.entries) {
      final List<String>? urls = images[entry.key]?[entry.value];
      if (urls != null && urls.isNotEmpty) {
        _selectedOptionImages = urls;
        return;
      }
    }
    _selectedOptionImages = [];
  }

  List<WholesaleVariationAxis> get axes => _product?.purchaseOptions?.axes ?? const [];

  List<String> get selectionLabels => [
        for (final WholesaleVariationAxis axis in axes)
          if (_selection[axis.key] != null)
            axis.isColorAxis
                ? WholesaleColorHelper.nameForCode(_colorCatalogue, _selection[axis.key]!) ?? _selection[axis.key]!
                : _selection[axis.key]!,
      ];


  WholesalePriceRow? get activePriceRow {
    final WholesalePurchaseOptions? options = _product?.purchaseOptions;
    final List<WholesalePriceRow> rows = options?.priceRows ?? const [];
    if (rows.isEmpty) return null;

    final String? priceAxis = options?.priceAxis;
    if (priceAxis == null) return rows.first;

    final String? posted = _selection[priceAxis];
    if (posted == null) return null;

    final String selected = (_isColorAxis(priceAxis) ? WholesaleColorHelper.nameForCode(_colorCatalogue, posted) ?? posted : posted).trim();

    for (final WholesalePriceRow row in rows) {
      if ((row.variationValue ?? '').trim() == selected) return row;
    }
    return null;
  }

  List<WholesaleVariationAxis> get imageAxes {
    final Map<String, Map<String, List<String>>> images = _product?.purchaseOptions?.images ?? const {};
    return axes.where((axis) => (images[axis.key]?.isNotEmpty ?? false)).toList();
  }

  List<String> imagesForAxis(WholesaleVariationAxis axis) {
    final String? selected = _selection[axis.key];
    if (selected == null) return const [];
    return _product?.purchaseOptions?.images[axis.key]?[selected] ?? const [];
  }

  static const int _reviewLimit = 10;

  String? _reviewSlug;
  ReviewResponseModel? _reviewResponse;
  List<ReviewModel>? _reviews;
  List<ReviewModel>? get reviews => _reviews;

  int _reviewPage = 1;
  bool _isReviewLoading = false;
  bool get isReviewLoading => _isReviewLoading;

  int get totalReviews => _reviewResponse?.totalSize ?? 0;
  double get averageRating => double.tryParse(_reviewResponse?.averageRating ?? '') ?? 0;
  bool get hasMoreReviews => (_reviews?.length ?? 0) < totalReviews;

  int reviewCountFor(int star) =>
      _reviewResponse?.groupWiseRating?.firstWhere((g) => g.rating == star, orElse: () => GroupWiseRating()).total ?? 0;

  bool hasReviewsFor(String slug) => _reviewSlug == slug && _reviews != null;

  Future<void> getProductReviews(String slug, {int offset = 1}) async {
    if (_isReviewLoading) return;

    if (offset == 1) {
      _reviewSlug = slug;
      _reviews = null;
      _reviewResponse = null;
    }
    _isReviewLoading = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleProductDetailsServiceInterface.getProductReviews(slug, offset: offset, limit: _reviewLimit);

    if (_reviewSlug == slug) {
      if (apiResponse.response?.statusCode == 200) {
        final ReviewResponseModel parsed = ReviewResponseModel.fromJson(Map<String, dynamic>.from(apiResponse.response!.data));
        _reviewResponse = parsed;
        _reviewPage = offset;
        _reviews = offset == 1 ? (parsed.reviews ?? []) : [...?_reviews, ...?parsed.reviews];
      } else {
        _reviews ??= [];
        ApiChecker.checkApi(apiResponse);
      }
    }

    _isReviewLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreReviews() async {
    final String? slug = _reviewSlug;
    if (slug == null || !hasMoreReviews) return;
    await getProductReviews(slug, offset: _reviewPage + 1);
  }

  void reset() {
    _product = null;
    _quote = null;
    _isNotFound = false;
    _quantity = 1;
    _selection.clear();
    _selectedOptionImages = [];
    _colorCatalogue = null;
    _quoteDebounce.dispose();
    _quoteRequestId = 0;
    _restockRequestedVariants.clear();
    _reviewSlug = null;
    _reviewResponse = null;
    _reviews = null;
    _reviewPage = 1;
    _isReviewLoading = false;
  }
}
