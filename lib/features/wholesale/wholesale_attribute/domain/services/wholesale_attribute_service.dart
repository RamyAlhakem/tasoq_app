import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_attribute/domain/repositories/wholesale_attribute_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_attribute/domain/services/wholesale_attribute_service_interface.dart';

class WholesaleAttributeService implements WholesaleAttributeServiceInterface {
  final WholesaleAttributeRepositoryInterface wholesaleAttributeRepositoryInterface;
  WholesaleAttributeService({required this.wholesaleAttributeRepositoryInterface});

  @override
  Future getAttributeList({int offset = 1, int limit = 25}) async {
    return await wholesaleAttributeRepositoryInterface.getAttributeList(offset: offset, limit: limit);
  }
}
