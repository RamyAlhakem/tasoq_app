import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

List<String> _toStringList(dynamic value) {
  if (value is! List) return [];
  return value.map((v) => v?.toString() ?? '').where((v) => v.isNotEmpty).toList();
}

class WholesaleProductReviewModel {
  final int id;
  final int? productId;
  final int? orderId;
  final String comment;
  final int rating;
  final String? createdAt;

  final List<String> attachment;

  final List<String> attachmentFullUrl;
  final WholesaleProductReviewReplyModel? reply;

  const WholesaleProductReviewModel({
    required this.id,
    this.productId,
    this.orderId,
    required this.comment,
    required this.rating,
    this.createdAt,
    this.attachment = const [],
    this.attachmentFullUrl = const [],
    this.reply,
  });

  factory WholesaleProductReviewModel.fromJson(Map<String, dynamic> json) {
    final List<String> fullUrls = (json['attachment_full_url'] is List ? json['attachment_full_url'] as List : [])
        .map((v) => ImageFullUrl.parse(v)?.path ?? '')
        .where((v) => v.isNotEmpty)
        .toList();

    return WholesaleProductReviewModel(
      id: _toInt(json['id']) ?? 0,
      productId: _toInt(json['product_id']),
      orderId: _toInt(json['order_id']),
      comment: json['comment']?.toString() ?? '',
      rating: _toInt(json['rating']) ?? 0,
      createdAt: json['created_at']?.toString(),
      attachment: _toStringList(json['attachment']),
      attachmentFullUrl: fullUrls,
      reply: json['reply'] is Map ? WholesaleProductReviewReplyModel.fromJson(Map<String, dynamic>.from(json['reply'])) : null,
    );
  }
}

class WholesaleProductReviewReplyModel {
  final String replyText;
  final String? createdAt;

  const WholesaleProductReviewReplyModel({required this.replyText, this.createdAt});

  factory WholesaleProductReviewReplyModel.fromJson(Map<String, dynamic> json) {
    return WholesaleProductReviewReplyModel(
      replyText: json['reply_text']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }
}
