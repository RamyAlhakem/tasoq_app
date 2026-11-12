import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_refund_info_model.dart';

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

Map<String, dynamic>? _asMap(dynamic value) => value is Map ? Map<String, dynamic>.from(value) : null;

class WholesaleRefundResultModel {
  final int id;
  final int orderDetailsId;
  final int? customerId;
  final String status;

  final int? approvedCount;
  final int? deniedCount;
  final double amount;
  final int? productId;
  final int? orderId;
  final String? refundReason;
  final List<ImageFullUrl> imagesFullUrl;
  final String? approvedNote;
  final String? rejectedNote;
  final String? paymentInfo;
  final String? changeBy;
  final String? createdAt;
  final String? updatedAt;

  final String? statusLabel;
  final String? statusTone;

  final WholesaleRefundBreakdown? refund;
  final List<WholesaleRefundStatusEntry> statusHistory;

  const WholesaleRefundResultModel({
    required this.id,
    required this.orderDetailsId,
    this.customerId,
    required this.status,
    this.approvedCount,
    this.deniedCount,
    this.amount = 0,
    this.productId,
    this.orderId,
    this.refundReason,
    this.imagesFullUrl = const [],
    this.approvedNote,
    this.rejectedNote,
    this.paymentInfo,
    this.changeBy,
    this.createdAt,
    this.updatedAt,
    this.statusLabel,
    this.statusTone,
    this.refund,
    this.statusHistory = const [],
  });

  factory WholesaleRefundResultModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> wholesale = _asMap(json['wholesale']) ?? {};

    final List<dynamic> historySource = wholesale['status_history'] is List ? wholesale['status_history'] as List : const [];

    return WholesaleRefundResultModel(
      id: _toInt(json['id']) ?? 0,
      orderDetailsId: _toInt(json['order_details_id']) ?? 0,
      customerId: _toInt(json['customer_id']),
      status: json['status']?.toString() ?? 'pending',
      approvedCount: _toInt(json['approved_count']),
      deniedCount: _toInt(json['denied_count']),
      amount: _toDouble(json['amount']) ?? 0,
      productId: _toInt(json['product_id']),
      orderId: _toInt(json['order_id']),
      refundReason: json['refund_reason']?.toString(),
      imagesFullUrl: json['images_full_url'] is List
          ? (json['images_full_url'] as List).map(ImageFullUrl.parse).whereType<ImageFullUrl>().toList()
          : const [],
      approvedNote: json['approved_note']?.toString(),
      rejectedNote: json['rejected_note']?.toString(),
      paymentInfo: json['payment_info']?.toString(),
      changeBy: json['change_by']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      statusLabel: wholesale['status_label']?.toString(),
      statusTone: wholesale['status_tone']?.toString(),
      refund: wholesale['refund'] is Map ? WholesaleRefundBreakdown.fromJson(Map<String, dynamic>.from(wholesale['refund'])) : null,
      statusHistory: historySource.map((v) => WholesaleRefundStatusEntry.fromJson(Map<String, dynamic>.from(v))).toList(),
    );
  }
}

class WholesaleRefundStatusEntry {
  final String? status;
  final String? statusLabel;
  final String? message;
  final String? changedBy;
  final String? changedAt;

  const WholesaleRefundStatusEntry({this.status, this.statusLabel, this.message, this.changedBy, this.changedAt});

  factory WholesaleRefundStatusEntry.fromJson(Map<String, dynamic> json) {
    return WholesaleRefundStatusEntry(
      status: json['status']?.toString(),
      statusLabel: json['status_label']?.toString(),
      message: json['message']?.toString(),
      changedBy: json['changed_by']?.toString(),
      changedAt: json['changed_at']?.toString(),
    );
  }
}
