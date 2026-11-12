import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_attribute/domain/models/wholesale_attribute_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_attribute/domain/services/wholesale_attribute_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class WholesaleAttributeController extends ChangeNotifier {
  final WholesaleAttributeServiceInterface wholesaleAttributeServiceInterface;
  WholesaleAttributeController({required this.wholesaleAttributeServiceInterface});

  List<WholesaleAttribute>? attributes;
  WholesaleAttributeResponseModel? attributeResponseModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getAttributeList({bool reload = false, int offset = 1}) async {
    if (_isLoading) return;
    if (offset == 1 && attributes != null && !reload) return;

    _isLoading = true;
    if (offset == 1 && reload) {
      attributes = null;
    }
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleAttributeServiceInterface.getAttributeList(offset: offset);

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleAttributeResponseModel parsed = WholesaleAttributeResponseModel.fromJson(apiResponse.response?.data);

      attributes = offset == 1 ? (parsed.attributes ?? []) : [...?attributes, ...?parsed.attributes];
      attributeResponseModel = parsed;
    } else {
      attributes ??= [];
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }
}
