import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/services/category_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/data_sync_helper.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:provider/provider.dart';

class CategoryController extends ChangeNotifier {
  final CategoryServiceInterface? categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});



  final List<CategoryModel> _filteredCategoryList = [];
  final List<CategoryModel> _categoryList = [];
  final List<CategoryModel> _sellerWiseCategoryList = [];
  int? _categorySelectedIndex;

  List<CategoryModel> get categoryList => _categoryList;
  List<CategoryModel> get sellerWiseCategoryList => _sellerWiseCategoryList;
  List<CategoryModel> get filteredCategoryList => _filteredCategoryList;

  int? get categorySelectedIndex => _categorySelectedIndex;

  CategoryResponseModel? _categoryResponseModel;
  CategoryResponseModel? get categoryResponseModel => _categoryResponseModel;

  bool _categoryLoading = false;
  bool get categoryLoading => _categoryLoading;

  Future<void> fetchWithCache() async {
    await getCategoryList(false);
  }


  Future<void> getCategoryList(bool reload, {int offset = 1}) async {
    if(_categoryLoading) return;

    if(offset == 1) {
      if(_categoryList.isNotEmpty && !reload) return;

      _categoryLoading = true;

      await DataSyncHelper.fetchAndSyncData(
        fetchFromLocal: ()=> categoryServiceInterface!.getList(source: DataSourceEnum.local, offset: offset),
        fetchFromClient: ()=> categoryServiceInterface!.getList(source: DataSourceEnum.client, offset: offset),
        onResponse: (data, source) {
          if(data != null) {
            _categoryResponseModel = CategoryResponseModel.fromJson(data);

            _categoryList.clear();
            _categoryList.addAll(_categoryResponseModel?.categories ?? []);
            _categorySelectedIndex = 0;

            onUpdateFilteredCategoryList(isSeller: false);
            notifyListeners();

            if(_categoryList.isNotEmpty) {
              ensureSubCategoryLoaded(_categoryList.first);
            }
          }
        },
      );

      _categoryLoading = false;
      notifyListeners();

    } else {
      _categoryLoading = true;
      notifyListeners();

      final ApiResponseModel apiResponse = await categoryServiceInterface!.getList(source: DataSourceEnum.client, offset: offset);

      if(apiResponse.response?.statusCode == 200) {
        final CategoryResponseModel parsed = CategoryResponseModel.fromJson(apiResponse.response?.data);

        _categoryResponseModel?.offset = parsed.offset;
        _categoryResponseModel?.limit = parsed.limit;
        _categoryResponseModel?.totalSize = parsed.totalSize;

        _categoryList.addAll(parsed.categories ?? []);
        onUpdateFilteredCategoryList(isSeller: false);
      }

      _categoryLoading = false;
      notifyListeners();
    }
  }

  final Set<int> _childLoadingIds = {};
  bool isChildLoading(int? id) => id != null && _childLoadingIds.contains(id);

  Future<void> getSubCategoryList({required CategoryModel category, required int offset}) async {
    final int? categoryId = category.id;
    if(categoryId == null || _childLoadingIds.contains(categoryId)) return;

    _childLoadingIds.add(categoryId);
    notifyListeners();

    final ApiResponseModel apiResponse = await categoryServiceInterface!.getSubCategoryList(categoryId: categoryId, offset: offset);

    if(apiResponse.response?.statusCode == 200) {
      final SubCategoryResponseModel parsed = SubCategoryResponseModel.fromJson(apiResponse.response?.data);

      // The list can be rebuilt while this request is in flight (local cache then
      // client refresh), so write into the instance that is currently in the list.
      for(final CategoryModel target in {
        category,
        ..._categoryList.where((c) => c.id == categoryId),
      }) {
        target.subCategoryTotalSize = parsed.totalSize;
        target.subCategoryLimit = parsed.limit;
        target.subCategoryOffset = parsed.offset;
        target.setSubCategories(List.of(parsed.subCategories ?? []), append: offset > 1);
      }
    }

    _childLoadingIds.remove(categoryId);
    notifyListeners();
  }

  Future<void> getSubSubCategoryList({required SubCategory subCategory, required int offset}) async {
    final int? subCategoryId = subCategory.id;
    if(subCategoryId == null || _childLoadingIds.contains(subCategoryId)) return;

    _childLoadingIds.add(subCategoryId);
    notifyListeners();

    final ApiResponseModel apiResponse = await categoryServiceInterface!.getSubSubCategoryList(subCategoryId: subCategoryId, offset: offset);

    if(apiResponse.response?.statusCode == 200) {
      final SubSubCategoryResponseModel parsed = SubSubCategoryResponseModel.fromJson(apiResponse.response?.data);

      subCategory.subSubCategoryTotalSize = parsed.totalSize;
      subCategory.subSubCategoryLimit = parsed.limit;
      subCategory.subSubCategoryOffset = parsed.offset;
      subCategory.setSubSubCategories(parsed.subSubCategories ?? [], append: offset > 1);
    }

    _childLoadingIds.remove(subCategoryId);
    notifyListeners();
  }

  Future<void> ensureSubCategoryLoaded(CategoryModel category) async {
    if(category.subCategories != null) return;
    await getSubCategoryList(category: category, offset: 1);
  }

  Future<void> ensureSubSubCategoryLoaded(SubCategory subCategory) async {
    if(subCategory.subSubCategories != null) return;
    await getSubSubCategoryList(subCategory: subCategory, offset: 1);
  }


  void onUpdateFilteredCategoryList({required bool isSeller}) {
    _filteredCategoryList.clear();
    _filteredCategoryList.addAll(isSeller ? _sellerWiseCategoryList : _categoryList);
  }




  Future<void> getSellerWiseCategoryList(String slug) async {
      ApiResponseModel apiResponse = await categoryServiceInterface!.getSellerWiseCategoryList(slug);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _sellerWiseCategoryList.clear();
        final dynamic body = apiResponse.response!.data;
        final List rows = body is List ? body : (ApiListEnvelope.fromJson(Map<String, dynamic>.from(body as Map)).data ?? const []);
        for (final Map category in rows.whereType<Map>()) {
          _sellerWiseCategoryList.add(CategoryModel.fromJson(Map<String, dynamic>.from(category)));
        }

      } else {
        ApiChecker.checkApi( apiResponse);
      }

      onUpdateFilteredCategoryList(isSeller: true);

      notifyListeners();

  }

  final List<int> _selectedCategoryIds = [];
  List<int> get selectedCategoryIds => _selectedCategoryIds;

  void checkedToggleCategory(int index){
    _filteredCategoryList[index].isSelected = !_filteredCategoryList[index].isSelected!;

    if(_filteredCategoryList[index].isSelected ?? false) {
      if(!_selectedCategoryIds.contains(index)) {
        _selectedCategoryIds.add(index);
      }
      ensureSubCategoryLoaded(_filteredCategoryList[index]);

    }else {
      _selectedCategoryIds.remove(index);
      _onDisableSubCategorySelection(index);
    }
    notifyListeners();
  }

  void _onDisableSubCategorySelection(int index) {
    _filteredCategoryList[index].subCategories?.forEach((subCategory){
      subCategory.isSelected = false;
    });
  }

  void checkedToggleSubCategory(int index, int subCategoryIndex){
    _filteredCategoryList[index].subCategories![subCategoryIndex].isSelected = !_filteredCategoryList[index].subCategories![subCategoryIndex].isSelected!;
    notifyListeners();
  }

  Future<void> resetChecked(String? slug, bool fromShop) async {
    if(fromShop){
      await getSellerWiseCategoryList(slug!);
      Provider.of<BrandController>(Get.context!, listen: false).getSellerWiseBrandList(slug);
      Provider.of<SellerProductController>(Get.context!, listen: false).getSellerProductList(slug.toString(), 1, "");
      Provider.of<SellerProductController>(Get.context!, listen: false).setFilterApply(false);
    }else{
      await getCategoryList(true);
      Provider.of<BrandController>(Get.context!, listen: false).getBrandList(offset: 1);
    }

  }

  void onChangeSelectedIndex(int selectedIndex, {bool isUpdate = true}) {
    _categorySelectedIndex = selectedIndex;

    if(selectedIndex < _categoryList.length) {
      ensureSubCategoryLoaded(_categoryList[selectedIndex]);
    }

    if(isUpdate){
      notifyListeners();
    }
  }

  void uncheckSellerCategoryList() {
    if(_filteredCategoryList.isNotEmpty) {
      _filteredCategoryList.map((category) {category.isSelected = false;}).toList();
    }
  }


}
