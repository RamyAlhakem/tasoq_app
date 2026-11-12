import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/domain/repositories/wholesale_shop_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/domain/services/wholesale_shop_service_interface.dart';

class WholesaleShopService implements WholesaleShopServiceInterface {
  final WholesaleShopRepositoryInterface wholesaleShopRepositoryInterface;

  WholesaleShopService({required this.wholesaleShopRepositoryInterface});

  @override
  Future getShopDetails(String slug) async {
    return await wholesaleShopRepositoryInterface.getShopDetails(slug);
  }

  @override
  Future getShopProductList({
    required int shopId,
    required int page,
    int limit = 10,
    String name = '',
    Map<String, dynamic> filterParams = const {},
  }) async {
    return await wholesaleShopRepositoryInterface.getShopProductList(
      shopId: shopId, page: page, limit: limit, name: name, filterParams: filterParams,
    );
  }

  @override
  Future getShopCouponList(String slug, {int limit = 10}) async {
    return await wholesaleShopRepositoryInterface.getShopCouponList(slug, limit: limit);
  }
}
