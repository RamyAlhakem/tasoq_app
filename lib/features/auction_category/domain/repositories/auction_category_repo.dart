import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/services/data_sync_service.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_category/domain/repositories/auction_category_repo_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class AuctionCategoryRepository extends DataSyncService implements AuctionCategoryRepoInterface {
  final DioClient? dioClient;
  AuctionCategoryRepository({required this.dioClient, required super.dataSyncRepoInterface});

  @override
  Future<ApiResponseModel> getList({int? offset}) async {
    try {
      final response = await dioClient!.get(AppConstants.auctionCategoriesUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel<T>> getCategoryProductList<T>({
    required int categoryId,
    required int offset,
    required DataSourceEnum source,
    String searchProduct = '',
  }) async {
    final Map<String, String> queryParams = {
      'limit': '10',
      'offset': '$offset',
      'category_ids[]': '$categoryId',
      if (searchProduct.isNotEmpty) 'search': searchProduct,
    };

    final String url = Uri(path: AppConstants.auctionCategoryProductListUri, queryParameters: queryParams).toString();
    return await fetchData<T>(url, source);
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
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponseModel<T>> getAuctionCategoryList<T>({required DataSourceEnum source}) async {
    return await fetchData<T>(AppConstants.auctionCategoriesUri, source);
  }
}
