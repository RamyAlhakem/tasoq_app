import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/domain/repositories/wholesale_search_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WholesaleSearchRepository implements WholesaleSearchRepositoryInterface {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  WholesaleSearchRepository({required this.dioClient, required this.sharedPreferences});

  @override
  Future<ApiResponseModel> getSearchProductList({
    String name = '',
    required int page,
    int limit = 10,
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
  Future<ApiResponseModel> getSuggestionProductName(String name, {int limit = 10}) async {
    if (name.trim().isEmpty) {
      return ApiResponseModel.withError('');
    }

    try {
      final response = await dioClient!.get(AppConstants.wholesaleProductSuggestionUri, queryParameters: {
        'name': name.trim(),
        'limit': limit,
        'offset': 1,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getPopularTags({int limit = 10}) async {
    try {
      final response = await dioClient!.get(AppConstants.wholesaleTagsUri, queryParameters: {'limit': limit});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<void> saveSearchName(String name) async {
    final List<String> names = getSavedSearchNames();
    names.removeWhere((saved) => saved.toLowerCase() == name.toLowerCase());
    names.insert(0, name);
    await setSavedSearchNames(names);
  }

  @override
  List<String> getSavedSearchNames() {
    return sharedPreferences!.getStringList(AppConstants.wholesaleSearchProductName) ?? [];
  }

  @override
  Future<bool> setSavedSearchNames(List<String> names) async {
    return sharedPreferences!.setStringList(AppConstants.wholesaleSearchProductName, names);
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
