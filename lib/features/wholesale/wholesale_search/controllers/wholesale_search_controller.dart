import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/domain/models/suggestion_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/controllers/wholesale_product_listing_mixin.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/domain/models/wholesale_popular_tag_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/domain/services/wholesale_search_service_interface.dart';

class WholesaleSearchController extends ChangeNotifier with WholesaleProductListingMixin {
  final WholesaleSearchServiceInterface wholesaleSearchServiceInterface;

  WholesaleSearchController({required this.wholesaleSearchServiceInterface});

  static const int _maxHistory = 10;
  static const int _maxHistoryTermLength = 60;

  static const Duration _suggestionDelay = Duration(milliseconds: 500);

  Timer? _suggestionTimer;
  Completer<void>? _pendingSuggestion;

  String _query = '';
  String get query => _query;

  List<String> _history = [];
  List<String> get history => List.unmodifiable(_history);

  List<String> _suggestions = [];
  List<String> get suggestions => List.unmodifiable(_suggestions);
  final Map<String, String> _suggestionSlugs = {};

  WholesalePopularTagModel? _popularTagModel;
  WholesalePopularTagModel? get popularTagModel => _popularTagModel;

  bool _isPopularTagsLoading = false;
  bool get isPopularTagsLoading => _isPopularTagsLoading;

  Future<void> getPopularTags({int limit = 10}) async {
    _isPopularTagsLoading = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleSearchServiceInterface.getPopularTags(limit: limit);

    if (apiResponse.response?.statusCode == 200) {
      _popularTagModel = WholesalePopularTagModel.fromJson(apiResponse.response!.data);
    }

    _isPopularTagsLoading = false;
    notifyListeners();
  }

  void initHistory() {
    _history = wholesaleSearchServiceInterface.getSavedSearchNames();
    notifyListeners();
  }

  Future<void> saveSearchName(String term) async {
    final String value = term.trim();
    if (value.isEmpty) return;

    _history.removeWhere((saved) => saved.toLowerCase() == value.toLowerCase());
    _history.insert(0, value.length > _maxHistoryTermLength ? value.substring(0, _maxHistoryTermLength) : value);
    if (_history.length > _maxHistory) _history = _history.sublist(0, _maxHistory);

    notifyListeners();
    await wholesaleSearchServiceInterface.setSavedSearchNames(List.of(_history));
  }

  Future<void> removeSearchName(int index) async {
    if (index < 0 || index >= _history.length) return;

    _history.removeAt(index);
    notifyListeners();
    await wholesaleSearchServiceInterface.setSavedSearchNames(List.of(_history));
  }

  Future<void> clearHistory() async {
    _history = [];
    notifyListeners();
    await wholesaleSearchServiceInterface.setSavedSearchNames(const []);
  }

  void onQueryChanged(String value) {
    _query = value;

    if (value.trim().isEmpty) {
      _suggestions = [];
      _suggestionSlugs.clear();
    }
    notifyListeners();
  }

  Future<List<String>> fetchSuggestions(String name) async {
    final String term = name.trim();

    if (term.isEmpty) {
      _suggestions = [];
      _suggestionSlugs.clear();
      return const [];
    }

    _suggestionTimer?.cancel();
    if (_pendingSuggestion?.isCompleted == false) _pendingSuggestion!.complete();

    final Completer<void> settle = Completer<void>();
    _pendingSuggestion = settle;
    _suggestionTimer = Timer(_suggestionDelay, () {
      if (!settle.isCompleted) settle.complete();
    });

    await settle.future;

    if (!identical(_pendingSuggestion, settle)) return _suggestions;

    await getSuggestions(term);
    return _suggestions;
  }

  Future<void> getSuggestions(String name) async {
    if (name.trim().isEmpty) return;

    final ApiResponseModel apiResponse = await wholesaleSearchServiceInterface.getSuggestionProductName(name, limit: WholesaleProductListingMixin.kLimit);

    if (apiResponse.response?.statusCode == 200) {
      final SuggestionModel parsed = SuggestionModel.fromJson(apiResponse.response?.data);

      _suggestions = [];
      _suggestionSlugs.clear();
      for (final Products product in parsed.products ?? const <Products>[]) {
        if (product.name == null) continue;
        _suggestions.add(product.name!);
        if (product.slug != null) _suggestionSlugs[product.name!] = product.slug!;
      }
      notifyListeners();
    }
  }

  String? slugOfSuggestion(String name) => _suggestionSlugs[name];

  Future<void> submitSearch(String term) async {
    _query = term.trim();
    await saveSearchName(_query);
    await searchProduct(page: 1);
  }

  @override
  Future<ApiResponseModel> fetchProductPage({
    required int page,
    required int limit,
    required Map<String, dynamic> filterParams,
  }) async {
    return await wholesaleSearchServiceInterface.getSearchProductList(
      name: _query, page: page, limit: limit, filterParams: filterParams,
    );
  }

  Future<void> searchProduct({required int page}) => loadProducts(page: page);

  void cleanSearch({bool notify = false}) {
    _query = '';
    _suggestions = [];
    _suggestionSlugs.clear();
    resetList();
    if (notify) notifyListeners();
  }

  @override
  void dispose() {
    _suggestionTimer?.cancel();
    if (_pendingSuggestion?.isCompleted == false) _pendingSuggestion!.complete();
    super.dispose();
  }
}
