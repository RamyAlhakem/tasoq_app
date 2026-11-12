import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleCategoryRepositoryInterface extends RepositoryInterface {

  Future<dynamic> getCategoryList({int offset = 1, int limit = 25});

  Future<dynamic> getSubCategoryList({required int categoryId, int offset = 1, int limit = 25});

  Future<dynamic> getSubSubCategoryList({required int subCategoryId, int offset = 1, int limit = 25});
}
