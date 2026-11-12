import 'dart:convert';

import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';

class WalletTransactionModel {
  int? limit;
  int? offset;
  int? totalSize;
  double? totalWalletBalance;
  String? filterBy;
  DateTime? startDate;
  DateTime? endDate;
  List<String>? transactionTypes;
  List<WalletTransactionList>? walletTransactionList;
  

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['wallet_transaction_list']);
    final Map params = envelope.content['params'] is Map ? envelope.content['params'] : const {};
    final Map summary = envelope.content['summary'] is Map ? envelope.content['summary'] : const {};

    limit = envelope.limit;
    offset = envelope.offset;
    totalSize = envelope.totalSize;

    // The all/debit/credit filter is `entry_type` in v6 and `filter_by` before
    // it. The Dart name stays `filterBy` because the filter sheet and the badge
    // count are keyed on it.
    filterBy = params['entry_type'] ?? params['filter_by'] ?? json['filter_by'];
    startDate = DateConverter.convertDurationDateTimeFromString(params['start_date'] ?? json['start_date']);
    endDate = DateConverter.convertDurationDateTimeFromString(params['end_date'] ?? json['end_date']);
    transactionTypes = _readTransactionTypes(params['transaction_types'] ?? json['transaction_types']);

    totalWalletBalance =
        double.tryParse('${summary['total_wallet_balance'] ?? envelope.read('total_wallet_balance')}') ?? 0.0;

    if (envelope.data != null) {
      walletTransactionList = <WalletTransactionList>[];
      for (final dynamic v in envelope.data!) {
        if (v is Map) walletTransactionList!.add(WalletTransactionList.fromJson(Map<String, dynamic>.from(v)));
      }
    }
  }

  static List<String>? _readTransactionTypes(dynamic value) {
    if (value is List) return value.map((type) => type.toString()).toList();
    if (value is String && value.isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(value);
        if (decoded is List) return decoded.map((type) => type.toString()).toList();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

}

class WalletTransactionList {
  int? _id;
  int? _userId;
  String? _transactionId;
  double? _credit;
  double? _debit;
  double? _adminBonus;
  double? _balance;
  String? _transactionType;
  String? _reference;
  String? _createdAt;
  String? _updatedAt;
  String? paymentMethod;
  String? _businessModule;

  WalletTransactionList(
      {int? id,
        int? userId,
        String? transactionId,
        double? credit,
        double? debit,
        double? adminBonus,
        double? balance,
        String? transactionType,
        String? reference,
        String? createdAt,
        String? updatedAt,
        String? paymentMethod,
        String? businessModule
      }) {
    if (id != null) {
      _id = id;
    }
    if (userId != null) {
      _userId = userId;
    }
    if (transactionId != null) {
      _transactionId = transactionId;
    }
    if (credit != null) {
      _credit = credit;
    }
    if (debit != null) {
      _debit = debit;
    }
    if (adminBonus != null) {
      _adminBonus = adminBonus;
    }
    if (balance != null) {
      _balance = balance;
    }
    if (transactionType != null) {
      _transactionType = transactionType;
    }
    if (reference != null) {
      _reference = reference;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    this.paymentMethod;
    if (businessModule != null) {
      _businessModule = businessModule;
    }
  }

  int? get id => _id;
  int? get userId => _userId;
  String? get transactionId => _transactionId;
  double? get credit => _credit;
  double? get debit => _debit;
  double? get adminBonus => _adminBonus;
  double? get balance => _balance;
  String? get transactionType => _transactionType;
  String? get reference => _reference;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get businessModule => _businessModule;

  WalletTransactionList.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _transactionId = json['transaction_id'];
    _credit = double.tryParse('${json['credit']}');
    _debit = double.tryParse('${json['debit']}');
    _adminBonus = double.tryParse('${json['admin_bonus']}');
    _balance = double.tryParse('${json['balance']}');
    _transactionType = json['transaction_type'];
    _reference = json['reference'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    paymentMethod = json['payment_method'];
    _businessModule = json['business_module'];
  }

}
