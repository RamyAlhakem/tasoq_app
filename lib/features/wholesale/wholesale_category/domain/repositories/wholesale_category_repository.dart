import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/domain/repositories/wholesale_category_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleCategoryRepository implements WholesaleCategoryRepositoryInterface {
  final DioClient? dioClient;
  WholesaleCategoryRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getCategoryList({int offset = 1, int limit = 25}) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleCategoryUri}?limit=$limit&offset=$offset');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getSubCategoryList({required int categoryId, int offset = 1, int limit = 25}) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleSubCategoryUri}$categoryId?limit=$limit&offset=$offset');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getSubSubCategoryList({required int subCategoryId, int offset = 1, int limit = 25}) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleSubSubCategoryUri}$subCategoryId?limit=$limit&offset=$offset');
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
