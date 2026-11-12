abstract class WholesaleSearchServiceInterface {
  Future<dynamic> getSearchProductList({
    String name = '',
    required int page,
    int limit = 10,
    Map<String, dynamic> filterParams = const {},
  });

  Future<dynamic> getSuggestionProductName(String name, {int limit = 10});

  Future<dynamic> getPopularTags({int limit = 10});

  Future<void> saveSearchName(String name);

  List<String> getSavedSearchNames();

  Future<bool> setSavedSearchNames(List<String> names);
}
