import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleProductRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getCategoryProductList({int? categoryId, int offset = 1, int limit = 10});

  Future<dynamic> getProductList({
    required int page,
    int limit = 10,
    String name = '',
    Map<String, dynamic> filterParams = const {},
  });
  Future<dynamic> getRecentlyViewedProductList({int offset = 1, String search = ''});
  Future<dynamic> getSellerProductList(String slug, {int offset = 1, int limit = 10});
  Future<dynamic> getSimilarProductList(String slug, {int offset = 1, int limit = 10});
}
