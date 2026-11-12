abstract class WholesaleBrandListServiceInterface {

  Future<dynamic> getBrandList({int offset = 1, int limit = 25});

  Future<dynamic> getBrandProductList({
    required int brandId,
    required int page,
    int limit = 10,
    Map<String, dynamic> filterParams = const {},
  });
}
