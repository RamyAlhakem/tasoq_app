class WholesalePurchaseOptions {
  final String? pricingMode;

  final String? priceAxis;

  final String? unit;
  final int? minimumOrderQty;

  final List<WholesaleVariationAxis> axes;
  final List<WholesalePriceRow> priceRows;
  final WholesaleDiscountHighlights? discountHighlights;

  final Map<String, int> stock;

  final Map<String, Map<String, List<String>>> images;

  final Map<String, String> defaultSelection;

  const WholesalePurchaseOptions({
    this.pricingMode,
    this.priceAxis,
    this.unit,
    this.minimumOrderQty,
    this.axes = const [],
    this.priceRows = const [],
    this.discountHighlights,
    this.stock = const {},
    this.images = const {},
    this.defaultSelection = const {},
  });

  bool get isSingleVariant => axes.isEmpty;

  factory WholesalePurchaseOptions.fromJson(Map<String, dynamic> json) {
    return WholesalePurchaseOptions(
      pricingMode: json['pricing_mode'] as String?,
      priceAxis: json['price_axis'] as String?,
      unit: json['unit'] as String?,
      minimumOrderQty: _toInt(json['minimum_order_qty']),
      axes: _listOf(json['axes'], WholesaleVariationAxis.fromJson),
      priceRows: _listOf(json['price_rows'], WholesalePriceRow.fromJson),
      discountHighlights: json['discount_highlights'] is Map
          ? WholesaleDiscountHighlights.fromJson(Map<String, dynamic>.from(json['discount_highlights']))
          : null,
      stock: _parseStock(json['stock']),
      images: _parseImages(json['images']),
      defaultSelection: _parseStringMap(json['default_selection']),
    );
  }

  static Map<String, int> _parseStock(dynamic value) {
    if (value is! Map) return const {};
    final Map<String, int> parsed = {};
    value.forEach((key, qty) {
      final int? amount = _toInt(qty);
      if (amount != null) parsed['$key'] = amount;
    });
    return parsed;
  }

  static Map<String, Map<String, List<String>>> _parseImages(dynamic value) {
    if (value is! Map) return const {};
    final Map<String, Map<String, List<String>>> parsed = {};
    value.forEach((axisKey, byValue) {
      if (byValue is! Map) return;
      final Map<String, List<String>> urlsByValue = {};
      byValue.forEach((optionValue, urls) {
        if (urls is List) {
          urlsByValue['$optionValue'] = urls.map((url) => '$url').where((url) => url.isNotEmpty).toList();
        }
      });
      if (urlsByValue.isNotEmpty) parsed['$axisKey'] = urlsByValue;
    });
    return parsed;
  }

  static Map<String, String> _parseStringMap(dynamic value) {
    if (value is! Map) return const {};
    final Map<String, String> parsed = {};
    value.forEach((key, entry) {
      if (entry != null) parsed['$key'] = '$entry';
    });
    return parsed;
  }

  static List<T> _listOf<T>(dynamic value, T Function(Map<String, dynamic>) parse) {
    if (value is! List) return const [];
    return [
      for (final Map row in value.whereType<Map>()) parse(Map<String, dynamic>.from(row)),
    ];
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value') ?? double.tryParse('$value')?.toInt();
  }
}

class WholesaleVariationAxis {
  final String key;

  final String type;

  final int? attributeId;

  final String? title;

  final bool isPriceAxis;
  final List<WholesaleAxisOption> options;

  const WholesaleVariationAxis({
    required this.key,
    required this.type,
    this.attributeId,
    this.title,
    this.isPriceAxis = false,
    this.options = const [],
  });

  bool get isColorAxis => type == 'color';

  factory WholesaleVariationAxis.fromJson(Map<String, dynamic> json) {
    return WholesaleVariationAxis(
      key: '${json['key'] ?? ''}',
      type: '${json['type'] ?? 'attribute'}',
      attributeId: WholesalePurchaseOptions._toInt(json['attribute_id']),
      title: json['title'] as String?,
      isPriceAxis: json['is_price_axis'] == true,
      options: WholesalePurchaseOptions._listOf(json['options'], WholesaleAxisOption.fromJson),
    );
  }
}

class WholesaleAxisOption {
  final String value;

  final String label;

  final bool hasDiscount;

  const WholesaleAxisOption({required this.value, required this.label, this.hasDiscount = false});

  factory WholesaleAxisOption.fromJson(Map<String, dynamic> json) {
    final String value = '${json['value'] ?? ''}';
    return WholesaleAxisOption(
      value: value,
      label: '${json['label'] ?? value}',
      hasDiscount: json['has_discount'] == true,
    );
  }
}

class WholesalePriceRow {
  final String? variationValue;

  final double? unitPrice;
  final double? discount;
  final List<WholesalePriceTier> tiers;

  const WholesalePriceRow({this.variationValue, this.unitPrice, this.discount, this.tiers = const []});

  factory WholesalePriceRow.fromJson(Map<String, dynamic> json) {
    return WholesalePriceRow(
      variationValue: json['variation_value'] as String?,
      unitPrice: WholesalePriceQuoteNum.toDouble(json['unit_price']),
      discount: WholesalePriceQuoteNum.toDouble(json['discount']),
      tiers: WholesalePurchaseOptions._listOf(json['tiers'], WholesalePriceTier.fromJson),
    );
  }
}

class WholesalePriceTier {
  final int minQty;

  final int? maxQty;

  final double? unitPrice;
  final double? discount;

  final double? discountedUnitPrice;

  const WholesalePriceTier({
    required this.minQty,
    this.maxQty,
    this.unitPrice,
    this.discount,
    this.discountedUnitPrice,
  });

  bool contains(int quantity) => quantity >= minQty && (maxQty == null || quantity <= maxQty!);

  factory WholesalePriceTier.fromJson(Map<String, dynamic> json) {
    return WholesalePriceTier(
      minQty: WholesalePurchaseOptions._toInt(json['min_qty']) ?? 0,
      maxQty: WholesalePurchaseOptions._toInt(json['max_qty']),
      unitPrice: WholesalePriceQuoteNum.toDouble(json['unit_price']),
      discount: WholesalePriceQuoteNum.toDouble(json['discount']),
      discountedUnitPrice: WholesalePriceQuoteNum.toDouble(json['discounted_unit_price']),
    );
  }
}

class WholesaleDiscountHighlights {
  final String? kind;
  final String? axisKey;
  final List<WholesaleDiscountHighlightItem> items;

  const WholesaleDiscountHighlights({this.kind, this.axisKey, this.items = const []});

  bool get isCombination => kind == 'combination';

  factory WholesaleDiscountHighlights.fromJson(Map<String, dynamic> json) {
    return WholesaleDiscountHighlights(
      kind: json['kind'] as String?,
      axisKey: json['axis_key'] as String?,
      items: WholesalePurchaseOptions._listOf(json['items'], WholesaleDiscountHighlightItem.fromJson),
    );
  }
}

class WholesaleDiscountHighlightItem {
  final String? value;
  final String? variationValue;
  final int? minQty;
  final int? maxQty;
  final double? discount;

  const WholesaleDiscountHighlightItem({this.value, this.variationValue, this.minQty, this.maxQty, this.discount});

  factory WholesaleDiscountHighlightItem.fromJson(Map<String, dynamic> json) {
    return WholesaleDiscountHighlightItem(
      value: json['value'] as String?,
      variationValue: json['variation_value'] as String?,
      minQty: WholesalePurchaseOptions._toInt(json['min_qty']),
      maxQty: WholesalePurchaseOptions._toInt(json['max_qty']),
      discount: WholesalePriceQuoteNum.toDouble(json['discount']),
    );
  }
}

class WholesalePriceQuoteNum {
  static double? toDouble(dynamic value) => value == null ? null : double.tryParse('$value');
}
