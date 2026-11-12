import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/domain/repositories/wholesale_search_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/domain/services/wholesale_search_service_interface.dart';

class WholesaleSearchService implements WholesaleSearchServiceInterface {
  final WholesaleSearchRepositoryInterface wholesaleSearchRepositoryInterface;

  WholesaleSearchService({required this.wholesaleSearchRepositoryInterface});

  @override
  Future getSearchProductList({
    String name = '',
    required int page,
    int limit = 10,
    Map<String, dynamic> filterParams = const {},
  }) async {
    return await wholesaleSearchRepositoryInterface.getSearchProductList(
      name: name, page: page, limit: limit, filterParams: filterParams,
    );
  }

  @override
  Future getSuggestionProductName(String name, {int limit = 10}) async {
    return await wholesaleSearchRepositoryInterface.getSuggestionProductName(name, limit: limit);
  }

  @override
  Future getPopularTags({int limit = 10}) async {
    return await wholesaleSearchRepositoryInterface.getPopularTags(limit: limit);
  }

  @override
  Future<void> saveSearchName(String name) async {
    return await wholesaleSearchRepositoryInterface.saveSearchName(name);
  }

  @override
  List<String> getSavedSearchNames() {
    return wholesaleSearchRepositoryInterface.getSavedSearchNames();
  }

  @override
  Future<bool> setSavedSearchNames(List<String> names) async {
    return await wholesaleSearchRepositoryInterface.setSavedSearchNames(names);
  }
}
