import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class WholesaleShopDetails {
  final int? id;
  final int? sellerId;
  final String? name;
  final String? slug;
  final String? address;
  final String? contact;
  final ImageFullUrl? imageFullUrl;
  final ImageFullUrl? bannerFullUrl;
  final bool isVerified;
  final double? averageRating;
  final int? reviewCount;
  final int? totalProduct;
  final bool isTemporarilyClosed;
  final bool isOnVacation;

  const WholesaleShopDetails({
    this.id,
    this.sellerId,
    this.name,
    this.slug,
    this.address,
    this.contact,
    this.imageFullUrl,
    this.bannerFullUrl,
    this.isVerified = false,
    this.averageRating,
    this.reviewCount,
    this.totalProduct,
    this.isTemporarilyClosed = false,
    this.isOnVacation = false,
  });

  bool get isClosed => isTemporarilyClosed || isOnVacation;

  factory WholesaleShopDetails.fromJson(Map<String, dynamic> json) {
    return WholesaleShopDetails(
      id: _toInt(json['id']),
      sellerId: _toInt(json['seller_id']),
      name: json['name'],
      slug: json['slug'],
      address: json['address'],
      contact: json['contact'],
      imageFullUrl: ImageFullUrl.parse(json['image_full_url']),
      bannerFullUrl: ImageFullUrl.parse(json['banner_full_url']),
      isVerified: json['is_verified'] == true,
      averageRating: _toDouble(json['average_rating']),
      reviewCount: _toInt(json['review_count']),
      totalProduct: _toInt(json['total_product']),
      isTemporarilyClosed: json['is_temporarily_closed'] == true,
      isOnVacation: json['is_on_vacation'] == true,
    );
  }

  static WholesaleShopDetails? parse(dynamic json) {
    final dynamic data = ApiEnvelope.content(json)['data'];
    if (data is! Map) return null;
    return WholesaleShopDetails.fromJson(Map<String, dynamic>.from(data));
  }

  static double? _toDouble(dynamic value) => value == null ? null : double.tryParse('$value');

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value') ?? double.tryParse('$value')?.toInt();
  }
}
