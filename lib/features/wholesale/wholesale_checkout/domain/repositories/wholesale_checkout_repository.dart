import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/domain/repositories/wholesale_checkout_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleCheckoutRepository implements WholesaleCheckoutRepositoryInterface {
  final DioClient? dioClient;
  WholesaleCheckoutRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> placeCashOnDelivery({
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
    double? bringChangeAmount,
  }) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleOrderCashOnDeliveryUri,
        data: {
          'payment_method': 'cash_on_delivery',
          if (bringChangeAmount != null) 'bring_change_amount': bringChangeAmount,
          ..._commonFields(addressId, billingAddressId, couponCode, orderNote, currentCurrencyCode),
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> placeOfflinePayment({
    required int methodId,
    String? paymentNote,
    Map<String, String>? methodInformations,
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  }) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleOrderOfflinePaymentUri,
        data: {
          'method_id': methodId,
          if (paymentNote != null && paymentNote.isNotEmpty) 'payment_note': paymentNote,
          if (methodInformations != null && methodInformations.isNotEmpty) 'method_informations': methodInformations,
          ..._commonFields(addressId, billingAddressId, couponCode, orderNote, currentCurrencyCode),
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> placeWalletPayment({
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  }) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleOrderWalletUri,
        data: {
          'payment_method': 'wallet',
          ..._commonFields(addressId, billingAddressId, couponCode, orderNote, currentCurrencyCode),
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> createDigitalPaymentLink({
    required String paymentMethod,
    String? paymentPlatform,
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  }) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleOrderDigitalPaymentUri,
        data: {
          'payment_method': paymentMethod,
          if (paymentPlatform != null) 'payment_platform': paymentPlatform,
          ..._commonFields(addressId, billingAddressId, couponCode, orderNote, currentCurrencyCode),
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getDigitalPaymentOrder(String transactionRef) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleOrderDigitalPaymentByRefUri}${Uri.encodeComponent(transactionRef)}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  Map<String, dynamic> _commonFields(
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  ) =>
      {
        if (addressId != null && addressId.isNotEmpty) 'address_id': int.tryParse(addressId) ?? addressId,
        if (billingAddressId != null && billingAddressId.isNotEmpty) 'billing_address_id': int.tryParse(billingAddressId) ?? billingAddressId,
        if (couponCode != null && couponCode.isNotEmpty) 'coupon_code': couponCode,
        if (orderNote != null && orderNote.isNotEmpty) 'order_note': orderNote,
        if (currentCurrencyCode != null && currentCurrencyCode.isNotEmpty) 'current_currency_code': currentCurrencyCode,
      };

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }
}
