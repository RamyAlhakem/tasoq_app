import 'package:flutter/foundation.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/domain/models/attribute_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/domain/models/compare_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/domain/services/compare_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';


class CompareController extends ChangeNotifier {
  final CompareServiceInterface compareServiceInterface;
  CompareController({required this.compareServiceInterface});



  void addCompareList(int productID) async {
    ApiResponseModel apiResponse = await compareServiceInterface.addCompareProductList(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getCompareList();
      showCustomSnackBarWidget(apiResponse.response!.data['message'], Get.context!, snackBarType: SnackBarType.success);
    } else {
      showCustomSnackBarWidget(apiResponse.error.toString(), Get.context!, snackBarType: SnackBarType.error);
    }
    notifyListeners();
  }

  List<int> compIds = [];
  CompareModel? compareModel;
  void getCompareList() async {

    ApiResponseModel apiResponse = await compareServiceInterface.getList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      compIds = [];
      compareModel = CompareModel.fromJson(apiResponse.response?.data);
      for(final CompareLists row in compareModel?.compareLists ?? []){
        if(row.productId != null) compIds.add(row.productId!);
      }
    } else {
      showCustomSnackBarWidget(apiResponse.error.toString(), Get.context!, snackBarType: SnackBarType.error);
    }
    notifyListeners();
  }

  void removeAllCompareList() async {
    ApiResponseModel apiResponse = await compareServiceInterface.removeAllCompareProductList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarWidget(apiResponse.response!.data['message'], Get.context!, snackBarType: SnackBarType.success);
      getCompareList();
    } else {
      showCustomSnackBarWidget(apiResponse.error.toString(), Get.context!, snackBarType: SnackBarType.error);
    }
    notifyListeners();
  }

  void replaceCompareList(int compareId, int productId) async {
    ApiResponseModel apiResponse = await compareServiceInterface.replaceCompareProductList(compareId, productId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getCompareList();
      showCustomSnackBarWidget(apiResponse.response!.data['message'], Get.context!, snackBarType: SnackBarType.success);
    } else {
      showCustomSnackBarWidget(apiResponse.error.toString(), Get.context!, snackBarType: SnackBarType.error);
    }
    notifyListeners();
  }


  List<AttributeModel>? attributeList = [];

  // The compare table renders one row per attribute, so every page is loaded before painting.
  void getAttributeList() async {
    final List<AttributeModel> attributes = [];
    int offset = 1;
    int? totalSize;

    do {
      ApiResponseModel response = await compareServiceInterface.getAttributeList(offset: offset);
      if (response.response == null || response.response!.statusCode != 200) {
        ApiChecker.checkApi(response);
        notifyListeners();
        return;
      }

      final AttributeResponseModel attributeResponse = AttributeResponseModel.fromJson(response.response!.data);
      totalSize = attributeResponse.totalSize ?? 0;
      if (attributeResponse.attributes == null || attributeResponse.attributes!.isEmpty) {
        break;
      }
      attributes.addAll(attributeResponse.attributes!);
      offset++;
    } while (attributes.length < totalSize);

    attributeList = attributes;
    notifyListeners();
  }





}
