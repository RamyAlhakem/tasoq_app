import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class AuctionCategoryList {
  final List<AuctionCategoryModel> categories;

  const AuctionCategoryList({this.categories = const []});

  factory AuctionCategoryList.fromJson(dynamic json) {
    final List raw;
    if (json is List) {
      raw = json;
    } else if (json is Map) {
      final dynamic content = json['content'];
      raw = content is List ? content
          : ApiListEnvelope.fromJson(Map<String, dynamic>.from(json), legacyKeys: const ['categories']).data ?? const [];
    } else {
      raw = const [];
    }

    return AuctionCategoryList(
      categories: raw.whereType<Map>()
          .map((e) => AuctionCategoryModel.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }
}

class AuctionCategoryModel {
  int? id;
  String? name;
  String? slug;
  String? icon;
  String? iconStorageType;
  int? parentId;
  int? position;
  String? createdAt;
  String? updatedAt;
  int? homeStatus;
  int? auctionHomeStatus;
  int? priority;
  int? auctionProductCount;
  ImageFullUrl? iconFullUrl;

  AuctionCategoryModel({
    this.id,
    this.name,
    this.slug,
    this.icon,
    this.iconStorageType,
    this.parentId,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.homeStatus,
    this.auctionHomeStatus,
    this.priority,
    this.auctionProductCount,
    this.iconFullUrl,
  });

  AuctionCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    icon = json['icon'];
    iconStorageType = json['icon_storage_type'];
    parentId = json['parent_id'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    homeStatus = int.tryParse(json['home_status'].toString());
    auctionHomeStatus = int.tryParse(json['auction_home_status'].toString());
    priority = int.tryParse(json['priority'].toString());
    auctionProductCount = int.tryParse(json['auction_product_count'].toString());
    iconFullUrl = json['icon_full_url'] != null
        ? ImageFullUrl.fromJson(json['icon_full_url'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['icon'] = icon;
    data['icon_storage_type'] = iconStorageType;
    data['parent_id'] = parentId;
    data['position'] = position;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['home_status'] = homeStatus;
    data['auction_home_status'] = auctionHomeStatus;
    data['priority'] = priority;
    data['auction_product_count'] = auctionProductCount;
    if (iconFullUrl != null) {
      data['icon_full_url'] = iconFullUrl!.toJson();
    }
    return data;
  }
}
