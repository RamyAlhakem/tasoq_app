import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_action_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_product_model.dart';

class WholesaleAiShoppingSendMessageResponse {
  final bool status;
  final String reply;
  final String intent;
  final List<WholesaleAiShoppingProductModel> products;
  final List<WholesaleAiShoppingActionModel> actions;

  const WholesaleAiShoppingSendMessageResponse({
    required this.status,
    required this.reply,
    required this.intent,
    required this.products,
    required this.actions,
  });

  factory WholesaleAiShoppingSendMessageResponse.fromJson(Map<String, dynamic> json) {
    return WholesaleAiShoppingSendMessageResponse(
      status: json['status'] ?? false,
      reply: json['reply'] ?? '',
      intent: json['intent'] ?? '',
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => WholesaleAiShoppingProductModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => WholesaleAiShoppingActionModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
}
