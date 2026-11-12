import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/domain/repositories/wholesale_shop_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleShopRepository implements WholesaleShopRepositoryInterface {
  final DioClient? dioClient;

  WholesaleShopRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getShopDetails(String slug) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleShopDetailsUri}$slug');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getShopProductList({
    required int shopId,
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
        'shop_id': shopId,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getShopCouponList(String slug, {int limit = 10}) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleShopCouponUri}$slug/coupons', queryParameters: {
        'limit': limit,
        'offset': 1,
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
