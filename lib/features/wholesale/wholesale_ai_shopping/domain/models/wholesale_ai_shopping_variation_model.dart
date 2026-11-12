class WholesaleAiShoppingVariationModel {
  final String type;
  final double price;
  final String? sku;
  final int? qty;

  const WholesaleAiShoppingVariationModel({
    required this.type,
    required this.price,
    this.sku,
    this.qty,
  });

  factory WholesaleAiShoppingVariationModel.fromJson(Map<String, dynamic> json) {
    return WholesaleAiShoppingVariationModel(
      type: json['type'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      sku: json['sku'],
      qty: json['qty'],
    );
  }
}
