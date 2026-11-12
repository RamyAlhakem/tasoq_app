enum WholesaleQuoteReason {
  variationUnavailable,
  outOfStock,
  belowMinimumOrder,
  aboveMaximumQuantity,
  exceedsStock,
}

WholesaleQuoteReason? wholesaleQuoteReasonFrom(String? key) {
  switch (key) {
    case 'variation_unavailable':
      return WholesaleQuoteReason.variationUnavailable;
    case 'out_of_stock':
      return WholesaleQuoteReason.outOfStock;
    case 'below_minimum_order':
      return WholesaleQuoteReason.belowMinimumOrder;
    case 'above_maximum_quantity':
      return WholesaleQuoteReason.aboveMaximumQuantity;
    case 'exceeds_stock':
      return WholesaleQuoteReason.exceedsStock;
    default:
      return null;
  }
}

class WholesalePriceQuote {
  final String? variantKey;

  final String? pricingMode;
  final int? tierIndex;

  final double unitPrice;
  final double discountPerUnit;
  final double discountedUnitPrice;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double total;

  final String? taxModel;

  final int? minimumQuantity;

  final int? maximumQuantity;

  final int? availableStock;

  final WholesaleQuoteReason? reason;
  final String? reasonKey;

  final bool isPurchasable;

  final String? message;
  final bool inCart;
  final int inCartQuantity;

  const WholesalePriceQuote({
    this.variantKey,
    this.pricingMode,
    this.tierIndex,
    this.unitPrice = 0,
    this.discountPerUnit = 0,
    this.discountedUnitPrice = 0,
    this.subtotal = 0,
    this.discountAmount = 0,
    this.taxAmount = 0,
    this.total = 0,
    this.taxModel,
    this.minimumQuantity,
    this.maximumQuantity,
    this.availableStock,
    this.reason,
    this.reasonKey,
    this.isPurchasable = false,
    this.message,
    this.inCart = false,
    this.inCartQuantity = 0,
  });

  bool isPurchasableIn({required bool isShopClosed}) => reason == null && isPurchasable && !isShopClosed;

  factory WholesalePriceQuote.fromJson(Map<String, dynamic> json) {
    final String? reasonKey = json['reason'] as String?;

    return WholesalePriceQuote(
      variantKey: json['variant_key'] as String?,
      pricingMode: json['pricing_mode'] as String?,
      tierIndex: _toInt(json['tier_index']),
      unitPrice: _toDouble(json['unit_price']) ?? 0,
      discountPerUnit: _toDouble(json['discount_per_unit']) ?? 0,
      discountedUnitPrice: _toDouble(json['discounted_unit_price']) ?? 0,
      subtotal: _toDouble(json['subtotal']) ?? 0,
      discountAmount: _toDouble(json['discount_amount']) ?? 0,
      taxAmount: _toDouble(json['tax_amount']) ?? 0,
      total: _toDouble(json['total']) ?? 0,
      taxModel: json['tax_model'] as String?,
      minimumQuantity: _toInt(json['minimum_quantity']),
      maximumQuantity: _toInt(json['maximum_quantity']),
      availableStock: _toInt(json['available_stock']),
      reason: wholesaleQuoteReasonFrom(reasonKey),
      reasonKey: reasonKey,
      isPurchasable: json['is_purchasable'] == true,
      message: json['message'] as String?,
      inCart: json['in_cart'] == true,
      inCartQuantity: _toInt(json['in_cart_quantity']) ?? 0,
    );
  }

  static double? _toDouble(dynamic value) => value == null ? null : double.tryParse('$value');

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value') ?? double.tryParse('$value')?.toInt();
  }
}
