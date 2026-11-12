import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/repositories/wholesale_offer_products_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/wholesale_offer_type.dart';

class WholesaleOfferProductsRepository implements WholesaleOfferProductsRepositoryInterface {
  final DioClient? dioClient;
  WholesaleOfferProductsRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getOfferProductList({
    required WholesaleOfferType type,
    required int page,
    int limit = 10,
    Map<String, dynamic> filterParams = const {},
  }) async {
    try {
      final response = await dioClient!.get(type.uri, queryParameters: {
        'limit': limit,
        'page': page,
        ...filterParams,
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
