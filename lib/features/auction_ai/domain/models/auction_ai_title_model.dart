import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';

class AuctionTitleModel {
  bool? success;
  String? message;
  Data? data;

  AuctionTitleModel({this.success, this.message, this.data});

  AuctionTitleModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = ApiEnvelope.message(json);
    final dynamic payload = json['content'] ?? json['data'];
    data = payload is Map ? Data.fromJson(Map<String, dynamic>.from(payload)) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? data;
  int? remainingCount;

  Data({this.data, this.remainingCount});

  Data.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    remainingCount = json['remaining_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['data'] = this.data;
    data['remaining_count'] = remainingCount;
    return data;
  }
}
