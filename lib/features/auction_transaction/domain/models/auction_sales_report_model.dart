import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class AuctionSalesReportModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? lastPage;
  AuctionSalesSummaryModel? summary;
  List<AuctionSalesReportItemModel>? auctions;

  AuctionSalesReportModel({this.totalSize, this.limit, this.offset, this.lastPage, this.summary, this.auctions});

  AuctionSalesReportModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    lastPage = envelope.lastPage;

    final dynamic rawSummary = envelope.read('summary');
    summary = rawSummary is Map ? AuctionSalesSummaryModel.fromJson(Map<String, dynamic>.from(rawSummary)) : null;

    auctions = (envelope.data ?? const []).whereType<Map>()
        .map((v) => AuctionSalesReportItemModel.fromJson(Map<String, dynamic>.from(v))).toList();
  }


  bool get hasNextPage {
    final int page = offset ?? 1;
    if (lastPage != null) return page < lastPage!;
    if (totalSize != null && limit != null && limit! > 0) return page * limit! < totalSize!;
    return false;
  }
}

class AuctionSalesSummaryModel {
  int totalAuctionsCreated;
  int totalAuctionsSold;
  double totalProductSalesValue;
  double totalVatTax;
  double totalShippingFee;
  double grossSalesAmount;
  SalesTrendModel salesTrend;

  AuctionSalesSummaryModel({
    required this.totalAuctionsCreated,
    required this.totalAuctionsSold,
    required this.totalProductSalesValue,
    required this.totalVatTax,
    required this.totalShippingFee,
    required this.grossSalesAmount,
    required this.salesTrend,
  });

  factory AuctionSalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return AuctionSalesSummaryModel(
      totalAuctionsCreated: int.tryParse('${json['total_auctions_created']}') ?? 0,
      totalAuctionsSold: int.tryParse('${json['total_auctions_sold']}') ?? 0,
      totalProductSalesValue: double.tryParse('${json['total_product_sales_value']}') ?? 0,
      totalVatTax: double.tryParse('${json['total_vat_tax']}') ?? 0,
      totalShippingFee: double.tryParse('${json['total_shipping_fee']}') ?? 0,
      grossSalesAmount: double.tryParse('${json['gross_sales_amount']}') ?? 0,
      salesTrend: SalesTrendModel.fromJson(Map<String, dynamic>.from(json['sales_trend'] ?? {})),
    );
  }
}

class AuctionSalesReportItemModel {
  int? id;
  String? name;
  String? slug;
  ImageFullUrl? thumbnailFullUrl;
  String? endTime;
  String? auctionCurrentStatus;
  String? deliveryStatus;
  int? totalParticipants;
  int? totalBids;
  double? currentHighestBidAmount;
  double? shippingFee;
  double? totalTaxAmount;
  double? adminCommission;
  bool? adminCommissionGiven;
  double? entryFeeCollected;

  AuctionSalesReportItemModel({
    this.id,
    this.name,
    this.slug,
    this.thumbnailFullUrl,
    this.endTime,
    this.auctionCurrentStatus,
    this.deliveryStatus,
    this.totalParticipants,
    this.totalBids,
    this.currentHighestBidAmount,
    this.shippingFee,
    this.totalTaxAmount,
    this.adminCommission,
    this.adminCommissionGiven,
    this.entryFeeCollected,
  });

  AuctionSalesReportItemModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse('${json['id']}');
    name = json['name']?.toString();
    slug = json['slug']?.toString();
    thumbnailFullUrl = json['thumbnail_full_url'] is Map
        ? ImageFullUrl.fromJson(Map<String, dynamic>.from(json['thumbnail_full_url'])) : null;
    endTime = json['end_time']?.toString();
    auctionCurrentStatus = json['auction_current_status']?.toString();
    deliveryStatus = json['delivery_status']?.toString();
    totalParticipants = int.tryParse('${json['total_participants']}');
    totalBids = int.tryParse('${json['total_bids']}');
    currentHighestBidAmount = double.tryParse('${json['current_highest_bid_amount']}');
    shippingFee = double.tryParse('${json['shipping_fee']}');
    totalTaxAmount = double.tryParse('${json['total_tax_amount']}');
    adminCommission = double.tryParse('${json['admin_commission']}');
    adminCommissionGiven = json['admin_commission_given'] == true;
    entryFeeCollected = double.tryParse('${json['entry_fee_collected']}');
  }
}

class SalesTrendModel {
  final List<String> labels;
  final List<double> data;

  SalesTrendModel({required this.labels, required this.data});

  factory SalesTrendModel.fromJson(Map<String, dynamic> json) {
    return SalesTrendModel(
      labels: List<String>.from(json['labels'] ?? []),
      data: List<double>.from((json['data'] ?? []).map((e) => double.tryParse(e.toString()) ?? 0)),
    );
  }
}
