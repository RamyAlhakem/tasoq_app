import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleCouponRepositoryInterface extends RepositoryInterface {

  Future<dynamic> getCouponList({int offset = 1, int limit = 25, String? search, String? sortBy});

  Future<dynamic> getShopCouponList(String slug, {int offset = 1, int limit = 25, String? search, String? sortBy});

  Future<dynamic> getApplicableCoupons();
}
