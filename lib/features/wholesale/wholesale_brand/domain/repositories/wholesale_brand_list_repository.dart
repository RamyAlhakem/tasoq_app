import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/repositories/wholesale_brand_list_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleBrandListRepository implements WholesaleBrandListRepositoryInterface {
  final DioClient? dioClient;
  WholesaleBrandListRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getBrandList({int offset = 1, int limit = 25}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleBrandUri, queryParameters: {
        'limit': limit,
        'offset': offset,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getBrandProductList({
    required int brandId,
    required int page,
    int limit = 10,
    Map<String, dynamic> filterParams = const {},
  }) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCategoryProductUri, queryParameters: {
        ...filterParams,
        'brand_id': brandId,
        'limit': limit,
        'page': page,
      });
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
