import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/enum/wholesale_order_status.dart';

class WholesaleOrderListResponseModel {
  final int? totalSize;
  final int? limit;
  final int? offset;
  final List<WholesaleOrderModel> orders;

  const WholesaleOrderListResponseModel({this.totalSize, this.limit, this.offset, this.orders = const []});

  factory WholesaleOrderListResponseModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    return WholesaleOrderListResponseModel(
      totalSize: envelope.totalSize,
      limit: envelope.limit,
      offset: envelope.offset,
      orders: (envelope.data ?? []).map((v) => WholesaleOrderModel.fromJson(Map<String, dynamic>.from(v))).toList(),
    );
  }
}

class WholesaleOrderModel {
  final int id;
  final String shopName;
  final String shopLogo;
  final DateTime orderDate;
  final double amount;
  final int productCount;
  final int unitCount;
  final WholesaleOrderStatus status;

  final bool canCancel;

  final int? editedStatus;
  final double? editDueAmount;
  final double? editReturnAmount;

  const WholesaleOrderModel({
    required this.id,
    required this.shopName,
    required this.shopLogo,
    required this.orderDate,
    required this.amount,
    required this.productCount,
    required this.unitCount,
    required this.status,
    this.canCancel = false,
    this.editedStatus,
    this.editDueAmount,
    this.editReturnAmount,
  });

  factory WholesaleOrderModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? seller = json['seller'] is Map ? Map<String, dynamic>.from(json['seller']) : null;
    final Map<String, dynamic>? shop = seller?['shop'] is Map ? Map<String, dynamic>.from(seller!['shop']) : null;
    final Map<String, dynamic>? wholesale = json['wholesale'] is Map ? Map<String, dynamic>.from(json['wholesale']) : null;
    final List? details = json['details'] is List ? json['details'] as List : null;

    return WholesaleOrderModel(
      id: _toInt(json['id']) ?? 0,
      shopName: shop?['name']?.toString() ?? '',
      shopLogo: ImageFullUrl.parse(shop?['image_full_url'])?.path ?? '',
      orderDate: DateTime.tryParse('${json['created_at']}') ?? DateTime.now(),
      amount: _toDouble(wholesale?['total_amount']) ?? _toDouble(json['order_amount']) ?? 0,
      productCount: details?.length ?? _toInt(wholesale?['total_item_quantity']) ?? 0,
      unitCount: _toInt(wholesale?['total_item_quantity']) ?? 0,
      status: WholesaleOrderStatus.fromString(json['order_status']?.toString()),
      canCancel: wholesale?['can_cancel'] == true,
      editedStatus: _toInt(json['edited_status']),
      editDueAmount: _toDouble(json['edit_due_amount']),
      editReturnAmount: _toDouble(json['edit_return_amount']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
