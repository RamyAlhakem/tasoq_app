
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/repositories/order_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'dart:async';

class OrderRepository implements OrderRepositoryInterface{
  final DioClient? dioClient;
  OrderRepository({required this.dioClient});


  @override
  Future<ApiResponseModel> getOrderList(int offset, String status, {String? type}) async {
    try {
      final response = await dioClient!.get('${AppConstants.orderUri}$offset&status=$status&type=$type');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponseModel> cancelOrder(int? orderId) async {
    try {
      // v6 takes the order id as a path segment and is a PUT, not a GET.
      final response = await dioClient!.put('${AppConstants.cancelOrderUri}$orderId/cancel');
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
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }




}
