import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/repositories/wholesale_product_details_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleProductDetailsRepository implements WholesaleProductDetailsRepositoryInterface {
  final DioClient? dioClient;
  WholesaleProductDetailsRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getProductDetails(String slug) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleProductDetailsUri}$slug');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getPriceQuote(int productId, {required int quantity, Map<String, String> variation = const {}}) async {
    try {
      final response = await dioClient!.post(
        '${AppConstants.wholesalePriceQuoteUri}$productId/price-quote',
        data: {'quantity': quantity, 'variation': variation},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getProductReviews(String slug, {int offset = 1, int limit = 10}) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.wholesaleProductDetailsUri}$slug/reviews',
        queryParameters: {'limit': limit, 'offset': offset},
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
