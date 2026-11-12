import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';

class WholesaleSellerListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<WholesaleSeller>? sellers;

  WholesaleSellerListModel({this.totalSize, this.limit, this.offset, this.sellers});

  WholesaleSellerListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      sellers = [
        for (final Map row in envelope.data!.whereType<Map>())
          WholesaleSeller.fromJson(Map<String, dynamic>.from(row)),
      ];
    }
  }
}

class WholesaleSeller {
  final int? id;
  final String? slug;
  final int? sellerId;
  final String? shopName;
  final ImageFullUrl? shopLogoUrl;
  final bool isVerified;
  final double? rating;
  final int? reviewCount;
  final double? avgMoq;
  final List<WholesaleProduct> products;
  final bool? isShopOnVacation;
  final bool? isShopTemporaryClosed;

  const WholesaleSeller({
    this.id,
    this.slug,
    this.sellerId,
    this.shopName,
    this.shopLogoUrl,
    this.isVerified = false,
    this.rating,
    this.reviewCount,
    this.avgMoq,
    this.products = const [],
    this.isShopOnVacation,
    this.isShopTemporaryClosed
  });

  bool get hasMoa => (avgMoq ?? 0) > 0;

  bool get isClosed => (isShopOnVacation ?? false) || (isShopTemporaryClosed ?? false);

  factory WholesaleSeller.fromJson(Map<String, dynamic> json) {
    return WholesaleSeller(
      id: _toInt(json['id']),
      slug: json['slug'],
      sellerId: _toInt(json['seller_id']),
      shopName: json['name'],
      shopLogoUrl: ImageFullUrl.parse(json['image_full_url']),
      isVerified: json['is_verified'] == true,
      rating: _toDouble(json['average_rating']),
      reviewCount: _toInt(json['review_count']),
      avgMoq: _toDouble(json['minimum_order_amount']),
      products: [
        if (json['products'] is List)
          for (final Map row in (json['products'] as List).whereType<Map>())
            WholesaleProduct.fromJson(Map<String, dynamic>.from(row)),
      ],
      isShopOnVacation: json['is_on_vacation'],
      isShopTemporaryClosed: json['is_temporarily_closed']
    );
  }

  static double? _toDouble(dynamic value) => value == null ? null : double.tryParse('$value');

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value') ?? double.tryParse('$value')?.toInt();
  }
}
