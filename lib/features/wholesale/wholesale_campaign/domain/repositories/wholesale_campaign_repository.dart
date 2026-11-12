import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/domain/repositories/wholesale_campaign_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleCampaignRepository implements WholesaleCampaignRepositoryInterface {
  final DioClient? dioClient;
  WholesaleCampaignRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getCampaignList({int offset = 1, int limit = 25}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCampaignUri, queryParameters: {
        'limit': limit,
        'offset': offset,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getCampaignDetails(String slug) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleCampaignDetailsUri}${Uri.encodeComponent(slug)}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getCampaignProducts(String slug, {int offset = 1, int limit = 10}) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.wholesaleCampaignDetailsUri}${Uri.encodeComponent(slug)}/products',
        queryParameters: {'limit': limit, 'offset': offset},
      );
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
