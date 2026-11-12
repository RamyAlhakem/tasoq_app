import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';

class WholesaleRestockRequestItem {
  final int? id;
  final int? productId;
  final String? variant;
  final int restockProductCustomersCount;
  final String? fcmTopic;
  final String? createdAt;
  final WholesaleProduct? product;

  const WholesaleRestockRequestItem({
    this.id,
    this.productId,
    this.variant,
    this.restockProductCustomersCount = 0,
    this.fcmTopic,
    this.createdAt,
    this.product,
  });

  factory WholesaleRestockRequestItem.fromJson(Map<String, dynamic> json) {
    final dynamic product = json['product'];

    return WholesaleRestockRequestItem(
      id: _toInt(json['id']),
      productId: _toInt(json['product_id']),
      variant: json['variant']?.toString(),
      restockProductCustomersCount: _toInt(json['restock_product_customers_count']) ?? 0,
      fcmTopic: json['fcm_topic']?.toString(),
      createdAt: json['created_at']?.toString(),
      product: product is Map ? WholesaleProduct.fromJson(Map<String, dynamic>.from(product)) : null,
    );
  }
}

class WholesaleRestockRequestListModel {
  final List<WholesaleRestockRequestItem> data;
  final int? totalSize;
  final int? offset;

  const WholesaleRestockRequestListModel({this.data = const [], this.totalSize, this.offset});

  factory WholesaleRestockRequestListModel.fromJson(Map<String, dynamic> json) {
    final dynamic outer = json['data'];
    final Map outerMap = outer is Map ? outer : const {};
    final List rows = outerMap['data'] is List ? outerMap['data'] as List : const [];
    final Map? pagination = outerMap['pagination'] is Map ? outerMap['pagination'] as Map : null;

    return WholesaleRestockRequestListModel(
      data: [for (final row in rows.whereType<Map>()) WholesaleRestockRequestItem.fromJson(Map<String, dynamic>.from(row))],
      totalSize: _toInt(pagination?['total']) ?? rows.length,
      offset: _toInt(pagination?['current_page']) ?? 1,
    );
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse('$value');
}
