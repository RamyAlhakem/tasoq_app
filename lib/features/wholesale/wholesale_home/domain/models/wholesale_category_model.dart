import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class WholesaleCategory {
  final int? id;
  final String? name;
  final ImageFullUrl? imageUrl;

  const WholesaleCategory({this.id, this.name, this.imageUrl});

  factory WholesaleCategory.fromJson(Map<String, dynamic> json) {
    return WholesaleCategory(
      id: json['id'],
      name: json['name'],
      imageUrl: ImageFullUrl.parse(json['icon_full_url']),
    );
  }
}

class WholesaleCategoryTab {
  final int? id;
  final String name;
  final ImageFullUrl? imageUrl;
  final List<WholesaleCategory> categories;

  const WholesaleCategoryTab({
    this.id,
    required this.name,
    this.imageUrl,
    this.categories = const [],
  });

  factory WholesaleCategoryTab.fromJson(Map<String, dynamic> json) {
    return WholesaleCategoryTab(
      id: json['id'],
      name: json['name'] ?? '',
      imageUrl: ImageFullUrl.parse(json['icon_full_url']),
      categories: [
        if (json['sub_categories'] is List)
          for (final Map row in (json['sub_categories'] as List).whereType<Map>())
            WholesaleCategory.fromJson(Map<String, dynamic>.from(row)),
      ],
    );
  }

  WholesaleCategory toCategory() => WholesaleCategory(id: id, name: name, imageUrl: imageUrl);

  static List<WholesaleCategoryTab> listFromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    return [
      for (final Map row in (envelope.data ?? const []).whereType<Map>())
        WholesaleCategoryTab.fromJson(Map<String, dynamic>.from(row)),
    ];
  }
}
