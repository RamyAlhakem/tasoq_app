import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class SavedAuctionListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<SavedAuctionProduct>? savedProducts;

  SavedAuctionListModel({this.totalSize, this.limit, this.offset, this.savedProducts});

  SavedAuctionListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['saved_products']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      savedProducts = <SavedAuctionProduct>[
        for (final Map item in envelope.data!.whereType<Map>())
          SavedAuctionProduct.fromJson(Map<String, dynamic>.from(item)),
      ];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (savedProducts != null) {
      data['saved_products'] = savedProducts!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class SavedAuctionProduct {
  int? id;
  AuctionProductSummary? auctionProduct;

  SavedAuctionProduct({this.id, this.auctionProduct});

  SavedAuctionProduct.fromJson(Map<String, dynamic> json) {
    final dynamic product = json['auction_product'];
    if (product is Map) {
      id = json['id'];
      auctionProduct = AuctionProductSummary.fromJson(Map<String, dynamic>.from(product));
    } else {
      auctionProduct = AuctionProductSummary.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (auctionProduct != null) data['auction_product'] = auctionProduct!.toJson();
    return data;
  }
}

class AuctionProductSummary {
  int? auctionProductId;
  String? slug;
  String? name;
  String? productType;
  double? startingPrice;
  String? startTime;
  double? highestBid;
  String? endTime;
  int? totalViews;
  int? bidsCount;
  int? participantsCount;
  ThumbnailFullUrl? thumbnailFullUrl;

  AuctionProductSummary({
    this.auctionProductId,
    this.slug,
    this.name,
    this.productType,
    this.startingPrice,
    this.startTime,
    this.highestBid,
    this.endTime,
    this.totalViews,
    this.bidsCount,
    this.participantsCount,
    this.thumbnailFullUrl,
  });

  AuctionProductSummary.fromJson(Map<String, dynamic> json) {
    auctionProductId = json['id'];
    slug = json['slug'];
    name = json['name'];
    productType = json['product_type'];
    startingPrice = json['starting_price'] != null ? double.tryParse(json['starting_price'].toString()) : null;
    final highestBidMap = json['highest_bid'];
    highestBid = highestBidMap is Map && highestBidMap['bid_amount'] != null ? double.tryParse(highestBidMap['bid_amount'].toString()) : null;
    startTime = json['start_time'];
    endTime = json['end_time'];
    totalViews = json['total_views'];
    bidsCount = json['bids_count'];
    participantsCount = json['participants_count'];
    thumbnailFullUrl = json['thumbnail_full_url'] != null ? ThumbnailFullUrl.fromJson(json['thumbnail_full_url']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = auctionProductId;
    data['name'] = name;
    data['product_type'] = productType;
    data['starting_price'] = startingPrice;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['total_views'] = totalViews;
    data['bids_count'] = bidsCount;
    data['participants_count'] = participantsCount;
    if (thumbnailFullUrl != null) {
      data['thumbnail_full_url'] = thumbnailFullUrl!.toJson();
    }
    return data;
  }
}

class ThumbnailFullUrl {
  String? key;
  String? path;
  int? status;

  ThumbnailFullUrl({this.key, this.path, this.status});

  ThumbnailFullUrl.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    path = json['path'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['key'] = key;
    data['path'] = path;
    data['status'] = status;
    return data;
  }
}