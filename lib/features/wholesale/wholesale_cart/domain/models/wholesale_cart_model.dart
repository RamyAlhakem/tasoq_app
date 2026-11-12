import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_pricing_model.dart';

class WholesaleCartItemModel {
  final int id;
  final int productId;
  final String name;
  final String thumbnail;
  final WholesalePricingType pricingType;
  final String? variantKey;
  final List<String> attributeSummary;
  final int quantity;
  final int minimumOrderQuantity;
  final double unitPrice;
  final double? originalUnitPrice;
  final String? tierLabel;

  const WholesaleCartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.thumbnail,
    required this.pricingType,
    this.variantKey,
    this.attributeSummary = const [],
    required this.quantity,
    required this.minimumOrderQuantity,
    required this.unitPrice,
    this.originalUnitPrice,
    this.tierLabel,
  });

  WholesaleCartItemModel copyWith({int? quantity}) {
    return WholesaleCartItemModel(
      id: id,
      productId: productId,
      name: name,
      thumbnail: thumbnail,
      pricingType: pricingType,
      variantKey: variantKey,
      attributeSummary: attributeSummary,
      quantity: quantity ?? this.quantity,
      minimumOrderQuantity: minimumOrderQuantity,
      unitPrice: unitPrice,
      originalUnitPrice: originalUnitPrice,
      tierLabel: tierLabel,
    );
  }
}
