class WholesaleAiShoppingPriceTierModel {
  final int minQty;
  final int? maxQty;
  final String? unitPriceFormatted;

  const WholesaleAiShoppingPriceTierModel({
    required this.minQty,
    this.maxQty,
    this.unitPriceFormatted,
  });

  factory WholesaleAiShoppingPriceTierModel.fromJson(Map<String, dynamic> json) {
    return WholesaleAiShoppingPriceTierModel(
      minQty: (json['min_qty'] as num?)?.toInt() ?? 1,
      maxQty: (json['max_qty'] as num?)?.toInt(),
      unitPriceFormatted: json['unit_price_formatted']?.toString(),
    );
  }

  String get rangeLabel => maxQty == null ? '$minQty+' : '$minQty-$maxQty';
}
