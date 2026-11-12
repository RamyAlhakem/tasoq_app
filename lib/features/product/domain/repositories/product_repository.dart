import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/services/data_sync_service.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/repositories/product_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class ProductRepository extends DataSyncService implements ProductRepositoryInterface{
  final DioClient dioClient;
  ProductRepository({required this.dioClient, required super.dataSyncRepoInterface});

  @override
  Future<ApiResponseModel> getFilteredProductList(BuildContext context, String offset, ProductType productType) async {
    try {
      final response = await dioClient.get(_getApiEndUrlByType(productType) + offset);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel<T>> getProductModelByType<T>({
    required int offset,
    required ProductType productType,
    required DataSourceEnum source,
  }) async {

    final String endUrl = _getApiEndUrlByType(productType);

    return await fetchData<T>(endUrl + offset.toString(), source);
  }

  String _getApiEndUrlByType(ProductType type) {
    switch (type) {
      case ProductType.newArrival:
        return _pagedUrl(AppConstants.newArrivalProductUri);

      case ProductType.latestProduct:
        return _pagedUrl(AppConstants.latestProductUri);

      case ProductType.featuredProduct:
        return _pagedUrl(AppConstants.featuredProductUri);

      case ProductType.topProduct:
        return _pagedUrl(AppConstants.topProductUri);

      case ProductType.bestSelling:
        return _pagedUrl(AppConstants.bestSellingProductUri);

      case ProductType.discountedProduct:
        return _pagedUrl(AppConstants.discountedProductUri);

      case ProductType.justForYou:
        return _pagedUrl(AppConstants.justForYou);

      default:
        return _pagedUrl(AppConstants.newArrivalProductUri);

    }

  }

  static String _pagedUrl(String uri) => '$uri?limit=10&offset=';

  @override
  Future<ApiResponseModel> getBrandOrCategoryProductList({required bool isBrand, required int id, String searchProduct = '', required int offset, String? productType, String? brandIds, String? authorIds, String? publishingIds}) async {
    try {
      String uri;
      if(isBrand){
        // v6 nests the id before "products" (no guest_id — this is a public
        // endpoint, personalization is via bearer token only).
        uri = '${AppConstants.brandProductUri}$id/products?search=$searchProduct&limit=10&offset=$offset';
      }else {
        uri = '${AppConstants.categoryProductUri}$id/products?search=$searchProduct&limit=10&offset=$offset';
        if (productType != null && productType != 'all') uri += '&product_type=$productType';
        if (brandIds != null && brandIds != '[]') uri += '&brand_ids=$brandIds';
        if (authorIds != null && authorIds != '[]') uri += '&product_authors=$authorIds';
        if (publishingIds != null && publishingIds != '[]') uri += '&publishing_houses=$publishingIds';
      }
      final response = await dioClient.get(uri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponseModel> getRelatedProductList(String id) async {
    try {
      final response = await dioClient.get('${AppConstants.relatedProductUri}$id/related');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel<T>> getRecommendedProduct<T>({required DataSourceEnum source}) async {

   return await fetchData<T>(AppConstants.dealOfTheDay, source);

  }

  @override
  Future<ApiResponseModel<T>> getMostDemandedProduct<T>({required DataSourceEnum source}) async {
    return await fetchData<T>(AppConstants.mostDemandedProduct, source);
  }

  @override
  Future<ApiResponseModel<T>> getFindWhatYouNeed<T>({required DataSourceEnum source}) async {
    return await fetchData<T>(AppConstants.findWhatYouNeed, source);
  }


  @override
  Future<ApiResponseModel> getJustForYouProductList({required int offset, int? limit}) async {
    try {
      final response = await dioClient.get('${AppConstants.justForYou}?limit=${limit ?? 10}&offset=$offset');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel<T>> getMostSearchingProductList<T>({required int offset, required DataSourceEnum source}) async {
    // v6 has no guest_id param here — personalization is via bearer token only.
    return await fetchData<T>('${AppConstants.mostSearching}?limit=10&offset=$offset', source);

  }

  @override
  Future<ApiResponseModel<T>> getHomeCategoryProductList<T>({required DataSourceEnum source}) async {

    return fetchData(AppConstants.homeCategoryProductUri, source);
  }

  @override
  Future<ApiResponseModel<T>> getClearanceAllProductList<T>({required int offset, required DataSourceEnum source}) async {
    return await fetchData<T>('${AppConstants.clearanceSaleProductUri}?limit=10&offset=$offset', source);
  }



  @override
  Future<ApiResponseModel> getClearanceSearchProducts(String query, String? categoryIds, String? brandIds, String? authorIds, String? publishingIds, String? sort, String? priceMin, String? priceMax, int offset, String? productType, String? offerType) async {

    try {
      final response = await dioClient.post(AppConstants.searchUri,
          data: {'search' : base64.encode(utf8.encode(query)),
            'category': categoryIds != null ? categoryIds.toString() : '[]',
            'brand' : brandIds??'[]',
            'product_authors' : authorIds ?? '[]',
            'publishing_houses' : publishingIds ?? '[]',
            'sort_by': sort,
            'price_min' : priceMin,
            'price_max' : priceMax,
            'limit' : '20',
            'offset' : offset,
            'product_type' : productType ?? 'all',
            'offer_type' : offerType,
          });
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
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }



  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }


  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }



}