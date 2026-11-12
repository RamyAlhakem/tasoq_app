import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class CouponRepository implements CouponRepositoryInterface{
  final DioClient? dioClient;
  CouponRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> get(dynamic coupon) async {
    try {
      final response = await dioClient!.get(AppConstants.couponUri, queryParameters: {'code': coupon});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getList({int? offset, int limit = 25}) async {
    try {
      final response = await dioClient!.get('${AppConstants.couponListApi}?limit=$limit&offset=${offset ?? 1}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getAvailableCouponList() async {
    try {
      final response = await dioClient!.get(AppConstants.availableCoupon);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getSellerCouponList(String slug, int offset, {int limit = 25}) async {
    try {
      final response = await dioClient!.get('${AppConstants.sellerWiseCouponListApi}$slug/coupons?limit=$limit&offset=$offset');
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
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

}