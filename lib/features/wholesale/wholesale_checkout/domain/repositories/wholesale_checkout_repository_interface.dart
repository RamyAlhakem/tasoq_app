import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleCheckoutRepositoryInterface extends RepositoryInterface {
  Future<dynamic> placeCashOnDelivery({
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
    double? bringChangeAmount,
  });

  Future<dynamic> placeOfflinePayment({
    required int methodId,
    String? paymentNote,
    Map<String, String>? methodInformations,
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  });

  Future<dynamic> placeWalletPayment({
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  });

  Future<dynamic> createDigitalPaymentLink({
    required String paymentMethod,
    String? paymentPlatform,
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  });

  Future<dynamic> getDigitalPaymentOrder(String transactionRef);
}
