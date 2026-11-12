import 'dart:convert';
import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';

class LoyaltyPointModel {
  int? limit;
  int? offset;
  int? totalSize;
  String? filterBy;
  DateTime? startDate;
  DateTime? endDate;
  List<String>? transactionTypes;
  int? totalLoyaltyPoint;
  List<LoyaltyPointList>? loyaltyPointList;


  LoyaltyPointModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['loyalty_point_list']);
    final Map params = envelope.content['params'] is Map ? envelope.content['params'] : const {};
    final Map summary = envelope.content['summary'] is Map ? envelope.content['summary'] : const {};

    limit = envelope.limit;
    offset = envelope.offset;
    totalSize = envelope.totalSize;
    filterBy = params['entry_type'] ?? params['filter_by'] ?? json['filter_by'];
    startDate = DateConverter.convertDurationDateTimeFromString(params['start_date'] ?? json['start_date']);
    endDate = DateConverter.convertDurationDateTimeFromString(params['end_date'] ?? json['end_date']);
    transactionTypes = _readTransactionTypes(params['transaction_types'] ?? json['transaction_types']);

    totalLoyaltyPoint = int.tryParse('${summary['total_loyalty_point'] ?? envelope.read('total_loyalty_point')}');

    if (envelope.data != null) {
      loyaltyPointList = <LoyaltyPointList>[];
      for (final dynamic v in envelope.data!) {
        if (v is Map) loyaltyPointList!.add(LoyaltyPointList.fromJson(Map<String, dynamic>.from(v)));
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['offset'] = offset;
    data['total_loyalty_point'] = totalLoyaltyPoint;
    if (loyaltyPointList != null) {
      data['loyalty_point_list'] = loyaltyPointList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoyaltyPointList {
  int? _id;
  int? _userId;
  String? _transactionId;
  double? _credit;
  double? _debit;
  double? _balance;
  String? _reference;
  String? _transactionType;
  String? _createdAt;
  String? _updatedAt;
  bool? _isWholesaleOrder;

  LoyaltyPointList(
      {int? id,
        int? userId,
        String? transactionId,
        double? credit,
        double? debit,
        double? balance,
        String? reference,
        String? transactionType,
        String? createdAt,
        String? updatedAt,
        bool? isWholesaleOrder}) {
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
    if (balance != null) {
      _balance = balance;
    }
    if (reference != null) {
      _reference = reference;
    }
    if (transactionType != null) {
      _transactionType = transactionType;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    if (isWholesaleOrder != null) {
      _isWholesaleOrder = isWholesaleOrder;
    }
  }

  int? get id => _id;
  int? get userId => _userId;
  String? get transactionId => _transactionId;
  double? get credit => _credit;
  double? get debit => _debit;
  double? get balance => _balance;
  String? get reference => _reference;
  String? get transactionType => _transactionType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  bool? get isWholesaleOrder => _isWholesaleOrder;


  LoyaltyPointList.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _transactionId = json['transaction_id'];
    _credit =  double.tryParse(json['credit'].toString());
    _debit = double.tryParse(json['debit'].toString());
    _balance = double.tryParse('${json['balance']}');
    _reference = json['reference'];
    _transactionType = json['transaction_type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isWholesaleOrder = json['is_wholesale_order'] == true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['transaction_id'] = _transactionId;
    data['credit'] = _credit;
    data['debit'] = _debit;
    data['balance'] = _balance;
    data['reference'] = _reference;
    data['transaction_type'] = _transactionType;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['is_wholesale_order'] = _isWholesaleOrder;
    return data;
  }
}
