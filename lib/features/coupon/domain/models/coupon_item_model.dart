
import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/seller_model.dart';

class CouponItemModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Coupons>? coupons;

  CouponItemModel({this.totalSize, this.limit, this.offset, this.coupons});

  CouponItemModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['coupons']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      coupons = <Coupons>[];
      envelope.data!.forEach((v) {
        coupons!.add(Coupons.fromJson(v));
      });
    }
  }

}

class Coupons {
  int? id;
  String? addedBy;
  String? couponType;
  String? couponBearer;
  int? sellerId;
  String? title;
  String? code;
  int? limit;
  Seller? seller;
  String? startDate;
  String? expireDate;
  String? expireDatePlanText;
  String? planExpireDate;
  double? discount;
  String? discountType;
  double? minPurchase;
  double? maxDiscount;
  int? usedCount;
  int? orderCount;

  Coupons(
      {this.id,
        this.addedBy,
        this.couponType,
        this.couponBearer,
        this.sellerId,
        this.title,
        this.code,
        this.limit,
        this.seller,
        this.startDate,
        this.expireDate,
        this.planExpireDate,
        this.expireDatePlanText,
        this.discount,
        this.discountType,
        this.minPurchase,
        this.maxDiscount,
        this.usedCount,
        this.orderCount,
      });

  Coupons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addedBy = json['added_by'];
    couponType = json['coupon_type'];
    couponBearer = json['coupon_bearer'];
    title = json['title'];
    code = json['code'];
    sellerId = json['seller_id'];
    if(json['limit'] != null){
      limit = int.parse(json['limit'].toString());
    }

    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    startDate = json['start_date'];
    expireDate = json['expire_date'];
    // v6 dropped `plain_expire_date`, so fall back to the raw expiry date.
    planExpireDate = json['plain_expire_date'] ?? json['expire_date'];
    expireDatePlanText = planExpireDate;
    if(json['discount'] != null){
      discount = json['discount'].toDouble();
    }
    if(json['min_purchase'] != null){
      minPurchase = json['min_purchase'].toDouble();
    }
    if(json['max_discount'] != null){
      maxDiscount = json['max_discount'].toDouble();
    }
    usedCount = int.tryParse(json['used_count'].toString());

    discountType = json['discount_type'];
    if(json['order_count'] != null){
      try{
        orderCount = json['order_count'];
      }catch(e){
        orderCount = int.parse(json['order_count'].toString());
      }
    }else{
      orderCount = 0;
    }

  }

}
