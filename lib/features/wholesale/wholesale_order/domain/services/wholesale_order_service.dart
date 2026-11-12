import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/repositories/wholesale_order_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/services/wholesale_order_service_interface.dart';

class WholesaleOrderService implements WholesaleOrderServiceInterface {
  final WholesaleOrderRepositoryInterface wholesaleOrderRepositoryInterface;
  WholesaleOrderService({required this.wholesaleOrderRepositoryInterface});

  @override
  Future getOrderList({int offset = 1, int limit = 25, required String status, String? type}) async {
    return await wholesaleOrderRepositoryInterface.getOrderList(offset: offset, limit: limit, status: status, type: type);
  }

  @override
  Future getOrderDetails(int orderId) async {
    return await wholesaleOrderRepositoryInterface.getOrderDetails(orderId);
  }

  @override
  Future getOrderItems(int orderId) async {
    return await wholesaleOrderRepositoryInterface.getOrderItems(orderId);
  }

  @override
  Future getOrderStatusHistory(int orderId, {String? phoneNumber}) async {
    return await wholesaleOrderRepositoryInterface.getOrderStatusHistory(orderId, phoneNumber: phoneNumber);
  }

  @override
  Future trackOrder({required int orderId, String? phoneNumber}) async {
    return await wholesaleOrderRepositoryInterface.trackOrder(orderId: orderId, phoneNumber: phoneNumber);
  }

  @override
  Future getOrderTracking(int orderId, {String? phoneNumber}) async {
    return await wholesaleOrderRepositoryInterface.getOrderTracking(orderId, phoneNumber: phoneNumber);
  }

  @override
  Future getOrderInvoice(int orderId) async {
    return await wholesaleOrderRepositoryInterface.getOrderInvoice(orderId);
  }

  @override
  Future cancelOrder(int orderId) async {
    return await wholesaleOrderRepositoryInterface.cancelOrder(orderId);
  }
}
