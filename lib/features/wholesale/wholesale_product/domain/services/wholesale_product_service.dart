import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/domain/repositories/wholesale_product_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/domain/services/wholesale_product_service_interface.dart';

class WholesaleProductService implements WholesaleProductServiceInterface {
  final WholesaleProductRepositoryInterface wholesaleProductRepositoryInterface;
  WholesaleProductService({required this.wholesaleProductRepositoryInterface});

  @override
  Future getCategoryProductList({int? categoryId, int offset = 1, int limit = 10}) async {
    return await wholesaleProductRepositoryInterface.getCategoryProductList(categoryId: categoryId, offset: offset, limit: limit);
  }

  @override
  Future getProductList({
    required int page,
    int limit = 10,
    String name = '',
    Map<String, dynamic> filterParams = const {},
  }) async {
    return await wholesaleProductRepositoryInterface.getProductList(page: page, limit: limit, name: name, filterParams: filterParams);
  }

  @override
  Future getRecentlyViewedProductList({int offset = 1, String search = ''}) async {
    return await wholesaleProductRepositoryInterface.getRecentlyViewedProductList(offset: offset, search: search);
  }

  @override
  Future getSellerProductList(String slug, {int offset = 1, int limit = 10}) async {
    return await wholesaleProductRepositoryInterface.getSellerProductList(slug, offset: offset, limit: limit);
  }

  @override
  Future getSimilarProductList(String slug, {int offset = 1, int limit = 10}) async {
    return await wholesaleProductRepositoryInterface.getSimilarProductList(slug, offset: offset, limit: limit);
  }
}
