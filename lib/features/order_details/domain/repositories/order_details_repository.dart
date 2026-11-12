import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/repositories/order_details_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class OrderDetailsRepository implements OrderDetailsRepositoryInterface{
  final DioClient? dioClient;
  OrderDetailsRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> get(String orderID) async {
    try {
      // v6 exposes line items as their own sub-resource of the order.
      final response = await dioClient!.get('${AppConstants.orderDetailsUri}$orderID/items');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getOrderFromOrderId(String orderID) async {
    try {
      // v6 takes the order id as a path segment, not an `order_id` query param.
      final response = await dioClient!.get('${AppConstants.getOrderFromOrderId}$orderID?guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponseModel> downloadDigitalProduct(int orderDetailsId) async {
    try {
      // v6 takes the order-item id as a path segment; guest_id resolves ownership when logged out.
      final response = await dioClient!.get(
        '${AppConstants.downloadDigitalProduct}$orderDetailsId/download',
        queryParameters: {
          'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> resendOtpForDigitalProduct(int orderId) async {
    try {
      final response = await dioClient!.post(
        '${AppConstants.otpVResendForDigitalProduct}$orderId/download/otp',
        data: {
          'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> otpVerificationForDigitalProduct(int orderId, String otp) async {
    try {
      // v6 verify is a POST that streams the file back as raw bytes on success
      // (not JSON), so the request must ask for bytes explicitly.
      final response = await dioClient!.post(
        '${AppConstants.otpVerificationForDigitalProduct}$orderId/download/verify',
        data: {
          'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
          'otp': otp,
          'action': 'download',
        },
        options: Options(responseType: ResponseType.bytes),
      );
      return ApiResponseModel.withSuccess(response);
    } on DioException catch (e) {
      // Error bodies come back as bytes too (same forced responseType) — decode
      // them back to JSON so the shared error-message helpers still work.
      dynamic data = e.response?.data;
      if (data is List<int>) {
        try {
          data = jsonDecode(utf8.decode(data));
        } catch (_) {}
      }
      return ApiResponseModel.withError(ApiEnvelope.errorMessage(data) ?? ApiErrorHandler.getMessage(e));
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> trackYourOrder(String orderId, String phoneNumber) async {
    try {
      final response = await dioClient!.post(
        AppConstants.orderTrack,
        data: {
          'order_id': orderId,
          'phone_number' : phoneNumber
        }
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> reorder(String orderId) async {
    try {
      final response = await dioClient!.post('${AppConstants.reorder}$orderId/reorder');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getTrackOrderDetailsId(String orderID, String? phoneNumber) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.orderDetailsTrack}$orderID/status-history',
        queryParameters: {
          'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
          if (phoneNumber != null) 'phone_number': phoneNumber,
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }


  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future getOrderInvoice(String orderID) async{
    try {
      // v6 takes the order id as a path segment; guest_id resolves ownership when logged out.
      final response = await dioClient!.get(
        '${AppConstants.generateInvoice}$orderID/invoice',
        queryParameters: {
          'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }




  @override
  Future<HttpClientResponse> productDownload(String? url) async {
      HttpClient client = HttpClient();
    final response = await client.getUrl(Uri.parse(url!)).then((HttpClientRequest request) {
          return request.close();
        },
      );
    return response;
  }

  @override
  Future<ApiResponseModel> duePaymentByCod(int orderId, String? bringChangeAmount, String? currencyCode) async {
    try {
      final response = await dioClient!.post('${AppConstants.duePaymentByCodUri}$orderId/due-payments/cash-on-delivery',
          data: {
            'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
            'bring_change_amount': bringChangeAmount,
            'current_currency_code': currencyCode,
          });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> duePaymentByDigitalPayment(int orderId, String paymentMethod, String? orderDuePaymentNote, String? currencyCode) async {
    try {
      final response = await dioClient!.post('${AppConstants.duePaymentByDigitalPayment}$orderId/due-payments/digital-payment',
          data: {
            'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
            'payment_method': paymentMethod,
            'payment_platform': 'app',
            'payment_request_from': 'app',
            'current_currency_code': currencyCode,
            'order_due_payment_note': orderDuePaymentNote,
          });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponseModel> duePaymentByOfflinePayment(int orderId, int? methodId, List<String?> typeKey, List<String> typeValue, String? orderDueNote) async {
    try {
      final Map<String?, String> info = {};
      for (var i = 0; i < typeKey.length; i++) {
        info.addAll(<String?, String>{typeKey[i]: typeValue[i]});
      }
      final response = await dioClient!.post('${AppConstants.duePaymentByOfflinePayment}$orderId/due-payments/offline-payment',
          data: {
            'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
            'method_id': methodId,
            'method_informations': base64.encode(utf8.encode(jsonEncode(info))),
            'order_due_payment_note': orderDueNote,
          });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }




  @override
  Future<ApiResponseModel> duePaymentByWallet(int orderId) async {
    try {
      final response = await dioClient!.post('${AppConstants.duePaymentByWallet}$orderId/due-payments/wallet',
        data: {
          'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
        });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // @override
  // Future<ApiResponseModel> duePaymentByOfflinePayment(int orderId, String paymentMethod, String? orderDuePaymentNote, String? methodId) async {
  //   try {
  //     final response = await dioClient!.post(AppConstants.duePaymentByDigitalPayment,
  //       data: {
  //         'order_id': orderId,
  //         'payment_method': paymentMethod,
  //         'order_due_payment_note': orderDuePaymentNote,
  //         'method_id' : methodId,
  //       }
  //     );
  //     return ApiResponseModel.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }


  // duePaymentByOfflinePayment


}
