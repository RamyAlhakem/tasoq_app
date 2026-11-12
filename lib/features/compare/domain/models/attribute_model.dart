import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class AttributeResponseModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<AttributeModel>? attributes;

  AttributeResponseModel({this.totalSize, this.limit, this.offset, this.attributes});

  AttributeResponseModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      attributes = <AttributeModel>[];
      envelope.data!.forEach((v) {
        attributes!.add(AttributeModel.fromJson(v));
      });
    }
  }
}

class AttributeModel {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;


  AttributeModel(
      {this.id, this.name, this.createdAt, this.updatedAt});

  AttributeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}
