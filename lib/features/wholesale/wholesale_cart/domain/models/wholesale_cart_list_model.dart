class WholesaleCartListModel {
  final bool isEmpty;

  final int cartCount;
  final WholesaleCartSummary summary;

  final WholesaleCartCoupon? coupon;

  final List<String> checkoutBlockers;
  final List<WholesaleCartGroup> cartGroups;

  const WholesaleCartListModel({
    this.isEmpty = true,
    this.cartCount = 0,
    this.summary = const WholesaleCartSummary(),
    this.coupon,
    this.checkoutBlockers = const [],
    this.cartGroups = const [],
  });

  bool get canCheckout => !isEmpty && checkoutBlockers.isEmpty;

  List<WholesaleCartRow> get checkoutRows => [
        for (final WholesaleCartGroup group in cartGroups)
          ...group.items.where((row) => row.isChecked && row.isAvailable),
      ];

  factory WholesaleCartListModel.fromJson(Map<String, dynamic> json) {
    final dynamic coupon = json['coupon'];

    return WholesaleCartListModel(
      isEmpty: json['is_empty'] == true,
      cartCount: _toInt(json['cart_count']) ?? 0,
      summary: json['summary'] is Map ? WholesaleCartSummary.fromJson(Map<String, dynamic>.from(json['summary'])) : const WholesaleCartSummary(),
      coupon: coupon is Map ? WholesaleCartCoupon.fromJson(Map<String, dynamic>.from(coupon)) : null,
      checkoutBlockers: _toStringList(json['checkout_blockers']),
      cartGroups: _toMapList(json['cart_groups']).map(WholesaleCartGroup.fromJson).toList(),
    );
  }
}

class WholesaleCartSummary {
  final double subtotal;
  final double discount;
  final double discountedSubtotal;
  final double couponDiscount;
  final double shipping;
  final double tax;
  final double total;

  const WholesaleCartSummary({
    this.subtotal = 0,
    this.discount = 0,
    this.discountedSubtotal = 0,
    this.couponDiscount = 0,
    this.shipping = 0,
    this.tax = 0,
    this.total = 0,
  });

  factory WholesaleCartSummary.fromJson(Map<String, dynamic> json) {
    return WholesaleCartSummary(
      subtotal: _toDouble(json['subtotal']),
      discount: _toDouble(json['discount']),
      discountedSubtotal: _toDouble(json['discounted_subtotal']),
      couponDiscount: _toDouble(json['coupon_discount']),
      shipping: _toDouble(json['shipping']),
      tax: _toDouble(json['tax']),
      total: _toDouble(json['total']),
    );
  }
}

class WholesaleCartCoupon {
  final String? code;
  final String? title;
  final String? type;
  final String? bearer;
  final int? sellerId;
  final double discount;

  const WholesaleCartCoupon({this.code, this.title, this.type, this.bearer, this.sellerId, this.discount = 0});

  factory WholesaleCartCoupon.fromJson(Map<String, dynamic> json) {
    return WholesaleCartCoupon(
      code: json['code']?.toString(),
      title: json['title']?.toString(),
      type: json['type']?.toString(),
      bearer: json['bearer']?.toString(),
      sellerId: _toInt(json['seller_id']),
      discount: _toDouble(json['discount']),
    );
  }
}

class WholesaleCartGroup {
  final String? cartGroupId;
  final WholesaleCartShop? shop;
  final List<WholesaleCartRow> items;

  final double subtotal;
  final double shippingCost;
  final String? shippingType;
  final List<WholesaleCartShippingMethod> shippingMethods;
  final int? selectedShippingMethodId;
  final double minimumOrderAmount;
  final bool isMinimumMet;
  final WholesaleCartFreeDelivery? freeDelivery;

  final List<String> blockers;

  const WholesaleCartGroup({
    this.cartGroupId,
    this.shop,
    this.items = const [],
    this.subtotal = 0,
    this.shippingCost = 0,
    this.shippingType,
    this.shippingMethods = const [],
    this.selectedShippingMethodId,
    this.minimumOrderAmount = 0,
    this.isMinimumMet = true,
    this.freeDelivery,
    this.blockers = const [],
  });

  bool get isGroupChecked => items.isNotEmpty && items.every((row) => row.isChecked);

  bool get isOrderWiseShipping => shippingType == 'order_wise';

  WholesaleCartShippingMethod? get selectedShippingMethod {
    for (final WholesaleCartShippingMethod method in shippingMethods) {
      if (method.id == selectedShippingMethodId) return method;
    }
    return null;
  }

  factory WholesaleCartGroup.fromJson(Map<String, dynamic> json) {
    final dynamic shop = json['shop'];
    final dynamic freeDelivery = json['free_delivery'];

    return WholesaleCartGroup(
      cartGroupId: json['cart_group_id']?.toString(),
      shop: shop is Map ? WholesaleCartShop.fromJson(Map<String, dynamic>.from(shop)) : null,
      items: _toMapList(json['items']).map(WholesaleCartRow.fromJson).toList(),
      subtotal: _toDouble(json['subtotal']),
      shippingCost: _toDouble(json['shipping_cost']),
      shippingType: json['shipping_type']?.toString(),
      shippingMethods: _toMapList(json['shipping_methods']).map(WholesaleCartShippingMethod.fromJson).toList(),
      selectedShippingMethodId: _toInt(json['selected_shipping_method_id']),
      minimumOrderAmount: _toDouble(json['minimum_order_amount']),
      isMinimumMet: json['is_minimum_met'] != false,
      freeDelivery: freeDelivery is Map ? WholesaleCartFreeDelivery.fromJson(Map<String, dynamic>.from(freeDelivery)) : null,
      blockers: _toStringList(json['blockers']),
    );
  }
}

class WholesaleCartShop {
  final int? id;
  final String? name;
  final String? slug;
  final String? imageUrl;
  final bool isClosed;

  const WholesaleCartShop({this.id, this.name, this.slug, this.imageUrl, this.isClosed = false});

  factory WholesaleCartShop.fromJson(Map<String, dynamic> json) {
    return WholesaleCartShop(
      id: _toInt(json['id']),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      imageUrl: json['image_url']?.toString(),
      isClosed: json['is_closed'] == true,
    );
  }
}

class WholesaleCartRow {
  final int? id;
  final String? cartGroupId;
  final int? productId;
  final String? name;
  final String? slug;
  final String? thumbnailUrl;

  final String? variant;
  final List<WholesaleCartSelectionLabel> selectionLabels;
  final double unitPrice;
  final double discountPerUnit;
  final double discountedUnitPrice;
  final double taxPerUnit;
  final String? taxModel;
  final int quantity;
  final int minimumQuantity;

  final int? maximumQuantity;
  final int? availableStock;
  final double lineTotal;

  final String? tierLabel;
  final double shippingCost;
  final String? shippingType;
  final bool isChecked;
  final bool isAvailable;
  final String? message;

  const WholesaleCartRow({
    this.id,
    this.cartGroupId,
    this.productId,
    this.name,
    this.slug,
    this.thumbnailUrl,
    this.variant,
    this.selectionLabels = const [],
    this.unitPrice = 0,
    this.discountPerUnit = 0,
    this.discountedUnitPrice = 0,
    this.taxPerUnit = 0,
    this.taxModel,
    this.quantity = 0,
    this.minimumQuantity = 1,
    this.maximumQuantity,
    this.availableStock,
    this.lineTotal = 0,
    this.tierLabel,
    this.shippingCost = 0,
    this.shippingType,
    this.isChecked = true,
    this.isAvailable = true,
    this.message,
  });

  bool get hasDiscount => discountPerUnit > 0;

  List<String> get selectionSummary => selectionLabels.map((label) => '${label.title}: ${label.value}').toList();

  factory WholesaleCartRow.fromJson(Map<String, dynamic> json) {
    return WholesaleCartRow(
      id: _toInt(json['id']),
      cartGroupId: json['cart_group_id']?.toString(),
      productId: _toInt(json['product_id']),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      thumbnailUrl: json['thumbnail_url']?.toString(),
      variant: json['variant']?.toString(),
      selectionLabels: WholesaleCartSelectionLabel.listFrom(json['selection_labels']),
      unitPrice: _toDouble(json['unit_price']),
      discountPerUnit: _toDouble(json['discount_per_unit']),
      discountedUnitPrice: _toDouble(json['discounted_unit_price']),
      taxPerUnit: _toDouble(json['tax_per_unit']),
      taxModel: json['tax_model']?.toString(),
      quantity: _toInt(json['quantity']) ?? 0,
      minimumQuantity: _toInt(json['minimum_quantity']) ?? 1,
      maximumQuantity: _toInt(json['maximum_quantity']),
      availableStock: _toInt(json['available_stock']),
      lineTotal: _toDouble(json['line_total']),
      tierLabel: json['tier_label']?.toString(),
      shippingCost: _toDouble(json['shipping_cost']),
      shippingType: json['shipping_type']?.toString(),
      isChecked: json['is_checked'] == true || json['is_checked'] == 1,
      isAvailable: json['is_available'] != false,
      message: json['message']?.toString(),
    );
  }
}

class WholesaleCartSelectionLabel {
  final String title;
  final String value;

  const WholesaleCartSelectionLabel({required this.title, required this.value});

  factory WholesaleCartSelectionLabel.fromJson(Map<String, dynamic> json) {
    return WholesaleCartSelectionLabel(title: json['title']?.toString() ?? '', value: json['value']?.toString() ?? '');
  }

  static List<WholesaleCartSelectionLabel> listFrom(dynamic value) {
    if (value is Map) {
      return value.entries.map((entry) => WholesaleCartSelectionLabel(title: '${entry.key}', value: '${entry.value ?? ''}')).toList();
    }
    return _toMapList(value).map(WholesaleCartSelectionLabel.fromJson).toList();
  }
}

class WholesaleCartShippingMethod {
  final int? id;
  final String? title;
  final double cost;
  final String? duration;

  const WholesaleCartShippingMethod({this.id, this.title, this.cost = 0, this.duration});

  factory WholesaleCartShippingMethod.fromJson(Map<String, dynamic> json) {
    return WholesaleCartShippingMethod(
      id: _toInt(json['id']),
      title: json['title']?.toString(),
      cost: _toDouble(json['cost']),
      duration: json['duration']?.toString(),
    );
  }
}

class WholesaleCartFreeDelivery {
  final bool isActive;
  final double amount;
  final double percentage;
  final double remaining;

  const WholesaleCartFreeDelivery({this.isActive = false, this.amount = 0, this.percentage = 0, this.remaining = 0});

  factory WholesaleCartFreeDelivery.fromJson(Map<String, dynamic> json) {
    return WholesaleCartFreeDelivery(
      isActive: json['status'] == 1 || json['status'] == true,
      amount: _toDouble(json['amount']),
      percentage: _toDouble(json['percentage']),
      remaining: _toDouble(json['remaining']),
    );
  }
}

int? _toInt(dynamic value) => value is int ? value : int.tryParse('${value ?? ''}');

double _toDouble(dynamic value) => value is num ? value.toDouble() : double.tryParse('${value ?? ''}') ?? 0;

List<String> _toStringList(dynamic value) =>
    value is List ? value.where((e) => e != null && '$e'.trim().isNotEmpty).map((e) => '$e').toList() : const [];

List<Map<String, dynamic>> _toMapList(dynamic value) =>
    value is List ? value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList() : const [];
