abstract class WholesaleProductDetailsServiceInterface {
  Future<dynamic> getProductDetails(String slug);
  Future<dynamic> getPriceQuote(int productId, {required int quantity, Map<String, String> variation = const {}});
  Future<dynamic> getProductReviews(String slug, {int offset = 1, int limit = 10});
}
