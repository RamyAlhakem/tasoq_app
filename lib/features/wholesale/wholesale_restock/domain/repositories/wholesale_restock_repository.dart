import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/domain/repositories/wholesale_restock_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleRestockRepository implements WholesaleRestockRepositoryInterface {
  final DioClient? dioClient;
  WholesaleRestockRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getRestockRequestList({int? offset = 1}) async {
    try {
      final response = await dioClient!.get(
        AppConstants.wholesaleRestockRequestUri,
        queryParameters: {'limit': 10, 'offset': offset ?? 1},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> deleteRestockRequest({int? id, bool all = false}) async {
    try {
      final response = await dioClient!.delete(
        AppConstants.wholesaleRestockRequestUri,
        queryParameters: all ? {'type': 'all'} : {'id': id},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future get(String id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }

  @override
  Future add(int value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    throw UnimplementedError();
  }
}
