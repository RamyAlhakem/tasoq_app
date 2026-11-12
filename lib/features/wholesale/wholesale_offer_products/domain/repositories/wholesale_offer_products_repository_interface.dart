import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/wholesale_offer_type.dart';
import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleOfferProductsRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getOfferProductList({
    required WholesaleOfferType type,
    required int page,
    int limit = 10,
    Map<String, dynamic> filterParams = const {},
  });
}
