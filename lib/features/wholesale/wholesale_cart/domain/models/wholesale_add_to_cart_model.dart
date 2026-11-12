import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_list_model.dart';

class WholesaleCartLine {
  final int? id;
  final int? productId;
  final String? name;
  final String? variant;
  final int quantity;
  final double price;
  final double discount;
  final double tax;

  const WholesaleCartLine({
    this.id,
    this.productId,
    this.name,
    this.variant,
    this.quantity = 0,
    this.price = 0,
    this.discount = 0,
    this.tax = 0,
  });

  factory WholesaleCartLine.fromJson(Map<String, dynamic> json) {
    return WholesaleCartLine(
      id: _toInt(json['id']),
      productId: _toInt(json['product_id']),
      name: json['name']?.toString(),
      variant: json['variant']?.toString(),
      quantity: _toInt(json['quantity']) ?? 0,
      price: _toDouble(json['price']),
      discount: _toDouble(json['discount']),
      tax: _toDouble(json['tax']),
    );
  }
}

class WholesaleAddToCartResult {
  final int? statusCode;
  final WholesaleCartLine? line;

  final String? redirectTo;
  final String? errorCode;
  final String? message;

  final List<WholesaleCartShippingMethod> shippingMethods;
  final bool requiresShippingMethod;

  const WholesaleAddToCartResult({
    this.statusCode,
    this.line,
    this.redirectTo,
    this.errorCode,
    this.message,
    this.shippingMethods = const [],
    this.requiresShippingMethod = false,
  });

  bool get isSuccess => statusCode == 200 && !requiresShippingMethod;

  bool get redirectsToCheckout => redirectTo == 'checkout';

  bool get isQuantityIssue => const {'below_minimum_order', 'above_maximum_quantity', 'exceeds_stock'}.contains(errorCode);

  bool get isStale => statusCode == 404 || const {'variation_unavailable', 'out_of_stock'}.contains(errorCode);

  factory WholesaleAddToCartResult.fromResponse(int? statusCode, dynamic data) {
    if (data is! Map) return WholesaleAddToCartResult(statusCode: statusCode);

    final dynamic content = data['content'];
    final dynamic lineJson = content is Map ? content['data'] : null;

    String? errorCode;
    String? errorMessage;
    final dynamic errors = data['errors'];
    if (errors is List && errors.isNotEmpty && errors.first is Map) {
      errorCode = (errors.first as Map)['error_code']?.toString();
      errorMessage = (errors.first as Map)['message']?.toString();
    }

    final bool requiresShippingMethod = data['identical_code'] == 'cart_shipping_method_required_200';
    final dynamic methodsJson = lineJson is Map ? lineJson['shipping_method_list'] : null;

    return WholesaleAddToCartResult(
      statusCode: statusCode,
      requiresShippingMethod: requiresShippingMethod,
      shippingMethods: methodsJson is List
          ? methodsJson.whereType<Map>().map((m) => WholesaleCartShippingMethod.fromJson(Map<String, dynamic>.from(m))).toList()
          : const [],
      line: !requiresShippingMethod && lineJson is Map ? WholesaleCartLine.fromJson(Map<String, dynamic>.from(lineJson)) : null,
      redirectTo: content is Map ? content['redirect_to']?.toString() : null,
      errorCode: errorCode,
      message: errorMessage ?? data['message']?.toString(),
    );
  }
}

int? _toInt(dynamic value) => value is int ? value : int.tryParse('${value ?? ''}');

double _toDouble(dynamic value) => value is num ? value.toDouble() : double.tryParse('${value ?? ''}') ?? 0;
