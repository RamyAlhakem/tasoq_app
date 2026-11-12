import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleShopRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getShopDetails(String slug);

  Future<dynamic> getShopProductList({
    required int shopId,
    required int page,
    int limit = 10,
    String name = '',
    Map<String, dynamic> filterParams = const {},
  });

  Future<dynamic> getShopCouponList(String slug, {int limit = 10});
}
