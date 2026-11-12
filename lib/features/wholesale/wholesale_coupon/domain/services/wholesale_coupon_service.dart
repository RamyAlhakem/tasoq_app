import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/domain/repositories/wholesale_coupon_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/domain/services/wholesale_coupon_service_interface.dart';

class WholesaleCouponService implements WholesaleCouponServiceInterface {
  final WholesaleCouponRepositoryInterface wholesaleCouponRepositoryInterface;
  WholesaleCouponService({required this.wholesaleCouponRepositoryInterface});

  @override
  Future getCouponList({int offset = 1, int limit = 25, String? search, String? sortBy}) async {
    return await wholesaleCouponRepositoryInterface.getCouponList(offset: offset, limit: limit, search: search, sortBy: sortBy);
  }

  @override
  Future getShopCouponList(String slug, {int offset = 1, int limit = 25, String? search, String? sortBy}) async {
    return await wholesaleCouponRepositoryInterface.getShopCouponList(slug, offset: offset, limit: limit, search: search, sortBy: sortBy);
  }

  @override
  Future getApplicableCoupons() async {
    return await wholesaleCouponRepositoryInterface.getApplicableCoupons();
  }
}
