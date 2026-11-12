class WholesaleAiShoppingShopMinimumModel {
  final String shop;
  final String current;
  final String required;
  final String shortfall;

  const WholesaleAiShoppingShopMinimumModel({
    required this.shop,
    required this.current,
    required this.required,
    required this.shortfall,
  });

  factory WholesaleAiShoppingShopMinimumModel.fromJson(Map<String, dynamic> json) {
    return WholesaleAiShoppingShopMinimumModel(
      shop: json['shop'] ?? '',
      current: json['current'] ?? '',
      required: json['required'] ?? '',
      shortfall: json['shortfall'] ?? '',
    );
  }
}
