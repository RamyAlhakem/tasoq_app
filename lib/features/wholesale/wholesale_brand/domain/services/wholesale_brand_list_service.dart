import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/repositories/wholesale_brand_list_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/services/wholesale_brand_list_service_interface.dart';

class WholesaleBrandListService implements WholesaleBrandListServiceInterface {
  final WholesaleBrandListRepositoryInterface wholesaleBrandListRepositoryInterface;
  WholesaleBrandListService({required this.wholesaleBrandListRepositoryInterface});

  @override
  Future getBrandList({int offset = 1, int limit = 25}) async {
    return await wholesaleBrandListRepositoryInterface.getBrandList(offset: offset, limit: limit);
  }

  @override
  Future getBrandProductList({
    required int brandId,
    required int page,
    int limit = 10,
    Map<String, dynamic> filterParams = const {},
  }) async {
    return await wholesaleBrandListRepositoryInterface.getBrandProductList(
      brandId: brandId, page: page, limit: limit, filterParams: filterParams,
    );
  }
}
