int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

class WholesaleRefundInfoModel {
  final int? orderId;
  final int? orderDetailsId;
  final bool alreadyRequested;
  final bool expired;
  final bool isRefundable;
  final int? refundDayLimit;
  final WholesaleRefundBreakdown? refund;

  const WholesaleRefundInfoModel({
    this.orderId,
    this.orderDetailsId,
    this.alreadyRequested = false,
    this.expired = false,
    this.isRefundable = false,
    this.refundDayLimit,
    this.refund,
  });

  factory WholesaleRefundInfoModel.fromJson(Map<String, dynamic> json) {
    return WholesaleRefundInfoModel(
      orderId: _toInt(json['order_id']),
      orderDetailsId: _toInt(json['order_details_id']),
      alreadyRequested: json['already_requested'] == true,
      expired: json['expired'] == true,
      isRefundable: json['is_refundable'] == true,
      refundDayLimit: _toInt(json['refund_day_limit']),
      refund: json['refund'] is Map ? WholesaleRefundBreakdown.fromJson(Map<String, dynamic>.from(json['refund'])) : null,
    );
  }
}

class WholesaleRefundBreakdown {
  final double productPrice;
  final int quantity;
  final double productDiscount;
  final double tax;
  final double subtotal;
  final double couponDiscount;
  final double referralDiscount;
  final double refundAmount;

  const WholesaleRefundBreakdown({
    this.productPrice = 0,
    this.quantity = 0,
    this.productDiscount = 0,
    this.tax = 0,
    this.subtotal = 0,
    this.couponDiscount = 0,
    this.referralDiscount = 0,
    this.refundAmount = 0,
  });

  factory WholesaleRefundBreakdown.fromJson(Map<String, dynamic> json) {
    return WholesaleRefundBreakdown(
      productPrice: _toDouble(json['product_price']) ?? 0,
      quantity: _toInt(json['quantity']) ?? 0,
      productDiscount: _toDouble(json['product_discount']) ?? 0,
      tax: _toDouble(json['tax']) ?? 0,
      subtotal: _toDouble(json['subtotal']) ?? 0,
      couponDiscount: _toDouble(json['coupon_discount']) ?? 0,
      referralDiscount: _toDouble(json['referral_discount']) ?? 0,
      refundAmount: _toDouble(json['refund_amount']) ?? 0,
    );
  }
}
