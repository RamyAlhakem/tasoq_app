import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/domain/services/wholesale_offers_service_interface.dart';

class WholesaleOffersController extends ChangeNotifier {
  final WholesaleOffersServiceInterface wholesaleOffersServiceInterface;

  WholesaleOffersController({required this.wholesaleOffersServiceInterface});

  static const int _previewLimit = 10;
  static const int _pageSize = 10;

  List<WholesaleProduct>? discountedProducts;
  List<WholesaleProduct>? reducedMoqProducts;
  List<WholesaleSeller>? topDiscountedManufacturers;

  List<WholesaleProduct>? priceDropItems;
  int? priceDropTotalSize;
  int? priceDropOffset;

  List<WholesaleSeller>? allManufacturers;
  int? allManufacturersTotalSize;
  int? allManufacturersOffset;

  List<WholesaleSeller>? categoryManufacturers;
  int? categoryManufacturersTotalSize;
  int? categoryManufacturersOffset;

  Future<void> getDiscountedProducts() async {
    final ApiResponseModel apiResponse = await wholesaleOffersServiceInterface.getDiscountedProducts(offset: 1, limit: _previewLimit);
    if (apiResponse.response?.statusCode == 200) {
      discountedProducts = WholesaleProductListModel.fromJson(apiResponse.response?.data).products ?? [];
      notifyListeners();
    }
  }

  Future<void> getReducedMoqProducts() async {
    final ApiResponseModel apiResponse = await wholesaleOffersServiceInterface.getReducedMoqProducts(offset: 1, limit: _previewLimit);
    if (apiResponse.response?.statusCode == 200) {
      reducedMoqProducts = WholesaleProductListModel.fromJson(apiResponse.response?.data).products ?? [];
      notifyListeners();
    }
  }

  Future<void> getTopDiscountedManufacturers() async {
    final ApiResponseModel apiResponse = await wholesaleOffersServiceInterface.getTopDiscountedManufacturers(offset: 1, limit: _previewLimit);
    if (apiResponse.response?.statusCode == 200) {
      topDiscountedManufacturers = WholesaleSellerListModel.fromJson(apiResponse.response?.data).sellers ?? [];
      notifyListeners();
    }
  }

  Future<void> getPriceDropItems(int offset, bool reload) async {
    if (reload) {
      priceDropItems = null;
      notifyListeners();
    }

    final ApiResponseModel apiResponse = await wholesaleOffersServiceInterface.getPriceDropProducts(offset: offset, limit: _pageSize);
    if (apiResponse.response?.statusCode == 200) {
      final WholesaleProductListModel parsed = WholesaleProductListModel.fromJson(apiResponse.response?.data);
      priceDropItems = offset == 1 ? (parsed.products ?? []) : [...?priceDropItems, ...?parsed.products];
      priceDropTotalSize = parsed.totalSize;
      priceDropOffset = parsed.offset ?? offset;
      notifyListeners();
    } else if (offset == 1) {
      priceDropItems = [];
      notifyListeners();
    }
  }

  Future<void> getAllManufacturers({required int offset, required String type, bool reload = false, String search = ''}) async {
    if (reload) {
      allManufacturers = null;
      notifyListeners();
    }

    final ApiResponseModel apiResponse = await wholesaleOffersServiceInterface.getManufacturers(
      type: type, offset: offset, limit: _pageSize, search: search,
    );
    if (apiResponse.response?.statusCode == 200) {
      final WholesaleSellerListModel parsed = WholesaleSellerListModel.fromJson(apiResponse.response?.data);
      allManufacturers = offset == 1 ? (parsed.sellers ?? []) : [...?allManufacturers, ...?parsed.sellers];
      allManufacturersTotalSize = parsed.totalSize;
      allManufacturersOffset = parsed.offset ?? offset;
      notifyListeners();
    } else if (offset == 1) {
      allManufacturers = [];
      notifyListeners();
    }
  }

  Future<void> getCategoryManufacturers({
    required int offset,
    int? categoryId,
    int? subCategoryId,
    int? subSubCategoryId,
    String search = '',
    bool reload = false,
  }) async {
    if (reload) {
      categoryManufacturers = null;
      notifyListeners();
    }

    final ApiResponseModel apiResponse = await wholesaleOffersServiceInterface.getManufacturers(
      type: 'all', offset: offset, limit: _pageSize, search: search,
      categoryId: categoryId, subCategoryId: subCategoryId, subSubCategoryId: subSubCategoryId,
    );
    if (apiResponse.response?.statusCode == 200) {
      final WholesaleSellerListModel parsed = WholesaleSellerListModel.fromJson(apiResponse.response?.data);
      categoryManufacturers = offset == 1 ? (parsed.sellers ?? []) : [...?categoryManufacturers, ...?parsed.sellers];
      categoryManufacturersTotalSize = parsed.totalSize;
      categoryManufacturersOffset = parsed.offset ?? offset;
      notifyListeners();
    } else if (offset == 1) {
      categoryManufacturers = [];
      notifyListeners();
    }
  }
}
