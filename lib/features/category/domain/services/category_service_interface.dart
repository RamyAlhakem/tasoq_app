
import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';

abstract class CategoryServiceInterface {

  Future<dynamic> getSellerWiseCategoryList(String slug);
  Future<ApiResponseModel<T>> getList<T>({required DataSourceEnum source, int offset, int limit});

  Future<ApiResponseModel> getSubCategoryList({required int categoryId, required int offset, int limit});

  Future<ApiResponseModel> getSubSubCategoryList({required int subCategoryId, required int offset, int limit});

}