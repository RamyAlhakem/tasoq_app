import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/repositories/wholesale_home_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/services/wholesale_home_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';

class WholesaleHomeService implements WholesaleHomeServiceInterface {
  final WholesaleHomeRepositoryInterface wholesaleHomeRepositoryInterface;

  WholesaleHomeService({required this.wholesaleHomeRepositoryInterface});

  @override
  Future<ApiResponseModel<T>> getHomeCategoryList<T>({required DataSourceEnum source}) async {
    return await wholesaleHomeRepositoryInterface.getHomeCategoryList<T>(source: source);
  }

  @override
  Future<ApiResponseModel<T>> getProductRail<T>({required WholesaleProductRailEnum rail, required DataSourceEnum source, int limit = 10, int? categoryId}) async {
    return await wholesaleHomeRepositoryInterface.getProductRail<T>(rail: rail, source: source, limit: limit, categoryId: categoryId);
  }

  @override
  Future<ApiResponseModel<T>> getSellerRail<T>({required WholesaleSellerRailEnum rail, required DataSourceEnum source, int limit = 10, int? categoryId}) async {
    return await wholesaleHomeRepositoryInterface.getSellerRail<T>(rail: rail, source: source, limit: limit, categoryId: categoryId);
  }

  @override
  Future<ApiResponseModel> getRecentOrderList({int limit = 10}) async {
    return await wholesaleHomeRepositoryInterface.getRecentOrderList(limit: limit);
  }

  @override
  Future<ApiResponseModel> getRecommendedSellerList({int limit = 10}) async {
    return await wholesaleHomeRepositoryInterface.getRecommendedSellerList(limit: limit);
  }

  @override
  Future<ApiResponseModel> getRecentlyViewedShopList({String search = ''}) async {
    return await wholesaleHomeRepositoryInterface.getRecentlyViewedShopList(search: search);
  }
}
