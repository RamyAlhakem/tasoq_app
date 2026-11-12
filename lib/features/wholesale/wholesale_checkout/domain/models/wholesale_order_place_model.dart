class WholesaleOrderPlaceOrder {
  final int? id;
  final String? shopName;
  final double total;
  final String? totalLabel;
  final String? paymentMethod;
  final String? orderStatus;
  final String? paymentStatus;

  const WholesaleOrderPlaceOrder({
    this.id,
    this.shopName,
    this.total = 0,
    this.totalLabel,
    this.paymentMethod,
    this.orderStatus,
    this.paymentStatus,
  });

  factory WholesaleOrderPlaceOrder.fromJson(Map<String, dynamic> json) {
    return WholesaleOrderPlaceOrder(
      id: _toInt(json['id']),
      shopName: json['shop_name']?.toString(),
      total: _toDouble(json['total']),
      totalLabel: json['total_label']?.toString(),
      paymentMethod: json['payment_method']?.toString(),
      orderStatus: json['order_status']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
    );
  }
}

class WholesaleOrderPlaceModel {
  final String? orderGroupId;
  final List<WholesaleOrderPlaceOrder> orders;
  final double grandTotal;
  final String? grandTotalLabel;

  const WholesaleOrderPlaceModel({
    this.orderGroupId,
    this.orders = const [],
    this.grandTotal = 0,
    this.grandTotalLabel,
  });

  String? get orderIdsLabel =>
      orders.isEmpty ? null : orders.map((o) => o.id).whereType<int>().join(', ');

  factory WholesaleOrderPlaceModel.fromJson(Map<String, dynamic> json) {
    return WholesaleOrderPlaceModel(
      orderGroupId: json['order_group_id']?.toString(),
      orders: _toMapList(json['orders']).map(WholesaleOrderPlaceOrder.fromJson).toList(),
      grandTotal: _toDouble(json['grand_total']),
      grandTotalLabel: json['grand_total_label']?.toString(),
    );
  }
}

class WholesaleOrderPlaceResult {
  final int? statusCode;
  final WholesaleOrderPlaceModel? order;
  final String? errorCode;
  final String? message;

  const WholesaleOrderPlaceResult({this.statusCode, this.order, this.errorCode, this.message});

  bool get isSuccess => statusCode == 200 && order != null;

  bool get isInProgress => statusCode == 409 || errorCode == 'order_placement_in_progress';

  factory WholesaleOrderPlaceResult.fromResponse(int? statusCode, dynamic data) {
    if (data is! Map) return WholesaleOrderPlaceResult(statusCode: statusCode);

    final dynamic content = data['content'];
    final dynamic orderJson = content is Map ? content['data'] : null;

    String? errorCode;
    String? errorMessage;
    final dynamic errors = data['errors'];
    if (errors is List && errors.isNotEmpty && errors.first is Map) {
      errorCode = (errors.first as Map)['error_code']?.toString();
      errorMessage = (errors.first as Map)['message']?.toString();
    }

    return WholesaleOrderPlaceResult(
      statusCode: statusCode,
      order: orderJson is Map ? WholesaleOrderPlaceModel.fromJson(Map<String, dynamic>.from(orderJson)) : null,
      errorCode: errorCode,
      message: errorMessage ?? data['message']?.toString(),
    );
  }
}

class WholesaleDigitalPaymentLinkResult {
  final int? statusCode;
  final String? redirectLink;
  final String? errorCode;
  final String? message;

  const WholesaleDigitalPaymentLinkResult({this.statusCode, this.redirectLink, this.errorCode, this.message});

  bool get isSuccess => statusCode == 200 && (redirectLink?.isNotEmpty ?? false);

  factory WholesaleDigitalPaymentLinkResult.fromResponse(int? statusCode, dynamic data) {
    if (data is! Map) return WholesaleDigitalPaymentLinkResult(statusCode: statusCode);

    final dynamic content = data['content'];
    final dynamic linkJson = content is Map ? content['data'] : null;

    String? errorCode;
    String? errorMessage;
    final dynamic errors = data['errors'];
    if (errors is List && errors.isNotEmpty && errors.first is Map) {
      errorCode = (errors.first as Map)['error_code']?.toString();
      errorMessage = (errors.first as Map)['message']?.toString();
    }

    return WholesaleDigitalPaymentLinkResult(
      statusCode: statusCode,
      redirectLink: linkJson is Map ? linkJson['redirect_link']?.toString() : null,
      errorCode: errorCode,
      message: errorMessage ?? data['message']?.toString(),
    );
  }
}

int? _toInt(dynamic value) => value is int ? value : int.tryParse('${value ?? ''}');

double _toDouble(dynamic value) => value is num ? value.toDouble() : double.tryParse('${value ?? ''}') ?? 0;

List<Map<String, dynamic>> _toMapList(dynamic value) =>
    value is List ? value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList() : const [];
