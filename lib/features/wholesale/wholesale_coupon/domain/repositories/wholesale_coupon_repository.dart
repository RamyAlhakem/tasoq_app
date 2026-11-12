import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/domain/repositories/wholesale_coupon_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleCouponRepository implements WholesaleCouponRepositoryInterface {
  final DioClient? dioClient;
  WholesaleCouponRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getCouponList({int offset = 1, int limit = 25, String? search, String? sortBy}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCouponUri, queryParameters: {
        'limit': limit,
        'offset': offset,
        if (search != null && search.isNotEmpty) 'search': search,
        if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getShopCouponList(String slug, {int offset = 1, int limit = 25, String? search, String? sortBy}) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleShopCouponUri}$slug/coupons', queryParameters: {
        'limit': limit,
        'offset': offset,
        if (search != null && search.isNotEmpty) 'search': search,
        if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getApplicableCoupons() async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleApplicableCouponUri);
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
