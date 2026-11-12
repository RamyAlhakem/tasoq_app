class WholesaleAiShoppingColorModel {
  final String? name;
  final String? code;

  const WholesaleAiShoppingColorModel({this.name, this.code});

  factory WholesaleAiShoppingColorModel.fromJson(Map<String, dynamic> json) {
    return WholesaleAiShoppingColorModel(
      name: json['name'],
      code: json['code'],
    );
  }
}
