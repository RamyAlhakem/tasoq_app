import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class AuctionBidListModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? lastPage;
  List<AuctionBidItem>? bids;

  AuctionBidListModel({this.totalSize, this.limit, this.offset, this.lastPage, this.bids});

  AuctionBidListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: const ['bids']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    lastPage = envelope.lastPage;

    bids = (envelope.data ?? const []).whereType<Map>()
        .map((v) => AuctionBidItem.fromJson(Map<String, dynamic>.from(v))).toList();
  }

  bool get hasNextPage {
    final int page = offset ?? 1;
    if (lastPage != null) return page < lastPage!;
    if (totalSize != null && limit != null && limit! > 0) return page * limit! < totalSize!;
    return false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['last_page'] = lastPage;
    if (bids != null) {
      data['bids'] = bids!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AuctionBidItem {
  int? id;
  int? auctionProductId;
  double? bidAmount;
  bool? isAutoBid;
  bool? isWithdrawBid;
  bool? isRollbackBid;
  String? bidTime;
  String? claimStartTime;
  bool? isLeadBid;
  Bidder? bidder;
  UserContext? userContext;

  AuctionBidItem(
    {this.id,
      this.auctionProductId,
      this.bidAmount,
      this.isAutoBid,
      this.isWithdrawBid,
      this.isRollbackBid,
      this.bidTime,
      this.claimStartTime,
      this.isLeadBid,
      this.bidder,
      this.userContext});

  AuctionBidItem.fromJson(Map<String, dynamic> json) {
    id = _asInt(json['id']);
    auctionProductId = _asInt(json['auction_product_id']);
    bidAmount = _asDouble(json['bid_amount']);
    isAutoBid = _asBool(json['is_auto_bid']);
    isWithdrawBid = _asBool(json['is_withdraw_bid']);
    isRollbackBid = _asBool(json['is_rollback_bid']);
    bidTime = json['bid_time']?.toString();
    claimStartTime = json['claim_start_time']?.toString();
    isLeadBid = _asBool(json['is_lead_bid']);

    final dynamic rawBidder = json['bidder'] ?? json['customer'];
    bidder = rawBidder is Map ? Bidder.fromJson(Map<String, dynamic>.from(rawBidder)) : null;
    userContext = json['user_context'] is Map
        ? UserContext.fromJson(Map<String, dynamic>.from(json['user_context']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['auction_product_id'] = auctionProductId;
    data['bid_amount'] = bidAmount;
    data['is_auto_bid'] = isAutoBid;
    data['is_withdraw_bid'] = isWithdrawBid;
    data['is_rollback_bid'] = isRollbackBid;
    data['bid_time'] = bidTime;
    data['claim_start_time'] = claimStartTime;
    data['is_lead_bid'] = isLeadBid;
    if (bidder != null) {
      data['bidder'] = bidder!.toJson();
    }
    if (userContext != null) {
      data['user_context'] = userContext!.toJson();
    }
    return data;
  }
}

class Bidder {
  int? id;
  String? fName;
  String? lName;
  ImageFullUrl? imageFullUrl;

  Bidder({this.id, this.fName, this.lName, this.imageFullUrl});

  Bidder.fromJson(Map<String, dynamic> json) {
    id = _asInt(json['id']);
    fName = json['f_name']?.toString();
    lName = json['l_name']?.toString();
    imageFullUrl = json['image_full_url'] is Map
        ? ImageFullUrl.fromJson(Map<String, dynamic>.from(json['image_full_url']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    if (imageFullUrl != null) {
      data['image_full_url'] = imageFullUrl!.toJson();
    }
    return data;
  }
}

class ImageFullUrl {
  String? key;
  String? path;
  int? status;

  ImageFullUrl({this.key, this.path, this.status});

  ImageFullUrl.fromJson(Map<String, dynamic> json) {
    key = json['key']?.toString();
    path = json['path']?.toString();
    status = _asInt(json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['path'] = path;
    data['status'] = status;
    return data;
  }
}

class UserContext {
  int? myPosition;
  bool? isLeading;
  bool? isWinner;
  String? claimEndTime;
  double? claimTimeRemaining;
  bool? isClaimExpired;

  UserContext(
    {this.myPosition,
      this.isLeading,
      this.isWinner,
      this.claimEndTime,
      this.claimTimeRemaining,
      this.isClaimExpired});

  UserContext.fromJson(Map<String, dynamic> json) {
    myPosition = _asInt(json['my_position']);
    isLeading = _asBool(json['is_leading']);
    isWinner = _asBool(json['is_winner']);
    claimEndTime = json['claim_end_time']?.toString();
    claimTimeRemaining = _asDouble(json['claim_time_remaining']);
    isClaimExpired = _asBool(json['is_claim_expired']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['my_position'] = myPosition;
    data['is_leading'] = isLeading;
    data['is_winner'] = isWinner;
    data['claim_end_time'] = claimEndTime;
    data['claim_time_remaining'] = claimTimeRemaining;
    data['is_claim_expired'] = isClaimExpired;
    return data;
  }
}

bool? _asBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final String text = value.toString().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return null;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse('$value');
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse('$value');
}
