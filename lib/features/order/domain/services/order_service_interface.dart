abstract class OrderServiceInterface{

  Future<dynamic> getOrderList(int offset, String status, {String? type});

  Future<dynamic> cancelOrder(int? orderId);
}