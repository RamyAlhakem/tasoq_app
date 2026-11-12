import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/domain/repositories/wholesale_category_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/domain/services/wholesale_category_service_interface.dart';

class WholesaleCategoryService implements WholesaleCategoryServiceInterface {
  final WholesaleCategoryRepositoryInterface wholesaleCategoryRepositoryInterface;
  WholesaleCategoryService({required this.wholesaleCategoryRepositoryInterface});

  @override
  Future getCategoryList({int offset = 1, int limit = 25}) async {
    return await wholesaleCategoryRepositoryInterface.getCategoryList(offset: offset, limit: limit);
  }

  @override
  Future getSubCategoryList({required int categoryId, int offset = 1, int limit = 25}) async {
    return await wholesaleCategoryRepositoryInterface.getSubCategoryList(categoryId: categoryId, offset: offset, limit: limit);
  }

  @override
  Future getSubSubCategoryList({required int subCategoryId, int offset = 1, int limit = 25}) async {
    return await wholesaleCategoryRepositoryInterface.getSubSubCategoryList(subCategoryId: subCategoryId, offset: offset, limit: limit);
  }
}
