import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/repositories/wholesale_product_details_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/services/wholesale_product_details_service_interface.dart';

class WholesaleProductDetailsService implements WholesaleProductDetailsServiceInterface {
  final WholesaleProductDetailsRepositoryInterface wholesaleProductDetailsRepositoryInterface;
  WholesaleProductDetailsService({required this.wholesaleProductDetailsRepositoryInterface});

  @override
  Future getProductDetails(String slug) async {
    return await wholesaleProductDetailsRepositoryInterface.getProductDetails(slug);
  }

  @override
  Future getPriceQuote(int productId, {required int quantity, Map<String, String> variation = const {}}) async {
    return await wholesaleProductDetailsRepositoryInterface.getPriceQuote(productId, quantity: quantity, variation: variation);
  }

  @override
  Future getProductReviews(String slug, {int offset = 1, int limit = 10}) async {
    return await wholesaleProductDetailsRepositoryInterface.getProductReviews(slug, offset: offset, limit: limit);
  }
}
