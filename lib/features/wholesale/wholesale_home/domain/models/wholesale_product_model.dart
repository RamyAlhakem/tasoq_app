import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class WholesaleProductListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<WholesaleProduct>? products;

  WholesalePriceBounds? priceBounds;

  WholesaleProductListModel({this.totalSize, this.limit, this.offset, this.products, this.priceBounds});

  WholesaleProductListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    priceBounds = WholesalePriceBounds.parse(envelope.read('price_bounds'));
    if (envelope.data != null) {
      products = [
        for (final Map row in envelope.data!.whereType<Map>())
          WholesaleProduct.fromJson(Map<String, dynamic>.from(row)),
      ];
    }
  }
}

class WholesalePriceBounds {
  final double min;
  final double max;

  const WholesalePriceBounds({required this.min, required this.max});

  static WholesalePriceBounds? parse(dynamic value) {
    if (value is! Map) return null;

    final double? min = double.tryParse('${value['min']}');
    final double? max = double.tryParse('${value['max']}');
    if (min == null || max == null) return null;

    return WholesalePriceBounds(min: min, max: max);
  }
}

class WholesaleProduct {
  final int? id;
  final String? slug;
  final String? productName;
  final double? minPrice;
  final double? maxPrice;
  final double? minDiscountedPrice;
  final double? maxDiscountedPrice;
  final int? minimumOrderQuantity;
  final double? discountedPercentage;
  final ImageFullUrl? thumbnailFullUrl;
  final String? category;
  final int? currentStock;
  final String? unit;

  final double? previousMinPrice;
  final double? previousMaxPrice;

  final int? previousMinimumOrderQuantity;

  const WholesaleProduct({
    this.id,
    this.slug,
    this.productName,
    this.minPrice,
    this.maxPrice,
    this.minDiscountedPrice,
    this.maxDiscountedPrice,
    this.minimumOrderQuantity,
    this.discountedPercentage,
    this.thumbnailFullUrl,
    this.category,
    this.currentStock,
    this.unit,
    this.previousMinPrice,
    this.previousMaxPrice,
    this.previousMinimumOrderQuantity,
  });

  factory WholesaleProduct.fromJson(Map<String, dynamic> json) {
    final Map priceRange = json['price_range'] is Map ? json['price_range'] : const {};
    final double? minPrice = _toDouble(priceRange['min']);
    final double? maxPrice = _toDouble(priceRange['max']);

    double discount = _toDouble(json['discount']) ?? 0;
    bool isPercentDiscount = json['discount_type'] == 'percent';

    final double serverPercentage = _toDouble(json['discount_percentage']) ?? 0;
    final bool onlyMaxDiscounted = discount <= 0 && serverPercentage > 0;
    if (onlyMaxDiscounted) {
      discount = serverPercentage;
      isPercentDiscount = true;
    }

    final Map? previousPriceRange = json['previous_price_range'] is Map ? json['previous_price_range'] : null;

    return WholesaleProduct(
      id: _toInt(json['id']),
      slug: json['slug'],
      productName: json['name'],
      minPrice: minPrice,
      maxPrice: maxPrice,
      minDiscountedPrice: onlyMaxDiscounted ? minPrice : _applyDiscount(minPrice, discount, isPercentDiscount),
      maxDiscountedPrice: _applyDiscount(maxPrice, discount, isPercentDiscount),
      minimumOrderQuantity: _toInt(json['minimum_order_qty']),
      discountedPercentage: _discountPercentage(minPrice, discount, isPercentDiscount),
      thumbnailFullUrl: ImageFullUrl.parse(json['thumbnail_full_url'] ?? json['thumbnail']),
      currentStock: _toInt(json['current_stock']),
      unit: json['unit'],
      previousMinPrice: previousPriceRange == null ? null : _toDouble(previousPriceRange['min']),
      previousMaxPrice: previousPriceRange == null ? null : _toDouble(previousPriceRange['max']),
      previousMinimumOrderQuantity: _toInt(json['previous_minimum_order_qty']),
    );
  }

  static double? _applyDiscount(double? price, double discount, bool isPercent) {
    if (price == null || discount <= 0) return price;
    final double discounted = isPercent ? price - (price * discount / 100) : price - discount;
    return discounted < 0 ? 0 : discounted;
  }

  static double? _discountPercentage(double? minPrice, double discount, bool isPercent) {
    if (discount <= 0) return null;
    if (isPercent) return discount;
    if (minPrice == null || minPrice == 0) return null;
    return (discount / minPrice) * 100;
  }

  static double? _toDouble(dynamic value) => value == null ? null : double.tryParse('$value');

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value') ?? double.tryParse('$value')?.toInt();
  }
}
