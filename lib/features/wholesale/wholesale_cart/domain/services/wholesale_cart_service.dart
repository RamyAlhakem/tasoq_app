import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/repositories/wholesale_cart_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/services/wholesale_cart_service_interface.dart';

class WholesaleCartService implements WholesaleCartServiceInterface {
  final WholesaleCartRepositoryInterface wholesaleCartRepositoryInterface;
  WholesaleCartService({required this.wholesaleCartRepositoryInterface});

  @override
  Future addItem({
    required int productId,
    required int quantity,
    Map<String, String> variation = const {},
    bool buyNow = false,
    int? shippingMethodId,
    int? guestId,
  }) async {
    return await wholesaleCartRepositoryInterface.addItem(
      productId: productId,
      quantity: quantity,
      variation: variation,
      buyNow: buyNow,
      shippingMethodId: shippingMethodId,
      guestId: guestId,
    );
  }

  @override
  Future getCart({int? guestId, String? couponCode}) async {
    return await wholesaleCartRepositoryInterface.getCart(guestId: guestId, couponCode: couponCode);
  }

  @override
  Future updateSelection({int? cartId, String? cartGroupId, required bool isChecked, int? guestId, String? couponCode}) async {
    return await wholesaleCartRepositoryInterface.updateSelection(
      cartId: cartId,
      cartGroupId: cartGroupId,
      isChecked: isChecked,
      guestId: guestId,
      couponCode: couponCode,
    );
  }

  @override
  Future removeItem({required int cartId, int? guestId, String? couponCode}) async {
    return await wholesaleCartRepositoryInterface.removeItem(cartId: cartId, guestId: guestId, couponCode: couponCode);
  }

  @override
  Future updateItemQuantity({required int cartId, required int quantity, int? guestId, String? couponCode}) async {
    return await wholesaleCartRepositoryInterface.updateItemQuantity(cartId: cartId, quantity: quantity, guestId: guestId, couponCode: couponCode);
  }

  @override
  Future setShippingMethod({required String cartGroupId, required int shippingMethodId, int? guestId, String? couponCode}) async {
    return await wholesaleCartRepositoryInterface.setShippingMethod(
      cartGroupId: cartGroupId,
      shippingMethodId: shippingMethodId,
      guestId: guestId,
      couponCode: couponCode,
    );
  }

  @override
  Future applyCoupon({required String code, int? guestId}) async {
    return await wholesaleCartRepositoryInterface.applyCoupon(code: code, guestId: guestId);
  }

  @override
  Future removeCoupon({int? guestId}) async {
    return await wholesaleCartRepositoryInterface.removeCoupon(guestId: guestId);
  }

  @override
  Future requestRestock({required int productId, Map<String, String> variation = const {}}) async {
    return await wholesaleCartRepositoryInterface.requestRestock(productId: productId, variation: variation);
  }

  @override
  Future deleteRestockRequest({int? id, bool all = false}) async {
    return await wholesaleCartRepositoryInterface.deleteRestockRequest(id: id, all: all);
  }
}
