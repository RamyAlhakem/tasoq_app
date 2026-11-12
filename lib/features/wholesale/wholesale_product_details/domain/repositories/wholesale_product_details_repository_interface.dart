import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleProductDetailsRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getProductDetails(String slug);
  Future<dynamic> getPriceQuote(int productId, {required int quantity, Map<String, String> variation = const {}});
  Future<dynamic> getProductReviews(String slug, {int offset = 1, int limit = 10});
}
