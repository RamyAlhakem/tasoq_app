import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class WholesaleBrandResponseModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<WholesaleBrand>? brands;

  WholesaleBrandResponseModel({this.totalSize, this.limit, this.offset, this.brands});

  WholesaleBrandResponseModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      brands = <WholesaleBrand>[];
      envelope.data!.forEach((v) {
        brands!.add(WholesaleBrand.fromJson(v));
      });
    }
  }
}

class WholesaleBrand {
  final int? id;
  final String? name;
  final String? image;
  final ImageFullUrl? imageFullUrl;

  const WholesaleBrand({this.id, this.name, this.image, this.imageFullUrl});

  WholesaleBrand.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        imageFullUrl = ImageFullUrl.parse(json['image_full_url']);
}
