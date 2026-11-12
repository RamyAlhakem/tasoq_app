import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_price_tier_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_choice_option_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_color_image_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_color_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_digital_variation_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_variation_model.dart';

class WholesaleAiShoppingProductModel {
  final int id;
  final String name;
  final String? slug;
  final double unitPrice;
  final String? unitPriceFormatted;
  final double? discount;
  final String? discountType;
  final String? discountFormatted;
  final double? discountedPrice;
  final String? discountedPriceFormatted;
  final double? rating;
  final int? reviewsCount;
  final String? thumbnail;
  final String? thumbnailFullUrl;
  final int? currentStock;
  final String? productType;
  final List<WholesaleAiShoppingColorModel> colors;
  final List<WholesaleAiShoppingColorImageModel> colorImages;
  final List<WholesaleAiShoppingChoiceOptionModel> choiceOptions;
  final List<WholesaleAiShoppingVariationModel> physicalVariations;
  final List<WholesaleAiShoppingDigitalVariationModel> digitalVariations;
  final Map<String, List<String>>? digitalProductExtensions;
  final int? minimumOrderQty;
  final String? colorAxisKey;
  final List<WholesaleAiShoppingPriceTierModel> priceTiers;

  const WholesaleAiShoppingProductModel({
    required this.id,
    required this.name,
    this.slug,
    required this.unitPrice,
    this.unitPriceFormatted,
    this.discount,
    this.discountType,
    this.discountFormatted,
    this.discountedPrice,
    this.discountedPriceFormatted,
    this.rating,
    this.reviewsCount,
    this.thumbnail,
    this.thumbnailFullUrl,
    this.currentStock,
    this.productType,
    this.colors = const [],
    this.colorImages = const [],
    this.choiceOptions = const [],
    this.physicalVariations = const [],
    this.digitalVariations = const [],
    this.digitalProductExtensions,
    this.minimumOrderQty,
    this.colorAxisKey,
    this.priceTiers = const [],
  });

  bool get isDigital => productType == 'digital' || digitalVariations.isNotEmpty;
  bool get hasColors => colors.isNotEmpty;
  bool get hasChoiceOptions => choiceOptions.isNotEmpty;
  bool get hasPhysicalVariations => physicalVariations.isNotEmpty;
  bool get hasDiscount => (discount ?? 0) > 0;

  WholesaleProduct toWholesaleProduct() {
    final double discounted = discountedPrice ?? unitPrice;
    return WholesaleProduct(
      id: id,
      slug: slug,
      productName: name,
      minPrice: unitPrice,
      maxPrice: unitPrice,
      minDiscountedPrice: discounted,
      maxDiscountedPrice: discounted,
      minimumOrderQuantity: minimumOrderQty,
      discountedPercentage: unitPrice > 0 && discounted < unitPrice ? (unitPrice - discounted) / unitPrice * 100 : null,
      thumbnailFullUrl: ImageFullUrl.parse(thumbnailFullUrl ?? thumbnail),
      currentStock: currentStock,
    );
  }

  factory WholesaleAiShoppingProductModel.fromJson(Map<String, dynamic> json) {
    return WholesaleAiShoppingProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'],
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      unitPriceFormatted: json['unit_price_formatted'],
      discount: (json['discount'] as num?)?.toDouble(),
      discountType: json['discount_type'],
      discountFormatted: json['discount_formatted'],
      discountedPrice: (json['discounted_price'] as num?)?.toDouble(),
      discountedPriceFormatted: json['discounted_price_formatted'],
      rating: (json['rating'] as num?)?.toDouble() ??
          (json['avg_rating'] as num?)?.toDouble(),
      reviewsCount: json['reviews_count'] ?? json['rating_count'],
      thumbnail: json['thumbnail'],
      thumbnailFullUrl: json['thumbnail_full_url'],
      currentStock: json['current_stock'],
      productType: json['product_type'],
      colors: (json['colors'] as List<dynamic>?)
              ?.map((e) => WholesaleAiShoppingColorModel.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      colorImages: (json['color_images'] as List<dynamic>?)
              ?.map((e) => WholesaleAiShoppingColorImageModel.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      choiceOptions: (json['choice_options'] as List<dynamic>?)
              ?.map((e) => WholesaleAiShoppingChoiceOptionModel.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      physicalVariations: (json['variation'] as List<dynamic>?)
              ?.map((e) => WholesaleAiShoppingVariationModel.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      digitalVariations: () {
        final explicit = (json['digital_variations'] as List<dynamic>?)
            ?.map((e) => WholesaleAiShoppingDigitalVariationModel.fromJson(
                  Map<String, dynamic>.from(e)))
            .toList();
        if (explicit != null && explicit.isNotEmpty) return explicit;

        final extMap = json['digital_product_extensions'];
        if (extMap == null || extMap is! Map) {
          return <WholesaleAiShoppingDigitalVariationModel>[];
        }
        final priceList =
            (json['digital_variation'] as List<dynamic>?) ?? [];
        final basePrice =
            (json['unit_price'] as num?)?.toDouble() ?? 0.0;

        double priceFor(String key) {
          for (final item in priceList) {
            if (item['variant_key'] == key) {
              return (item['price'] as num?)?.toDouble() ?? basePrice;
            }
          }
          return basePrice;
        }

        final result = <WholesaleAiShoppingDigitalVariationModel>[];
        (extMap as Map<String, dynamic>).forEach((type, exts) {
          if (exts is List) {
            for (final ext in exts) {
              final key = '$type-$ext';
              final typeCap = type.isNotEmpty
                  ? '${type[0].toUpperCase()}${type.substring(1)}'
                  : type;
              result.add(WholesaleAiShoppingDigitalVariationModel(
                variantKey: key,
                label: '$typeCap - $ext',
                price: priceFor(key),
              ));
            }
          }
        });
        return result;
      }(),
      digitalProductExtensions: () {
        final ext = json['digital_product_extensions'];
        if (ext == null || ext is List) return null;
        return (ext as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as List<dynamic>).cast<String>()),
        );
      }(),
      minimumOrderQty: json['minimum_order_qty'],
      colorAxisKey: json['color_axis_key']?.toString(),
      priceTiers: (json['price_tiers'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => WholesaleAiShoppingPriceTierModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
}
