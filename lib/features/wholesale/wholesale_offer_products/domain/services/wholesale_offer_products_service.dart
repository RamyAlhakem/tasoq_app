import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/repositories/wholesale_offer_products_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/services/wholesale_offer_products_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/wholesale_offer_type.dart';

class WholesaleOfferProductsService implements WholesaleOfferProductsServiceInterface {
  final WholesaleOfferProductsRepositoryInterface wholesaleOfferProductsRepositoryInterface;

  WholesaleOfferProductsService({required this.wholesaleOfferProductsRepositoryInterface});

  @override
  Future getOfferProductList({
    required WholesaleOfferType type,
    required int page,
    int limit = 10,
    Map<String, dynamic> filterParams = const {},
  }) {
    return wholesaleOfferProductsRepositoryInterface.getOfferProductList(
      type: type, page: page, limit: limit, filterParams: filterParams,
    );
  }
}
