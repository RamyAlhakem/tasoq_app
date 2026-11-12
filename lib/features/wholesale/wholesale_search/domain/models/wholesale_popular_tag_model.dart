import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class WholesalePopularTagModel {
  final List<WholesalePopularTag> popularTags;

  const WholesalePopularTagModel({required this.popularTags});

  factory WholesalePopularTagModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    return WholesalePopularTagModel(
      popularTags: [
        for (final Map row in (envelope.data ?? const []).whereType<Map>())
          WholesalePopularTag.fromJson(Map<String, dynamic>.from(row)),
      ].where((tag) => tag.tag.isNotEmpty).toList(),
    );
  }
}

class WholesalePopularTag {
  final int? id;
  final String tag;
  final int visitCount;

  const WholesalePopularTag({
    this.id,
    required this.tag,
    this.visitCount = 0,
  });

  factory WholesalePopularTag.fromJson(Map<String, dynamic> json) {
    return WholesalePopularTag(
      id: int.tryParse('${json['id']}'),
      tag: '${json['tag'] ?? ''}',
      visitCount: int.tryParse('${json['visit_count']}') ?? 0,
    );
  }
}
