import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/repositories/category_repo_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/services/category_service_interface.dart';

class CategoryService implements CategoryServiceInterface{
  CategoryRepoInterface categoryRepoInterface;
  CategoryService({required this.categoryRepoInterface});

  @override
  Future<ApiResponseModel<T>> getList<T>({required DataSourceEnum source, int offset = 1, int limit = 25}) async{
    return await categoryRepoInterface.getCategoryList(source: source, offset: offset, limit: limit);
  }

  @override
  Future<ApiResponseModel> getSubCategoryList({required int categoryId, required int offset, int limit = 25}) async{
    return await categoryRepoInterface.getSubCategoryList(categoryId: categoryId, offset: offset, limit: limit);
  }

  @override
  Future<ApiResponseModel> getSubSubCategoryList({required int subCategoryId, required int offset, int limit = 25}) async{
    return await categoryRepoInterface.getSubSubCategoryList(subCategoryId: subCategoryId, offset: offset, limit: limit);
  }

  @override
  Future getSellerWiseCategoryList(String slug) async{
    return await categoryRepoInterface.getSellerWiseCategoryList(slug);
  }

}