import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';

class AuctionSetupAutoFillModel {
  bool? success;
  String? message;
  Data? data;

  AuctionSetupAutoFillModel({this.success, this.message, this.data});

  AuctionSetupAutoFillModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = ApiEnvelope.message(json);
    final dynamic payload = json['content'] ?? json['data'];
    data = payload is Map ? Data.fromJson(Map<String, dynamic>.from(payload)) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class Data {
  String? name;
  String? description;
  int? remainingCount;

  Data({this.name, this.description, this.remainingCount});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    remainingCount = json['remaining_count'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'remaining_count': remainingCount,
    };
  }
}
