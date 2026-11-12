import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';

abstract class WholesaleHomeServiceInterface {
  Future<ApiResponseModel<T>> getHomeCategoryList<T>({required DataSourceEnum source});
  Future<ApiResponseModel<T>> getProductRail<T>({required WholesaleProductRailEnum rail, required DataSourceEnum source, int limit = 10, int? categoryId});
  Future<ApiResponseModel<T>> getSellerRail<T>({required WholesaleSellerRailEnum rail, required DataSourceEnum source, int limit = 10, int? categoryId});
  Future<ApiResponseModel> getRecentOrderList({int limit = 10});
  Future<ApiResponseModel> getRecommendedSellerList({int limit = 10});
  Future<ApiResponseModel> getRecentlyViewedShopList({String search = ''});
}
