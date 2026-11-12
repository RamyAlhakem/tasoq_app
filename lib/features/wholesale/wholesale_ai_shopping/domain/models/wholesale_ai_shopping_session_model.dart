import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_history_message_model.dart';

class WholesaleAiShoppingSessionModel {
  final int id;
  final int? customerId;
  final String? guestId;
  final String? title;
  final String locale;
  final String lastActivityAt;
  final String createdAt;
  final String updatedAt;
  final int? messageCount;
  final List<WholesaleAiShoppingHistoryMessage> messages;

  const WholesaleAiShoppingSessionModel({
    required this.id,
    this.customerId,
    this.guestId,
    this.title,
    required this.locale,
    required this.lastActivityAt,
    required this.createdAt,
    required this.updatedAt,
    this.messageCount,
    this.messages = const [],
  });

  factory WholesaleAiShoppingSessionModel.fromJson(Map<String, dynamic> json) {
    return WholesaleAiShoppingSessionModel(
      id: json['id'] ?? 0,
      customerId: json['customer_id'],
      guestId: json['guest_id'],
      title: json['title'],
      locale: json['locale'] ?? 'en',
      lastActivityAt: json['last_activity_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      messageCount: json['messages_count'],
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => WholesaleAiShoppingHistoryMessage.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
}
