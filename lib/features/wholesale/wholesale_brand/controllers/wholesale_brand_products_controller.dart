import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/controllers/wholesale_product_listing_mixin.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/domain/models/wholesale_product_filter_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/services/wholesale_brand_list_service_interface.dart';

class WholesaleBrandProductsController extends ChangeNotifier with WholesaleProductListingMixin {
  final WholesaleBrandListServiceInterface wholesaleBrandListServiceInterface;

  WholesaleBrandProductsController({required this.wholesaleBrandListServiceInterface});

  int? _brandId;
  int? get brandId => _brandId;

  void setBrand(int brandId) {
    _brandId = brandId;
    resetList();
    setFilter(const WholesaleProductFilterModel());
  }

  @override
  Future<ApiResponseModel> fetchProductPage({
    required int page,
    required int limit,
    required Map<String, dynamic> filterParams,
  }) async {
    final int? id = _brandId;
    if (id == null) {
      return ApiResponseModel.withError('something_went_wrong');
    }

    return await wholesaleBrandListServiceInterface.getBrandProductList(
      brandId: id, page: page, limit: limit, filterParams: filterParams,
    );
  }
}
