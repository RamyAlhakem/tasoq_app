import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/services/data_sync_service.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/repositories/wholesale_home_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleHomeRepository extends DataSyncService implements WholesaleHomeRepositoryInterface {
  final DioClient? dioClient;

  WholesaleHomeRepository({required this.dioClient, required super.dataSyncRepoInterface});

  @override
  Future<ApiResponseModel<T>> getHomeCategoryList<T>({required DataSourceEnum source}) async {
    return await fetchData<T>(_uri(AppConstants.wholesaleCategoryUri, {'with_children': 1}), source);
  }

  @override
  Future<ApiResponseModel<T>> getProductRail<T>({required WholesaleProductRailEnum rail, required DataSourceEnum source, int limit = 10, int? categoryId}) async {
    return await fetchData<T>(_uri(AppConstants.wholesaleCategoryProductUri, {
      'sort_by': rail.sortBy, 'limit': limit, 'page': 1,
      if (categoryId != null) 'category_id': categoryId,
    }), source);
  }

  @override
  Future<ApiResponseModel<T>> getSellerRail<T>({required WholesaleSellerRailEnum rail, required DataSourceEnum source, int limit = 10, int? categoryId}) async {
    return await fetchData<T>(_uri(AppConstants.wholesaleShopListUri, {
      'type': rail.type, 'limit': limit, 'offset': 1,
      if (categoryId != null) 'category_id': categoryId,
    }), source);
  }

  @override
  Future<ApiResponseModel> getRecentOrderList({int limit = 10}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleCustomerOrderUri, queryParameters: {
        'limit': limit,
        'offset': 1,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getRecommendedSellerList({int limit = 10}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleShopListUri, queryParameters: {
        'type': WholesaleSellerRailEnum.recommended.type,
        'limit': limit,
        'offset': 1,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getRecentlyViewedShopList({String search = ''}) async {
    try {
      final response = await dioClient!.get(
        AppConstants.wholesaleRecentlyViewedShopUri,
        queryParameters: search.isEmpty ? null : {'search': search},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  String _uri(String path, Map<String, dynamic> queryParams) {
    return Uri(path: path, queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString()))).toString();
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
