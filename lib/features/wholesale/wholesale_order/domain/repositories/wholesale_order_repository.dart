import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/repositories/wholesale_order_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleOrderRepository implements WholesaleOrderRepositoryInterface {
  final DioClient? dioClient;
  WholesaleOrderRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getOrderList({int offset = 1, int limit = 25, required String status, String? type}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCustomerOrderUri, queryParameters: {
        'status': status,
        'limit': limit,
        'offset': offset,
        if (type != null && type.isNotEmpty) 'type': type,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getOrderDetails(int orderId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleOrderDetailsUri}$orderId');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getOrderItems(int orderId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleOrderDetailsUri}$orderId/items');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getOrderStatusHistory(int orderId, {String? phoneNumber}) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.wholesaleOrderStatusHistoryUri}$orderId/status-history',
        queryParameters: {
          if (phoneNumber != null && phoneNumber.isNotEmpty) 'phone_number': phoneNumber,
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> trackOrder({required int orderId, String? phoneNumber}) async {
    try {
      final response = await dioClient!.post(AppConstants.wholesaleOrderTrackUri, data: {
        'order_id': orderId,
        if (phoneNumber != null && phoneNumber.isNotEmpty) 'phone_number': phoneNumber,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getOrderTracking(int orderId, {String? phoneNumber}) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.wholesaleOrderTrackingUri}$orderId/tracking',
        queryParameters: {
          if (phoneNumber != null && phoneNumber.isNotEmpty) 'phone_number': phoneNumber,
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getOrderInvoice(int orderId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleOrderInvoiceUri}$orderId/invoice');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> cancelOrder(int orderId) async {
    try {
      final response = await dioClient!.put('${AppConstants.wholesaleOrderCancelUri}$orderId/cancel', data: {'id': orderId.toString()});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

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
