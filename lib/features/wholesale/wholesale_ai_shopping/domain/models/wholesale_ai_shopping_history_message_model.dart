import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_product_model.dart';

class WholesaleAiShoppingHistoryMessage {
  final int id;
  final String role;
  final String? content;
  final String? imageUrl;
  final List<WholesaleAiShoppingProductModel> products;
  final String createdAt;

  const WholesaleAiShoppingHistoryMessage({
    required this.id,
    required this.role,
    this.content,
    this.imageUrl,
    this.products = const [],
    required this.createdAt,
  });

  factory WholesaleAiShoppingHistoryMessage.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    return WholesaleAiShoppingHistoryMessage(
      id: json['id'] ?? 0,
      role: json['role'] ?? 'user',
      content: json['content'],
      imageUrl: meta['image_url'] as String?,
      products: (meta['products'] as List<dynamic>?)
              ?.map((e) => WholesaleAiShoppingProductModel.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      createdAt: json['created_at'] ?? '',
    );
  }
}
