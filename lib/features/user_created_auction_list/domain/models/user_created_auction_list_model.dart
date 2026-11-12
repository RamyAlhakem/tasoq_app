import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class AuctionCounts {
  final int upcoming;
  final int live;
  final int readyToClaim;
  final int purchaseComplete;
  final int readyToDelivery;
  final int onTheWay;
  final int delivered;
  final int unsold;
  final int canceled;

  const AuctionCounts({
    this.upcoming = 0,
    this.live = 0,
    this.readyToClaim = 0,
    this.purchaseComplete = 0,
    this.readyToDelivery = 0,
    this.onTheWay = 0,
    this.delivered = 0,
    this.unsold = 0,
    this.canceled = 0,
  });

  int get total => upcoming + live + readyToClaim + purchaseComplete + readyToDelivery + onTheWay + delivered + unsold + canceled;

  factory AuctionCounts.fromJson(Map<String, dynamic> json) {
    int count(String key) => int.tryParse('${json[key]}') ?? 0;
    return AuctionCounts(
      upcoming: count('upcoming'),
      live: count('live'),
      readyToClaim: count('ready_to_claim'),
      purchaseComplete: count('purchase_complete'),
      readyToDelivery: count('ready_to_delivery'),
      onTheWay: count('on_the_way'),
      delivered: count('delivered'),
      unsold: count('unsold'),
      canceled: count('canceled'),
    );
  }
}

class UserCreatedAuctionListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<UserCreatedAuctionProduct>? products;
  AuctionCounts? counts;

  UserCreatedAuctionListModel({this.totalSize, this.limit, this.offset, this.products, this.counts});

  UserCreatedAuctionListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['products']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      products = <UserCreatedAuctionProduct>[
        for (final Map v in envelope.data!.whereType<Map>())
          UserCreatedAuctionProduct.fromJson(Map<String, dynamic>.from(v)),
      ];
    }
    final dynamic countsJson = envelope.read('counts');
    counts = countsJson is Map ? AuctionCounts.fromJson(Map<String, dynamic>.from(countsJson)) : null;
  }
}

class UserCreatedAuctionProduct {
  int? id;
  String? slug;
  String? name;
  String? productType;
  double? startingPrice;
  double? adminCommission;
  bool? isAdminCommissionPaid;
  bool? isRelaunched;
  ThumbnailFullUrl? thumbnailFullUrl;
  String? startTime;
  String? endTime;
  double? highestBidAmount;
  int? totalBids;
  int? totalParticipants;
  int? totalViews;
  String? auctionCurrentStatus;
  String? deliveryStatus;
  ClaimTransaction? claimTransaction;

  UserCreatedAuctionProduct({
    this.id,
    this.slug,
    this.name,
    this.productType,
    this.startingPrice,
    this.adminCommission,
    this.isAdminCommissionPaid,
    this.isRelaunched,
    this.thumbnailFullUrl,
    this.startTime,
    this.endTime,
    this.highestBidAmount,
    this.totalBids,
    this.totalParticipants,
    this.totalViews,
    this.auctionCurrentStatus,
    this.deliveryStatus,
    this.claimTransaction,
  });

  UserCreatedAuctionProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    productType = json['product_type'];
    startingPrice = json['starting_price'] != null ? double.tryParse(json['starting_price'].toString()) : null;
    adminCommission = json['admin_commission'] != null ? double.tryParse(json['admin_commission'].toString()) : null;
    isAdminCommissionPaid = _asBool(json['admin_commission_given']);
    isRelaunched = _asBool(json['is_relaunched']);
    thumbnailFullUrl = json['thumbnail_full_url'] != null ? ThumbnailFullUrl.fromJson(json['thumbnail_full_url']) : null;
    startTime = json['start_time']?.toString();
    endTime = json['end_time']?.toString();
    highestBidAmount = json['highest_bid_amount'] != null ? double.tryParse(json['highest_bid_amount'].toString()) : null;
    totalBids = int.tryParse('${json['total_bids']}');
    totalParticipants = int.tryParse('${json['total_participants']}');
    totalViews = int.tryParse('${json['total_views']}');
    auctionCurrentStatus = json['auction_current_status']?.toString();
    deliveryStatus = json['delivery_status']?.toString();
    claimTransaction = json['claim_transaction'] != null ? ClaimTransaction.fromJson(json['claim_transaction']) : null;
  }

  static bool? _asBool(dynamic value) => value == null ? null : (value == true || '$value' == '1');
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['path'] = path;
    data['status'] = status;
    return data;
  }
}

class ClaimTransaction {
  final int? id;
  final int? auctionProductId;
  final String? paymentMethod;
  final String? type;
  final String? paymentStatus;

  const ClaimTransaction({
    this.id,
    this.auctionProductId,
    this.paymentMethod,
    this.type,
    this.paymentStatus,
  });

  factory ClaimTransaction.fromJson(Map<String, dynamic> json) {
    return ClaimTransaction(
      id: json['id'] as int?,
      auctionProductId: json['auction_product_id'] as int?,
      paymentMethod: json['payment_method'] as String?,
      type: json['type'] as String?,
      paymentStatus: json['payment_status'] as String?,
    );
  }
}