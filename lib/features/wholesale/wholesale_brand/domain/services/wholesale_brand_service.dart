import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/repositories/wholesale_brand_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/services/wholesale_brand_service_interface.dart';

class WholesaleBrandService implements WholesaleBrandServiceInterface {
  final WholesaleBrandRepositoryInterface wholesaleBrandRepositoryInterface;
  WholesaleBrandService({required this.wholesaleBrandRepositoryInterface});

  @override
  Future getBrandList({int offset = 1, int limit = 25}) async {
    return await wholesaleBrandRepositoryInterface.getBrandList(offset: offset, limit: limit);
  }
}
