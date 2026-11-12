import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class WholesaleCouponResponseModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<WholesaleCoupon>? coupons;

  WholesaleCouponResponseModel({this.totalSize, this.limit, this.offset, this.coupons});

  WholesaleCouponResponseModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      coupons = <WholesaleCoupon>[];
      envelope.data!.forEach((v) {
        coupons!.add(WholesaleCoupon.fromJson(v));
      });
    }
  }
}

class WholesaleCoupon {
  final int? id;
  final String? title;
  final String? code;
  final String? couponType;
  final String? couponBearer;
  final int? sellerId;
  final WholesaleCouponSeller? seller;
  final double? discount;
  final String? discountType;
  final double? minPurchase;
  final double? maxDiscount;
  final String? startDate;
  final String? expireDate;

  final int? limit;

  final int? usedCount;

  const WholesaleCoupon({
    this.id,
    this.title,
    this.code,
    this.couponType,
    this.couponBearer,
    this.sellerId,
    this.seller,
    this.discount,
    this.discountType,
    this.minPurchase,
    this.maxDiscount,
    this.startDate,
    this.expireDate,
    this.limit,
    this.usedCount,
  });

  WholesaleCoupon.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        code = json['code'],
        couponType = json['coupon_type'],
        couponBearer = json['coupon_bearer'],
        sellerId = json['seller_id'],
        seller = json['seller'] != null ? WholesaleCouponSeller.fromJson(json['seller']) : null,
        discount = _toDouble(json['discount']),
        discountType = json['discount_type'],
        minPurchase = _toDouble(json['min_purchase']),
        maxDiscount = _toDouble(json['max_discount']),
        startDate = json['start_date'],
        expireDate = json['expire_date'],
        limit = _toInt(json['limit']),
        usedCount = _toInt(json['used_count']) ?? 0;

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class WholesaleCouponSeller {
  final int? id;
  final String? name;
  final WholesaleCouponShop? shop;

  const WholesaleCouponSeller({this.id, this.name, this.shop});

  WholesaleCouponSeller.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        shop = json['shop'] != null ? WholesaleCouponShop.fromJson(json['shop']) : null;
}

class WholesaleCouponShop {
  final int? id;
  final String? name;

  const WholesaleCouponShop({this.id, this.name});

  WholesaleCouponShop.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
