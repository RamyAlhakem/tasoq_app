import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/domain/repositories/wholesale_checkout_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/domain/services/wholesale_checkout_service_interface.dart';

class WholesaleCheckoutService implements WholesaleCheckoutServiceInterface {
  final WholesaleCheckoutRepositoryInterface wholesaleCheckoutRepositoryInterface;
  WholesaleCheckoutService({required this.wholesaleCheckoutRepositoryInterface});

  @override
  Future placeCashOnDelivery({
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
    double? bringChangeAmount,
  }) async {
    return await wholesaleCheckoutRepositoryInterface.placeCashOnDelivery(
      addressId: addressId,
      billingAddressId: billingAddressId,
      couponCode: couponCode,
      orderNote: orderNote,
      currentCurrencyCode: currentCurrencyCode,
      bringChangeAmount: bringChangeAmount,
    );
  }

  @override
  Future placeOfflinePayment({
    required int methodId,
    String? paymentNote,
    Map<String, String>? methodInformations,
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  }) async {
    return await wholesaleCheckoutRepositoryInterface.placeOfflinePayment(
      methodId: methodId,
      paymentNote: paymentNote,
      methodInformations: methodInformations,
      addressId: addressId,
      billingAddressId: billingAddressId,
      couponCode: couponCode,
      orderNote: orderNote,
      currentCurrencyCode: currentCurrencyCode,
    );
  }

  @override
  Future placeWalletPayment({
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  }) async {
    return await wholesaleCheckoutRepositoryInterface.placeWalletPayment(
      addressId: addressId,
      billingAddressId: billingAddressId,
      couponCode: couponCode,
      orderNote: orderNote,
      currentCurrencyCode: currentCurrencyCode,
    );
  }

  @override
  Future createDigitalPaymentLink({
    required String paymentMethod,
    String? paymentPlatform,
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  }) async {
    return await wholesaleCheckoutRepositoryInterface.createDigitalPaymentLink(
      paymentMethod: paymentMethod,
      paymentPlatform: paymentPlatform,
      addressId: addressId,
      billingAddressId: billingAddressId,
      couponCode: couponCode,
      orderNote: orderNote,
      currentCurrencyCode: currentCurrencyCode,
    );
  }

  @override
  Future getDigitalPaymentOrder(String transactionRef) async {
    return await wholesaleCheckoutRepositoryInterface.getDigitalPaymentOrder(transactionRef);
  }
}
