import 'dart:convert';

import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/enum/wholesale_order_status.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

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

Map<String, String> _toStringMap(dynamic value) {
  if (value is! Map) return const {};
  return {
    for (final MapEntry entry in value.entries)
      if (entry.value != null) '${entry.key}': '${entry.value}',
  };
}

List<dynamic> _asList(dynamic value) {
  final dynamic decoded = value is String && value.trim().startsWith('[') ? jsonDecode(value) : value;
  return decoded is List ? decoded : const [];
}

class WholesaleOrderAddressModel {
  final int? id;
  final String contactPersonName;
  final String phone;
  final String addressType;
  final String country;
  final String city;
  final String zip;
  final String address;

  const WholesaleOrderAddressModel({
    this.id,
    required this.contactPersonName,
    required this.phone,
    required this.addressType,
    required this.country,
    required this.city,
    required this.zip,
    required this.address,
  });

  factory WholesaleOrderAddressModel.fromJson(Map<String, dynamic> json) {
    return WholesaleOrderAddressModel(
      id: _toInt(json['id']),
      contactPersonName: json['contact_person_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      addressType: json['address_type']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      zip: json['zip']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }
}

class WholesaleOrderProductItemModel {
  final int id;
  final String image;
  final String name;
  final String? slug;
  final String? variation;
  final Map<String, String> variationSelection;
  final Map<String, String> choiceOptionKeys;
  final List<String> colorCodes;
  final double price;
  final int qty;
  final bool isAvailable;
  final bool isRefundable;
  final String? refundStatusLabel;

  final int? productId;

  final bool isProductResolved;

  bool get canReview => productId != null && isProductResolved;

  const WholesaleOrderProductItemModel({
    required this.id,
    this.productId,
    this.isProductResolved = false,
    required this.image,
    required this.name,
    this.slug,
    this.variation,
    this.variationSelection = const {},
    this.choiceOptionKeys = const {},
    this.colorCodes = const [],
    required this.price,
    required this.qty,
    this.isAvailable = true,
    this.isRefundable = false,
    this.refundStatusLabel,
  });

  String? choiceOptionKeyFor(String title) {
    final String target = title.trim().toLowerCase();
    for (final MapEntry<String, String> entry in choiceOptionKeys.entries) {
      if (entry.key.trim().toLowerCase() == target) return entry.value;
    }
    return null;
  }

  factory WholesaleOrderProductItemModel.fromJson(Map<String, dynamic> json, {Map<String, dynamic>? headerRow}) {
    final Map<String, dynamic> wholesale = _asMap(json['wholesale']) ?? {};
    final Map<String, dynamic>? productData = _asMap(json['product']);
    final Map<String, dynamic> product = productData ?? {};
    final dynamic rawProductDetails = json['product_details'];
    final Map<String, dynamic> productDetails =
        _asMap(rawProductDetails is String ? jsonDecode(rawProductDetails) : rawProductDetails) ?? {};
    final Map<String, dynamic> variationSource =
        _asMap(json['product_all_status']) ?? _asMap(headerRow?['product_all_status']) ?? productData ?? productDetails;

    return WholesaleOrderProductItemModel(
      id: _toInt(json['id']) ?? 0,
      productId: _toInt(json['product_id']) ?? _toInt(product['id']),
      isProductResolved: productData != null,
      image: ImageFullUrl.parse(wholesale['thumbnail'])?.path ?? Images.placeholder,
      name: productDetails['name']?.toString() ?? product['name']?.toString() ?? '',
      slug: productDetails['slug']?.toString() ?? product['slug']?.toString(),
      variation: wholesale['variation']?.toString(),
      variationSelection: _toStringMap(json['variation'] is Map ? json['variation'] : headerRow?['variation']),
      choiceOptionKeys: {
        for (final Map option in _asList(variationSource['choice_options']).whereType<Map>())
          if (option['title'] != null && option['name'] != null) '${option['title']}': '${option['name']}',
      },
      colorCodes: [for (final dynamic code in _asList(variationSource['colors'])) '$code'],
      price: _toDouble(wholesale['unit_price']) ?? _toDouble(json['price']) ?? 0,
      qty: _toInt(json['qty']) ?? 0,
      isAvailable: wholesale['is_product_unavailable'] != true,
      isRefundable: wholesale['is_refundable'] == true,
      refundStatusLabel: wholesale['refund_status_label']?.toString(),
    );
  }
}

class WholesaleDeliveryManModel {
  final int? id;
  final String name;
  final String image;
  final DateTime? assignedAt;

  const WholesaleDeliveryManModel({this.id, required this.name, required this.image, this.assignedAt});

  factory WholesaleDeliveryManModel.fromJson(Map<String, dynamic> json, {dynamic assignedAt}) {
    final String firstName = json['f_name']?.toString() ?? '';
    final String lastName = json['l_name']?.toString() ?? '';

    return WholesaleDeliveryManModel(
      id: _toInt(json['id']),
      name: '$firstName $lastName'.trim(),
      image: ImageFullUrl.parse(json['image_full_url'])?.path ?? Images.sellerPlaceholder,
      assignedAt: DateTime.tryParse('${assignedAt ?? json['assigned_at'] ?? ''}')?.toLocal(),
    );
  }
}

class WholesaleOrderSummaryRow {
  final String label;
  final double amount;
  final num? quantity;
  final bool isDeduction;
  final bool isTotal;

  const WholesaleOrderSummaryRow({
    required this.label,
    required this.amount,
    this.quantity,
    this.isDeduction = false,
    this.isTotal = false,
  });

  factory WholesaleOrderSummaryRow.fromJson(Map<String, dynamic> json) {
    return WholesaleOrderSummaryRow(
      label: json['label']?.toString() ?? '',
      amount: _toDouble(json['amount']) ?? 0,
      quantity: json['quantity'] is num ? json['quantity'] as num : null,
      isDeduction: json['is_deduction'] == true,
      isTotal: json['is_total'] == true,
    );
  }
}

class WholesaleOrderEditHistory {
  final double? orderDueAmount;
  final String? orderDuePaymentStatus;
  final String? orderDuePaymentMethod;
  final double? orderReturnAmount;
  final String? orderReturnPaymentStatus;
  final String? orderReturnPaymentMethod;

  const WholesaleOrderEditHistory({
    this.orderDueAmount,
    this.orderDuePaymentStatus,
    this.orderDuePaymentMethod,
    this.orderReturnAmount,
    this.orderReturnPaymentStatus,
    this.orderReturnPaymentMethod,
  });

  WholesaleOrderEditHistory copyWith({
    String? orderDuePaymentStatus,
    String? orderDuePaymentMethod,
    String? orderReturnPaymentStatus,
    String? orderReturnPaymentMethod,
  }) {
    return WholesaleOrderEditHistory(
      orderDueAmount: orderDueAmount,
      orderDuePaymentStatus: orderDuePaymentStatus ?? this.orderDuePaymentStatus,
      orderDuePaymentMethod: orderDuePaymentMethod ?? this.orderDuePaymentMethod,
      orderReturnAmount: orderReturnAmount,
      orderReturnPaymentStatus: orderReturnPaymentStatus ?? this.orderReturnPaymentStatus,
      orderReturnPaymentMethod: orderReturnPaymentMethod ?? this.orderReturnPaymentMethod,
    );
  }
}

class WholesaleOrderDetailsModel {
  final int id;
  final DateTime orderDate;
  final String orderTypeLabel;
  final WholesaleOrderStatus status;
  final String paymentStatus;
  final String paymentMethod;
  final String? verificationCode;
  final String sellerName;
  final String sellerImage;
  final bool isShopOnVacation;
  final bool isShopTemporaryClosed;
  final String? orderNote;
  final WholesaleOrderAddressModel shippingAddress;
  final WholesaleOrderAddressModel billingAddress;
  final bool billingSameAsShipping;
  final List<WholesaleOrderProductItemModel> products;
  final List<WholesaleOrderSummaryRow> summaryRows;
  final double orderAmount;
  final WholesaleDeliveryManModel? deliveryMan;
  final int? editedStatus;
  final WholesaleOrderEditHistory? latestEditHistory;
  final int? sellerId;

  const WholesaleOrderDetailsModel({
    required this.id,
    required this.orderDate,
    required this.orderTypeLabel,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    this.verificationCode,
    this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    this.isShopOnVacation = false,
    this.isShopTemporaryClosed = false,
    this.orderNote,
    required this.shippingAddress,
    required this.billingAddress,
    required this.billingSameAsShipping,
    required this.products,
    this.summaryRows = const [],
    required this.orderAmount,
    this.deliveryMan,
    this.editedStatus,
    this.latestEditHistory,
  });

  double get totalPayable {
    final WholesaleOrderSummaryRow? totalRow = summaryRows.where((row) => row.isTotal).isEmpty
        ? null : summaryRows.firstWhere((row) => row.isTotal);
    return totalRow?.amount ?? orderAmount;
  }

  factory WholesaleOrderDetailsModel.fromJson(Map<String, dynamic> header, List<dynamic> items) {
    final Map<String, dynamic> wholesale = _asMap(header['wholesale']) ?? {};
    final Map<String, dynamic>? seller = _asMap(header['seller']);
    final Map<String, dynamic>? shop = _asMap(seller?['shop']);
    final Map<String, dynamic>? deliveryMan = _asMap(header['delivery_man']);
    final Map<String, dynamic>? shippingAddressData = _asMap(header['shipping_address_data']);
    final Map<String, dynamic>? billingAddressData = _asMap(header['billing_address_data']);

    final WholesaleOrderAddressModel shippingAddress = shippingAddressData != null
        ? WholesaleOrderAddressModel.fromJson(shippingAddressData)
        : const WholesaleOrderAddressModel(contactPersonName: '', phone: '', addressType: '', country: '', city: '', zip: '', address: '');
    final WholesaleOrderAddressModel billingAddress = billingAddressData != null
        ? WholesaleOrderAddressModel.fromJson(billingAddressData) : shippingAddress;

    final Map<int, Map<String, dynamic>> headerRows = {
      for (final Map row in _asList(header['details']).whereType<Map>())
        if (_toInt(row['id']) != null) _toInt(row['id'])!: Map<String, dynamic>.from(row),
    };

    final double? editDueAmount = _toDouble(header['edit_due_amount']);
    final double? editReturnAmount = _toDouble(header['edit_return_amount']);
    final int? editedStatus = _toInt(header['edited_status']);
    final WholesaleOrderEditHistory? latestEditHistory = ((editDueAmount ?? 0) > 0 || (editReturnAmount ?? 0) > 0)
        ? WholesaleOrderEditHistory(
            orderDueAmount: editDueAmount,
            orderDuePaymentStatus: (editDueAmount ?? 0) > 0 ? 'unpaid' : null,
            orderReturnAmount: editReturnAmount,
            orderReturnPaymentStatus: (editReturnAmount ?? 0) > 0 ? 'pending' : null,
          )
        : null;

    return WholesaleOrderDetailsModel(
      id: _toInt(header['id']) ?? 0,
      orderDate: DateTime.tryParse('${header['created_at']}') ?? DateTime.now(),
      orderTypeLabel: wholesale['order_type_label']?.toString() ?? '',
      status: WholesaleOrderStatus.fromString(header['order_status']?.toString()),
      paymentStatus: header['payment_status']?.toString() ?? 'unpaid',
      paymentMethod: wholesale['payment_method_label']?.toString() ?? header['payment_method']?.toString() ?? '',
      verificationCode: wholesale['verification_code']?.toString(),
      sellerId: _toInt(shop?['seller_id']) ?? _toInt(seller?['id']),
      sellerName: shop?['name']?.toString() ?? '',
      sellerImage: ImageFullUrl.parse(shop?['image_full_url'])?.path ?? Images.sellerPlaceholder,
      isShopOnVacation: shop?['vacation_status'] == true,
      isShopTemporaryClosed: shop?['temporary_close'] == true,
      orderNote: header['order_note']?.toString(),
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      billingSameAsShipping: shippingAddressData != null && billingAddressData != null && shippingAddress.id != null && shippingAddress.id == billingAddress.id,
      products: items.map((v) {
        final Map<String, dynamic> item = Map<String, dynamic>.from(v);
        return WholesaleOrderProductItemModel.fromJson(item, headerRow: headerRows[_toInt(item['id'])]);
      }).toList(),
      summaryRows: (wholesale['summary_rows'] is List ? wholesale['summary_rows'] as List : [])
          .map((v) => WholesaleOrderSummaryRow.fromJson(Map<String, dynamic>.from(v))).toList(),
      orderAmount: _toDouble(header['order_amount']) ?? 0,
      deliveryMan: deliveryMan != null ? WholesaleDeliveryManModel.fromJson(deliveryMan, assignedAt: header['deliveryman_assigned_at']) : null,
      editedStatus: editedStatus,
      latestEditHistory: latestEditHistory,
    );
  }

  WholesaleOrderDetailsModel copyWith({WholesaleOrderEditHistory? latestEditHistory}) {
    return WholesaleOrderDetailsModel(
      id: id,
      orderDate: orderDate,
      orderTypeLabel: orderTypeLabel,
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      verificationCode: verificationCode,
      sellerId: sellerId,
      sellerName: sellerName,
      sellerImage: sellerImage,
      isShopOnVacation: isShopOnVacation,
      isShopTemporaryClosed: isShopTemporaryClosed,
      orderNote: orderNote,
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      billingSameAsShipping: billingSameAsShipping,
      products: products,
      summaryRows: summaryRows,
      orderAmount: orderAmount,
      deliveryMan: deliveryMan,
      editedStatus: editedStatus,
      latestEditHistory: latestEditHistory ?? this.latestEditHistory,
    );
  }
}
