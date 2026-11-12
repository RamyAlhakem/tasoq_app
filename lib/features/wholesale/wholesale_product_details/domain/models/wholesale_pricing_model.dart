import 'package:flutter/material.dart';

enum WholesalePricingType { none, quantityWise, variationWise, quantityVariationWise }

class WholesaleQuantityTier {
  final int minQty;
  final int? maxQty;

  const WholesaleQuantityTier({required this.minQty, this.maxQty});

  bool contains(int qty) => qty >= minQty && (maxQty == null || qty <= maxQty!);
}

class WholesaleVariationOptionValue {
  final String value;
  final Color? swatch;
  final bool hasDiscount;

  const WholesaleVariationOptionValue({required this.value, this.swatch, this.hasDiscount = false});
}

class WholesaleVariationAttribute {
  final String name;
  final List<WholesaleVariationOptionValue> options;

  const WholesaleVariationAttribute({required this.name, required this.options});
}

class WholesaleVariationCombinationPrice {
  final String key;
  final double? price;
  final double? originalPrice;
  final List<double>? tierPrices;
  final List<double?>? tierOriginalPrices;
  final List<String>? imageUrls;

  const WholesaleVariationCombinationPrice({
    required this.key,
    this.price,
    this.originalPrice,
    this.tierPrices,
    this.tierOriginalPrices,
    this.imageUrls,
  });
}

class WholesaleCombinationDiscountOffer {
  final String label;

  final int? minQty;

  const WholesaleCombinationDiscountOffer({required this.label, this.minQty});
}

class WholesaleProductPricing {
  final WholesalePricingType type;
  final int minimumOrderQuantity;
  final List<WholesaleQuantityTier> tiers;
  final List<double>? quantityTierPrices;
  final List<WholesaleVariationAttribute> attributes;
  final Map<String, WholesaleVariationCombinationPrice> combinations;
  final String? combinationDiscountUnitLabel;
  final List<WholesaleCombinationDiscountOffer> combinationDiscountOffers;

  const WholesaleProductPricing({
    required this.type,
    required this.minimumOrderQuantity,
    this.tiers = const [],
    this.quantityTierPrices,
    this.attributes = const [],
    this.combinations = const {},
    this.combinationDiscountUnitLabel,
    this.combinationDiscountOffers = const [],
  });
}
