import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class WholesaleBannerResponseModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? lastPage;
  String? bannerType;
  List<WholesaleBanner>? banners;

  WholesaleBannerResponseModel({this.totalSize, this.limit, this.offset, this.lastPage, this.bannerType, this.banners});

  WholesaleBannerResponseModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    lastPage = envelope.lastPage;
    final dynamic params = envelope.read('params');
    bannerType = envelope.read('banner_type') ?? (params is Map ? params['banner_type']?.toString() : null);
    if (envelope.data != null) {
      banners = <WholesaleBanner>[];
      for (final dynamic banner in envelope.data!) {
        if (banner is Map) {
          banners!.add(WholesaleBanner.fromJson(Map<String, dynamic>.from(banner)));
        }
      }
    }
  }

  bool get hasNextPage {
    final int page = offset ?? 1;
    if (lastPage != null) return page < lastPage!;
    if (totalSize != null && limit != null && limit! > 0) return page * limit! < totalSize!;
    return false;
  }
}

class WholesaleBanner {
  final int? id;
  final String? bannerType;
  final String? title;
  final String? subTitle;
  final String? buttonText;
  final String? backgroundColor;
  final String? photo;
  final ImageFullUrl? imageUrl;
  final String? url;
  final String? resourceType;
  final int? resourceId;
  final WholesaleBannerResource? resource;

  const WholesaleBanner({
    this.id,
    this.bannerType,
    this.title,
    this.subTitle,
    this.buttonText,
    this.backgroundColor,
    this.photo,
    this.imageUrl,
    this.url,
    this.resourceType,
    this.resourceId,
    this.resource,
  });

  WholesaleBanner.fromJson(Map<String, dynamic> json)
      : id = _asInt(json['id']),
        bannerType = json['banner_type']?.toString(),
        title = json['title']?.toString(),
        subTitle = json['sub_title']?.toString(),
        buttonText = json['button_text']?.toString(),
        backgroundColor = json['background_color']?.toString(),
        photo = json['photo']?.toString(),
        url = json['url']?.toString(),
        resourceType = json['resource_type']?.toString(),
        resourceId = _asInt(json['resource_id']),
        imageUrl = ImageFullUrl.parse(json['photo_full_url']),
        resource = json['resource'] is Map
            ? WholesaleBannerResource.fromJson(Map<String, dynamic>.from(json['resource'])) : null;

  String get image => imageUrl?.path ?? '';

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value');
  }
}


class WholesaleBannerResource {
  final int? id;
  final String? name;

  final String? slug;

  const WholesaleBannerResource({this.id, this.name, this.slug});

  WholesaleBannerResource.fromJson(Map<String, dynamic> json)
      : id = WholesaleBanner._asInt(json['id']),
        name = json['name']?.toString(),
        slug = json['slug']?.toString();
}
