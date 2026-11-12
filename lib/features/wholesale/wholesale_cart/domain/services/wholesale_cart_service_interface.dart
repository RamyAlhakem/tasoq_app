abstract class WholesaleCartServiceInterface {
  Future<dynamic> addItem({
    required int productId,
    required int quantity,
    Map<String, String> variation = const {},
    bool buyNow = false,
    int? shippingMethodId,
    int? guestId,
  });

  Future<dynamic> getCart({int? guestId, String? couponCode});

  Future<dynamic> updateSelection({int? cartId, String? cartGroupId, required bool isChecked, int? guestId, String? couponCode});

  Future<dynamic> removeItem({required int cartId, int? guestId, String? couponCode});

  Future<dynamic> updateItemQuantity({required int cartId, required int quantity, int? guestId, String? couponCode});

  Future<dynamic> setShippingMethod({required String cartGroupId, required int shippingMethodId, int? guestId, String? couponCode});

  Future<dynamic> applyCoupon({required String code, int? guestId});

  Future<dynamic> removeCoupon({int? guestId});

  Future<dynamic> requestRestock({required int productId, Map<String, String> variation = const {}});

  Future<dynamic> deleteRestockRequest({int? id, bool all = false});
}
