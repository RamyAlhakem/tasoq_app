import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class WholesaleAttributeResponseModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<WholesaleAttribute>? attributes;

  WholesaleAttributeResponseModel({this.totalSize, this.limit, this.offset, this.attributes});

  WholesaleAttributeResponseModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      attributes = <WholesaleAttribute>[];
      envelope.data!.forEach((v) {
        attributes!.add(WholesaleAttribute.fromJson(v));
      });
    }
  }
}

class WholesaleAttribute {
  final int? id;
  final String? name;

  const WholesaleAttribute({this.id, this.name});

  WholesaleAttribute.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
