import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';

class FindWhatYouNeedModel {
  List<FindWhatYouNeed>? findWhatYouNeed;

  FindWhatYouNeedModel({this.findWhatYouNeed});

  FindWhatYouNeedModel.fromJson(Map<String, dynamic> json) {
    final dynamic data = ApiEnvelope.content(json)['data'];
    if (data is List) {
      findWhatYouNeed = <FindWhatYouNeed>[];
      data.forEach((v) {
        findWhatYouNeed!.add(FindWhatYouNeed.fromJson(v));
      });
    }
  }

}

class FindWhatYouNeed {
  int? id;
  String? name;
  String? slug;
  String? icon;
  String? iconFullUrl;
  int? parentId;
  int? position;
  String? createdAt;
  String? updatedAt;
  int? homeStatus;
  int? priority;
  int? productCount;
  List<Childes>? childes;

  FindWhatYouNeed(
      {this.id,
        this.name,
        this.slug,
        this.icon,
        this.parentId,
        this.position,
        this.createdAt,
        this.updatedAt,
        this.homeStatus,
        this.priority,
        this.productCount,
        this.childes,
        this.iconFullUrl
      });

  FindWhatYouNeed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    icon = json['icon'];
    parentId = json['parent_id'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    homeStatus = json['home_status'];
    priority = json['priority'];
    productCount = int.tryParse(json['product_count'].toString()) ?? 0;
    iconFullUrl = json['icon_full_url'];
    if (json['childes'] != null) {
      childes = <Childes>[];
      json['childes'].forEach((v) {
        childes!.add(Childes.fromJson(v));
      });
    }

  }

}

class Childes {
  int? id;
  String? name;
  String? slug;
  String? icon;
  String? iconFullUrl;
  int? parentId;
  int? position;
  String? createdAt;
  String? updatedAt;
  int? homeStatus;
  int? priority;
  int? subCategoryProductCount;


  Childes(
      {this.id,
        this.name,
        this.slug,
        this.icon,
        this.parentId,
        this.position,
        this.createdAt,
        this.updatedAt,
        this.homeStatus,
        this.priority,
        this.subCategoryProductCount,
        this.iconFullUrl});

  Childes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    icon = json['icon'];
    parentId = json['parent_id'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    homeStatus = json['home_status'];
    priority = json['priority'];
    subCategoryProductCount = int.tryParse(json['sub_category_product_count'].toString()) ?? 0;
    iconFullUrl = json['icon_full_url'];
  }
}
