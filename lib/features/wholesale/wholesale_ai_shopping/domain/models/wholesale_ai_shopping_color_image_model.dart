class WholesaleAiShoppingColorImageModel {
  final String? code;
  final String? url;

  const WholesaleAiShoppingColorImageModel({this.code, this.url});

  factory WholesaleAiShoppingColorImageModel.fromJson(Map<String, dynamic> json) {
    return WholesaleAiShoppingColorImageModel(
      code: json['code'],
      url: json['url'],
    );
  }
}
