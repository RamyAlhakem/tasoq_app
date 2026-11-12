import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class CouponRepositoryInterface<T> extends RepositoryInterface{

  @override
  Future<dynamic> getList({int? offset = 1, int limit = 25});

  Future<dynamic> getAvailableCouponList();

  Future<dynamic> getSellerCouponList(String slug, int offset, {int limit = 25});

}