import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';

class AuctionSocialShareModel {
  final String link;

  AuctionSocialShareModel({
    required this.link,
  });

  factory AuctionSocialShareModel.fromJson(Map<String, dynamic> json) {
    final Map content = ApiEnvelope.content(json);
    return AuctionSocialShareModel(
      link: content['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
    };
  }
}