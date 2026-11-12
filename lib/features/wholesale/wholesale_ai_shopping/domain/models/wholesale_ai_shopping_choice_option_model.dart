class WholesaleAiShoppingChoiceOptionModel {
  final String? name;
  final String? title;
  final List<String> options;

  const WholesaleAiShoppingChoiceOptionModel({
    this.name,
    this.title,
    required this.options,
  });

  factory WholesaleAiShoppingChoiceOptionModel.fromJson(Map<String, dynamic> json) {
    return WholesaleAiShoppingChoiceOptionModel(
      name: json['name'],
      title: json['title'],
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
