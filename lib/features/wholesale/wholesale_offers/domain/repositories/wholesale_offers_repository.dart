import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/domain/repositories/wholesale_offers_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleOffersRepository implements WholesaleOffersRepositoryInterface {
  final DioClient? dioClient;
  WholesaleOffersRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getDiscountedProducts({required int offset, int limit = 10}) {
    return _getProducts(AppConstants.wholesaleDiscountedProductsUri, offset: offset, limit: limit);
  }

  @override
  Future<ApiResponseModel> getPriceDropProducts({required int offset, int limit = 10}) {
    return _getProducts(AppConstants.wholesalePriceDropProductsUri, offset: offset, limit: limit);
  }

  @override
  Future<ApiResponseModel> getReducedMoqProducts({required int offset, int limit = 10}) {
    return _getProducts(AppConstants.wholesaleReducedMoqProductsUri, offset: offset, limit: limit);
  }

  Future<ApiResponseModel> _getProducts(String uri, {required int offset, required int limit}) async {
    try {
      final response = await dioClient!.get(uri, queryParameters: {'limit': limit, 'offset': offset});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getTopDiscountedManufacturers({required int offset, int limit = 10, String search = ''}) {
    return getManufacturers(type: 'top-discounted', offset: offset, limit: limit, search: search);
  }

  @override
  Future<ApiResponseModel> getManufacturers({
    required String type,
    required int offset,
    int limit = 10,
    String search = '',
    int? categoryId,
    int? subCategoryId,
    int? subSubCategoryId,
    String? sortBy,
  }) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleShopListUri, queryParameters: {
        'type': type,
        'limit': limit,
        'offset': offset,
        if (search.trim().isNotEmpty) 'search': search.trim(),
        if (sortBy != null) 'sort_by': sortBy,
        if (subSubCategoryId != null) 'sub_sub_category_id': subSubCategoryId
        else if (subCategoryId != null) 'sub_category_id': subCategoryId
        else if (categoryId != null) 'category_id': categoryId,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
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
