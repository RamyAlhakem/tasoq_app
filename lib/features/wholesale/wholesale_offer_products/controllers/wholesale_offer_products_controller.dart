import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/controllers/wholesale_product_listing_mixin.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/domain/models/wholesale_product_filter_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/services/wholesale_offer_products_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/wholesale_offer_type.dart';

class WholesaleOfferProductsController extends ChangeNotifier with WholesaleProductListingMixin {
  final WholesaleOfferProductsServiceInterface wholesaleOfferProductsServiceInterface;

  WholesaleOfferProductsController({required this.wholesaleOfferProductsServiceInterface});

  WholesaleOfferType _type = WholesaleOfferType.discounted;
  WholesaleOfferType get type => _type;

  void setOfferType(WholesaleOfferType type) {
    _type = type;
    resetList();
    setFilter(const WholesaleProductFilterModel());
  }

  @override
  Future<ApiResponseModel> fetchProductPage({
    required int page,
    required int limit,
    required Map<String, dynamic> filterParams,
  }) async {
    return await wholesaleOfferProductsServiceInterface.getOfferProductList(
      type: _type, page: page, limit: limit, filterParams: filterParams,
    );
  }
}
