import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';

class AuctionTitleSuggestionsModel {
  bool? success;
  String? message;
  Data? data;

  AuctionTitleSuggestionsModel({this.success, this.message, this.data});

  AuctionTitleSuggestionsModel.fromJson(Map<String, dynamic> json) {
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
  TitleData? data;
  int? remainingCount;

  Data({this.data, this.remainingCount});

  Data.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? TitleData.fromJson(json['data']) : null;
    remainingCount = json['remaining_count'];
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'remaining_count': remainingCount,
    };
  }
}

class TitleData {
  List<String>? titles;

  TitleData({this.titles});

  TitleData.fromJson(Map<String, dynamic> json) {
    titles = json['titles'] != null ? List<String>.from(json['titles']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'titles': titles,
    };
  }
}
