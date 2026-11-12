import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class AuctionPopularTagModel {
  final List<AuctionPopularTag> popularTags;

  const AuctionPopularTagModel({required this.popularTags});

  factory AuctionPopularTagModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['popular_tags']);
    return AuctionPopularTagModel(
      popularTags: [
        for (final Map row in (envelope.data ?? const []).whereType<Map>())
          AuctionPopularTag.fromJson(Map<String, dynamic>.from(row)),
      ].where((tag) => tag.tag.isNotEmpty).toList(),
    );
  }
}

class AuctionPopularTag {
  final int? id;
  final String tag;
  final String? createdAt;
  final String? updatedAt;

  const AuctionPopularTag({
    this.id,
    required this.tag,
    this.createdAt,
    this.updatedAt,
  });

  factory AuctionPopularTag.fromJson(Map<String, dynamic> json) {
    return AuctionPopularTag(
      id: int.tryParse('${json['id']}'),
      tag: '${json['tag'] ?? ''}',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
