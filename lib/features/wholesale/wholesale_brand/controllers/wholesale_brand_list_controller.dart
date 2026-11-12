import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/models/wholesale_brand_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/services/wholesale_brand_list_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class WholesaleBrandListController extends ChangeNotifier {
  final WholesaleBrandListServiceInterface wholesaleBrandListServiceInterface;
  WholesaleBrandListController({required this.wholesaleBrandListServiceInterface});

  List<WholesaleBrand>? brands;
  WholesaleBrandResponseModel? brandResponseModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getBrandList({int offset = 1, bool reload = false}) async {
    if (_isLoading) return;
    if (offset == 1 && brands != null && !reload) return;

    _isLoading = true;
    if (offset == 1) {
      brands = null;
      notifyListeners();
    }

    final ApiResponseModel apiResponse = await wholesaleBrandListServiceInterface.getBrandList(offset: offset);

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleBrandResponseModel parsed = WholesaleBrandResponseModel.fromJson(apiResponse.response?.data);

      brands = offset == 1 ? (parsed.brands ?? []) : [...?brands, ...?parsed.brands];
      brandResponseModel = parsed;
    } else {
      brands ??= [];
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }
}
