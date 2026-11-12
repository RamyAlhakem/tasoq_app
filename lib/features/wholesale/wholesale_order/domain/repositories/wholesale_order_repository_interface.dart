import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleOrderRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getOrderList({int offset = 1, int limit = 25, required String status, String? type});

  Future<dynamic> getOrderDetails(int orderId);

  Future<dynamic> getOrderItems(int orderId);

  Future<dynamic> getOrderStatusHistory(int orderId, {String? phoneNumber});

  Future<dynamic> trackOrder({required int orderId, String? phoneNumber});

  Future<dynamic> getOrderTracking(int orderId, {String? phoneNumber});

  Future<dynamic> getOrderInvoice(int orderId);

  Future<dynamic> cancelOrder(int orderId);
}
