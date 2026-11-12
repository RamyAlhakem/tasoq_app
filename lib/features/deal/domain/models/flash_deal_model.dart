import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class FlashDealResponseModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<FlashDealModel>? flashDeals;

  FlashDealResponseModel({this.totalSize, this.limit, this.offset, this.flashDeals});

  FlashDealResponseModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      flashDeals = <FlashDealModel>[];
      envelope.data!.forEach((v) {
        flashDeals!.add(FlashDealModel.fromJson(v));
      });
    }
  }
}

class FlashDealModel {
  int? _id;
  String? _title;
  String? _startDate;
  String? _endDate;
  String? _startAt;
  String? _endAt;
  String? _backgroundColor;
  String? _textColor;
  String? _banner;
  String? _slug;
  String? _createdAt;
  String? _updatedAt;
  int? _productId;
  String? _dealType;
  ImageFullUrl? _bannerFullUrl;
  int? _productsCount;

  FlashDealModel(
      {int? id,
        String? title,
        String? startDate,
        String? endDate,
        String? startAt,
        String? endAt,
        String? backgroundColor,
        String? textColor,
        String? banner,
        String? slug,
        String? createdAt,
        String? updatedAt,
        int? productId,
        String? dealType,
        ImageFullUrl? bannerFullUrl,
        int? productsCount}) {
    _id = id;
    _title = title;
    _startDate = startDate;
    _endDate = endDate;
    _startAt = startAt;
    _endAt = endAt;
    _backgroundColor = backgroundColor;
    _textColor = textColor;
    _banner = banner;
    _slug = slug;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _productId = productId;
    _dealType = dealType;
    _bannerFullUrl = bannerFullUrl;
    _productsCount = productsCount;
  }

  int? get id => _id;
  String? get title => _title;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get startAt => _startAt;
  String? get endAt => _endAt;
  String? get backgroundColor => _backgroundColor;
  String? get textColor => _textColor;
  String? get banner => _banner;
  String? get slug => _slug;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get productId => _productId;
  String? get dealType => _dealType;
  ImageFullUrl? get bannerFullUrl => _bannerFullUrl;
  int? get productsCount => _productsCount;

  FlashDealModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _startAt = json['start_at'];
    _endAt = json['end_at'];
    _backgroundColor = json['background_color'];
    _textColor = json['text_color'];
    _banner = json['banner'];
    _slug = json['slug'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _productId = json['product_id'];
    _dealType = json['deal_type'];
    _bannerFullUrl = json['banner_full_url'] != null
        ? ImageFullUrl.fromJson(json['banner_full_url']) : null;
    _productsCount = json['products_count'];
  }

}
