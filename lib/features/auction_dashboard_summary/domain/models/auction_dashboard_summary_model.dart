import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';

class AuctionDashboardSummaryModel {
  int? totalMyBids;
  int? totalMySavedAuctions;
  int? totalMyAuctions;
  int? totalMyAuctionPending;

  AuctionDashboardSummaryModel({
    this.totalMyBids,
    this.totalMySavedAuctions,
    this.totalMyAuctions,
    this.totalMyAuctionPending,
  });

  factory AuctionDashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    final Map content = ApiEnvelope.content(json);
    return AuctionDashboardSummaryModel(
      totalMyBids: _count(content['total_my_bids']),
      totalMySavedAuctions: _count(content['total_my_saved_auctions']),
      totalMyAuctions: _count(content['total_my_auctions']),
      totalMyAuctionPending: _count(content['total_my_auction_pending']),
    );
  }

  static int? _count(dynamic value) => value is int ? value : int.tryParse('${value ?? ''}');

  Map<String, dynamic> toJson() {
    return {
      'total_my_bids': totalMyBids,
      'total_my_saved_auctions': totalMySavedAuctions,
      'total_my_auctions': totalMyAuctions,
      'total_my_auction_pending': totalMyAuctionPending,
    };
  }
}
