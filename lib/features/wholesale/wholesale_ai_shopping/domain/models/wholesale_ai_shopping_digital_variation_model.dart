class WholesaleAiShoppingDigitalVariationModel {
  final String variantKey;
  final String label;
  final double price;
  final String? sku;

  const WholesaleAiShoppingDigitalVariationModel({
    required this.variantKey,
    required this.label,
    required this.price,
    this.sku,
  });

  factory WholesaleAiShoppingDigitalVariationModel.fromJson(Map<String, dynamic> json) {
    return WholesaleAiShoppingDigitalVariationModel(
      variantKey: json['variant_key'] ?? '',
      label: json['label'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      sku: json['sku'],
    );
  }
}
