import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';


class CompareModel {
  List<CompareLists>? compareLists;

  CompareModel({this.compareLists});

  CompareModel.fromJson(dynamic json) {
    // v6 returns the rows at content.data; the list is never paginated here.
    final dynamic rows = ApiEnvelope.content(json)['data'];
    compareLists = rows is List
        ? rows.map((v) => CompareLists.fromJson(v)).toList()
        : <CompareLists>[];
  }
}

class CompareLists {
  int? id;
  int? userId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  Product? product;

  CompareLists(
      {this.id,
        this.userId,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.product});

  CompareLists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }


}

