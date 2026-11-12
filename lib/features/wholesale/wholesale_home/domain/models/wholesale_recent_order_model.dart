import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class WholesaleRecentOrder {
  final int? id;
  final int? shopId;
  final String? shopSlug;
  final String? shopName;
  final ImageFullUrl? shopLogoUrl;
  final DateTime? orderDate;
  final double? orderTotal;
  final List<WholesaleOrderItemPreview> itemPreviews;

  const WholesaleRecentOrder({
    this.id,
    this.shopId,
    this.shopSlug,
    this.shopName,
    this.shopLogoUrl,
    this.orderDate,
    this.orderTotal,
    this.itemPreviews = const [],
  });

  factory WholesaleRecentOrder.fromJson(Map<String, dynamic> json) {
    final Map? seller = json['seller'] is Map ? json['seller'] : null;
    final Map? shop = seller?['shop'] is Map ? seller!['shop'] : null;
    final Map? wholesale = json['wholesale'] is Map ? json['wholesale'] : null;
    final List previews = wholesale?['item_previews'] is List ? wholesale!['item_previews'] : const [];

    return WholesaleRecentOrder(
      id: _toInt(json['id']),
      shopId: _toInt(shop?['id']),
      shopSlug: shop?['slug']?.toString(),
      shopName: shop?['name'],
      shopLogoUrl: ImageFullUrl.parse(shop?['image_full_url']),
      orderDate: DateTime.tryParse('${json['created_at']}'),
      orderTotal: _toDouble(wholesale?['total_amount']) ?? _toDouble(json['order_amount']),
      itemPreviews: [
        for (final Map preview in previews.whereType<Map>())
          WholesaleOrderItemPreview.fromJson(Map<String, dynamic>.from(preview)),
      ],
    );
  }

  static List<WholesaleRecentOrder> listFromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    return [
      for (final Map row in (envelope.data ?? const []).whereType<Map>())
        WholesaleRecentOrder.fromJson(Map<String, dynamic>.from(row)),
    ];
  }

  static double? _toDouble(dynamic value) => value == null ? null : double.tryParse('$value');

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value') ?? double.tryParse('$value')?.toInt();
  }
}

class WholesaleOrderItemPreview {
  final String? name;
  final ImageFullUrl? thumbnail;
  final String? variation;
  final int? quantity;
  final double? price;

  const WholesaleOrderItemPreview({this.name, this.thumbnail, this.variation, this.quantity, this.price});

  factory WholesaleOrderItemPreview.fromJson(Map<String, dynamic> json) {
    return WholesaleOrderItemPreview(
      name: json['name']?.toString(),
      thumbnail: ImageFullUrl.parse(json['thumbnail']),
      variation: json['variation']?.toString(),
      quantity: WholesaleRecentOrder._toInt(json['quantity']),
      price: WholesaleRecentOrder._toDouble(json['price']),
    );
  }
}
