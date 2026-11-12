import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_preselect_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_shop_minimum_model.dart';

enum WholesaleAiShoppingActionType {
  selectVariation,
  needsConfirmation,
  added,
  updated,
  minimumNotMet,
  checkout,
  unknown,
}

class WholesaleAiShoppingActionModel {
  final WholesaleAiShoppingActionType type;
  final int? productId;
  final bool? buyNow;
  final WholesaleAiShoppingPreselectModel? preselect;
  final List<WholesaleAiShoppingShopMinimumModel>? shops;
  final String? url;
  final String? name;
  final int? quantity;

  const WholesaleAiShoppingActionModel({
    required this.type,
    this.productId,
    this.buyNow,
    this.preselect,
    this.shops,
    this.url,
    this.name,
    this.quantity,
  });

  factory WholesaleAiShoppingActionModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] ?? '';
    final WholesaleAiShoppingActionType type = _parseType(typeStr);

    WholesaleAiShoppingPreselectModel? preselect;
    if (json['preselect'] is Map) {
      preselect = WholesaleAiShoppingPreselectModel.fromJson(
          Map<String, dynamic>.from(json['preselect']));
    }

    List<WholesaleAiShoppingShopMinimumModel>? shops;
    if (json['shops'] is List) {
      shops = (json['shops'] as List<dynamic>)
          .map((e) => WholesaleAiShoppingShopMinimumModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return WholesaleAiShoppingActionModel(
      type: type,
      productId: json['product_id'],
      buyNow: json['buy_now'],
      preselect: preselect,
      shops: shops,
      url: json['url'],
      name: json['name'],
      quantity: json['quantity'],
    );
  }

  static WholesaleAiShoppingActionType _parseType(String raw) {
    switch (raw) {
      case 'select_variation':
        return WholesaleAiShoppingActionType.selectVariation;
      case 'needs_confirmation':
        return WholesaleAiShoppingActionType.needsConfirmation;
      case 'added':
        return WholesaleAiShoppingActionType.added;
      case 'updated':
        return WholesaleAiShoppingActionType.updated;
      case 'minimum_not_met':
        return WholesaleAiShoppingActionType.minimumNotMet;
      case 'checkout':
        return WholesaleAiShoppingActionType.checkout;
      default:
        return WholesaleAiShoppingActionType.unknown;
    }
  }
}
