import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/services/data_sync_service.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/repositories/category_repo_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class CategoryRepository extends DataSyncService implements CategoryRepoInterface {
  final DioClient? dioClient;
  CategoryRepository({required this.dioClient, required super.dataSyncRepoInterface});

  @override
  Future<ApiResponseModel> getList({int? offset}) async {
    try {
      final response = await dioClient!.get(
        AppConstants.categoriesUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getSellerWiseCategoryList(String slug) async {
    try {
      final response = await dioClient!.get(AppConstants.sellerWiseCategoryList, queryParameters: {'shop_slug': slug, 'limit': 100, 'offset': 1});
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
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }



  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<ApiResponseModel<T>> getCategoryList<T>({required DataSourceEnum source, int offset = 1, int limit = 25}) async {
    return await fetchData<T>('${AppConstants.categoriesUri}?guest_id=1&limit=$limit&offset=$offset',  source);
  }

  @override
  Future<ApiResponseModel> getSubCategoryList({required int categoryId, required int offset, int limit = 25}) async {
    try {
      final response = await dioClient!.get('${AppConstants.subCategoriesUri}$categoryId?limit=$limit&offset=$offset');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getSubSubCategoryList({required int subCategoryId, required int offset, int limit = 25}) async {
    try {
      final response = await dioClient!.get('${AppConstants.subSubCategoriesUri}$subCategoryId?limit=$limit&offset=$offset');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}