
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/feature_disabled_handler.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:provider/provider.dart';

class ApiErrorHandler {

  static Response? getResponse(dynamic error) => error is DioException ? error.response : null;

  static dynamic getMessage(dynamic error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {

                case 403:
                  errorDescription = ApiEnvelope.errorMessage(error.response?.data) ?? '';

                  if (FeatureDisabledHandler.isFeatureDisabled(error.response?.data)) {
                    FeatureDisabledHandler.handle(errorDescription);
                  }

                  if (kDebugMode) {
                    print("=================403=============>>$errorDescription");
                    print("=================403=============>>${error.response!.data}");
                  }

                  break;
                case 401:
                  Provider.of<AuthController>(Get.context!,listen: false).clearSharedData();
                  errorDescription = ApiEnvelope.errorMessage(error.response?.data) ?? '';
                  break;
                case 404:
                  errorDescription = ApiEnvelope.errorMessage(error.response?.data) ?? '';
                  break;
                case 400:
                case 422:
                  errorDescription = ApiEnvelope.errorMessage(error.response?.data) ?? '';
                  break;
                case 503:
                  errorDescription = ApiEnvelope.errorMessage(error.response?.data) ?? error.response!.statusMessage ?? '';
                  break;
                case 500:
                  if (kDebugMode) {
                    print("-----------500------------->>${error.response!.data}");
                  }
                  errorDescription = 'Internal server error';
                  break;
                case 429:
                  print("-----------429------------->>${error.response!.data}");
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  errorDescription = ApiEnvelope.errorMessage(error.response?.data) ?? "Failed to load data - status code: ${error.response!.statusCode}";
              }
              break;
            case DioExceptionType.badCertificate:
              // TODO: Handle this case.
              break;
            case DioExceptionType.connectionError:
              // TODO: Handle this case.
              break;
            case DioExceptionType.unknown:
              errorDescription = "Request to API call limit excited ";
              break;
            case DioExceptionType.transformTimeout:
              // TODO: Handle this case.
              errorDescription = "Connection timeout with API server";
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
