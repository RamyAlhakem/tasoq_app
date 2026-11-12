import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/domain/repositories/wholesale_restock_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/domain/services/wholesale_restock_service_interface.dart';

class WholesaleRestockService implements WholesaleRestockServiceInterface {
  final WholesaleRestockRepositoryInterface wholesaleRestockRepositoryInterface;
  WholesaleRestockService({required this.wholesaleRestockRepositoryInterface});

  @override
  Future getRestockRequestList({int? offset = 1}) async {
    return await wholesaleRestockRepositoryInterface.getRestockRequestList(offset: offset);
  }

  @override
  Future deleteRestockRequest({int? id, bool all = false}) async {
    return await wholesaleRestockRepositoryInterface.deleteRestockRequest(id: id, all: all);
  }
}
