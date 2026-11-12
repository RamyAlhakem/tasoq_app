import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';

class WithdrawStoreOrUpdateResponseModel {
  final String? message;
  final WithdrawResult? withdraw;
  final WithdrawBreakdown? breakdown;

  WithdrawStoreOrUpdateResponseModel({this.message, this.withdraw, this.breakdown});

  factory WithdrawStoreOrUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    final Map content = ApiEnvelope.content(json);
    return WithdrawStoreOrUpdateResponseModel(
      message: ApiEnvelope.message(json),
      withdraw: content['withdraw'] is Map
          ? WithdrawResult.fromJson(Map<String, dynamic>.from(content['withdraw'])) : null,
      breakdown: content['breakdown'] is Map
          ? WithdrawBreakdown.fromJson(Map<String, dynamic>.from(content['breakdown'])) : null,
    );
  }
}

class WithdrawResult {
  final int? id;
  final String? status;
  final double? amount;
  final double? commissionAmount;

  WithdrawResult({this.id, this.status, this.amount, this.commissionAmount});

  WithdrawResult.fromJson(Map<String, dynamic> json)
      : id = json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
        status = json['status'],
        amount = json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
        commissionAmount = json['commission_amount'] != null ? double.tryParse(json['commission_amount'].toString()) : null;
}

class WithdrawBreakdown {
  final double? bidAmount;
  final double? shippingFee;
  final double? taxAmount;
  final String? taxType;
  final double? totalPayable;
  final double? commissionPercentage;
  final double? commissionAmount;
  final double? vendorReceivable;

  WithdrawBreakdown({
    this.bidAmount,
    this.shippingFee,
    this.taxAmount,
    this.taxType,
    this.totalPayable,
    this.commissionPercentage,
    this.commissionAmount,
    this.vendorReceivable,
  });

  WithdrawBreakdown.fromJson(Map<String, dynamic> json)
      : bidAmount = json['bid_amount'] != null ? double.tryParse(json['bid_amount'].toString()) : null,
        shippingFee = json['shipping_fee'] != null ? double.tryParse(json['shipping_fee'].toString()) : null,
        taxAmount = json['tax_amount'] != null ? double.tryParse(json['tax_amount'].toString()) : null,
        taxType = json['tax_type'],
        totalPayable = json['total_payable'] != null ? double.tryParse(json['total_payable'].toString()) : null,
        commissionPercentage = json['commission_percentage'] != null ? double.tryParse(json['commission_percentage'].toString()) : null,
        commissionAmount = json['commission_amount'] != null ? double.tryParse(json['commission_amount'].toString()) : null,
        vendorReceivable = json['vendor_receivable'] != null ? double.tryParse(json['vendor_receivable'].toString()) : null;
}
