import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class AuctionTransactionListModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? lastPage;
  List<AuctionTransactionModel>? transactions;

  AuctionTransactionListModel({this.totalSize, this.limit, this.offset, this.lastPage, this.transactions});

  AuctionTransactionListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: const ['transactions']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    lastPage = envelope.lastPage;

    final dynamic raw = envelope.data ?? envelope.read('transactions');
    if (raw != null) {
      final Iterable items = raw is List ? raw : (raw is Map ? raw.values : const []);
      transactions = items
          .whereType<Map>()
          .map((v) => AuctionTransactionModel.fromJson(Map<String, dynamic>.from(v)))
          .toList();
    }
  }

  bool get hasNextPage {
    final int page = offset ?? 1;
    if (lastPage != null) return page < lastPage!;
    if (totalSize != null && limit != null && limit! > 0) return page * limit! < totalSize!;
    return false;
  }
}

class AuctionTransactionModel {
  int? auctionProductId;
  double? amount;
  String? date;
  String? type;

  AuctionTransactionModel({this.auctionProductId, this.amount, this.date, this.type});

  AuctionTransactionModel.fromJson(Map<String, dynamic> json) {
    auctionProductId = int.tryParse('${json['auction_product_id']}');
    amount = double.tryParse('${json['amount']}');
    date = json['date']?.toString();
    type = json['type']?.toString();
  }

  bool get isCredit => type?.toLowerCase() == 'credit';
}
