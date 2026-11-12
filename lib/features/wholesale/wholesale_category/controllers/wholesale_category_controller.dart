import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/domain/models/wholesale_category_node_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/domain/services/wholesale_category_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class WholesaleCategoryController extends ChangeNotifier {
  final WholesaleCategoryServiceInterface wholesaleCategoryServiceInterface;
  WholesaleCategoryController({required this.wholesaleCategoryServiceInterface});

  int _categorySelectedIndex = 0;
  int get categorySelectedIndex => _categorySelectedIndex;

  final List<WholesaleCategoryNode> categoryList = [];

  WholesaleCategoryResponseModel? _categoryResponseModel;
  WholesaleCategoryResponseModel? get categoryResponseModel => _categoryResponseModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Set<int> _childLoadingIds = {};
  bool isChildLoading(int? id) => id != null && _childLoadingIds.contains(id);

  void onChangeSelectedIndex(int index) {
    _categorySelectedIndex = index;

    if (index < categoryList.length) {
      ensureSubCategoryLoaded(categoryList[index]);
    }
    notifyListeners();
  }

  Future<void> getCategoryList({bool reload = false, int offset = 1}) async {
    if (_isLoading) return;
    if (offset == 1 && categoryList.isNotEmpty && !reload) return;

    _isLoading = true;
    if (offset == 1) {
      _categorySelectedIndex = 0;
    }
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCategoryServiceInterface.getCategoryList(offset: offset);

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleCategoryResponseModel parsed = WholesaleCategoryResponseModel.fromJson(apiResponse.response?.data);

      if (offset == 1) {
        categoryList.clear();
      }
      categoryList.addAll(parsed.categories ?? []);
      _categoryResponseModel = parsed;

      if (categoryList.isNotEmpty) {
        ensureSubCategoryLoaded(categoryList[_categorySelectedIndex.clamp(0, categoryList.length - 1)]);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getSubCategoryList({required WholesaleCategoryNode category, int offset = 1}) async {
    final int? categoryId = category.id;
    if (categoryId == null || _childLoadingIds.contains(categoryId)) return;

    _childLoadingIds.add(categoryId);
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCategoryServiceInterface.getSubCategoryList(
      categoryId: categoryId, offset: offset,
    );

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleCategoryResponseModel parsed = WholesaleCategoryResponseModel.fromJson(apiResponse.response?.data);

      category.childTotalSize = parsed.totalSize;
      category.childLimit = parsed.limit;
      category.childOffset = parsed.offset;
      category.setChildren(List.of(parsed.categories ?? []), append: offset > 1);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _childLoadingIds.remove(categoryId);
    notifyListeners();
  }

  Future<void> getSubSubCategoryList({required WholesaleCategoryNode subCategory, int offset = 1}) async {
    final int? subCategoryId = subCategory.id;
    if (subCategoryId == null || _childLoadingIds.contains(subCategoryId)) return;

    _childLoadingIds.add(subCategoryId);
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCategoryServiceInterface.getSubSubCategoryList(
      subCategoryId: subCategoryId, offset: offset,
    );

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleCategoryResponseModel parsed = WholesaleCategoryResponseModel.fromJson(apiResponse.response?.data);

      subCategory.childTotalSize = parsed.totalSize;
      subCategory.childLimit = parsed.limit;
      subCategory.childOffset = parsed.offset;
      subCategory.setChildren(List.of(parsed.categories ?? []), append: offset > 1);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _childLoadingIds.remove(subCategoryId);
    notifyListeners();
  }

  Future<void> ensureSubCategoryLoaded(WholesaleCategoryNode category) async {
    if (category.isChildrenLoaded) return;
    await getSubCategoryList(category: category);
  }

  Future<void> ensureSubSubCategoryLoaded(WholesaleCategoryNode subCategory) async {
    if (subCategory.isChildrenLoaded) return;
    await getSubSubCategoryList(subCategory: subCategory);
  }
}
