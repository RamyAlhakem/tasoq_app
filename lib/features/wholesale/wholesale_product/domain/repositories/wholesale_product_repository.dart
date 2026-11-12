import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/domain/repositories/wholesale_product_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleProductRepository implements WholesaleProductRepositoryInterface {
  final DioClient? dioClient;
  WholesaleProductRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getCategoryProductList({int? categoryId, int offset = 1, int limit = 10}) async {
    try {
      final String categoryFilter = categoryId != null ? '&category_id=$categoryId' : '';
      final response = await dioClient!.get('${AppConstants.wholesaleCategoryProductUri}?limit=$limit&page=$offset$categoryFilter');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getProductList({
    required int page,
    int limit = 10,
    String name = '',
    Map<String, dynamic> filterParams = const {},
  }) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCategoryProductUri, queryParameters: {
        'limit': limit,
        'page': page,
        if (name.trim().isNotEmpty) 'name': name.trim(),
        ...filterParams,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getSellerProductList(String slug, {int offset = 1, int limit = 10}) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleSellerProductUri}$slug/seller-products?limit=$limit&offset=$offset');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getSimilarProductList(String slug, {int offset = 1, int limit = 10}) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleSimilarProductUri}$slug/similar?limit=$limit&offset=$offset');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getRecentlyViewedProductList({int offset = 1, String search = ''}) async {
    try {
      final response = await dioClient!.get(
        AppConstants.wholesaleRecentlyViewedProductUri,
        queryParameters: {'page': offset, if (search.isNotEmpty) 'search': search},
      );
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
