import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_refund_info_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_refund_result_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/services/wholesale_refund_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/image_size_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class WholesaleRefundController with ChangeNotifier {
  final WholesaleRefundServiceInterface wholesaleRefundServiceInterface;
  WholesaleRefundController({required this.wholesaleRefundServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isEligibilityLoading = false;
  bool get isEligibilityLoading => _isEligibilityLoading;

  List<XFile?> refundImages = [];

  WholesaleRefundInfoModel? _refundInfoModel;
  WholesaleRefundInfoModel? get refundInfoModel => _refundInfoModel;

  WholesaleRefundResultModel? _refundResultModel;
  WholesaleRefundResultModel? get refundResultModel => _refundResultModel;

  int? _selectedOrderDetailsId;
  int? get selectedOrderDetailsId => _selectedOrderDetailsId;

  bool isEligibilityLoadingFor(int orderDetailsId) => _isEligibilityLoading && _selectedOrderDetailsId == orderDetailsId;

  bool isResultLoadingFor(int orderDetailsId) => _isLoading && _selectedOrderDetailsId == orderDetailsId;

  void pickRefundImage(bool isRemove) async {
    if (isRemove) {
      refundImages = [];
    } else {
      final XFile? image = await ImageValidationHelper.validateAndPickImage(source: ImageSource.gallery, context: Get.context!);
      if (image != null && File(image.path).existsSync()) {
        refundImages.add(image);
      }
    }
    notifyListeners();
  }

  void removeRefundImage(int index) {
    if (index >= 0 && index < refundImages.length) {
      refundImages.removeAt(index);
    }
    notifyListeners();
  }

  Future<ApiResponseModel> getRefundEligibility(int orderDetailsId) async {
    _selectedOrderDetailsId = orderDetailsId;
    _isEligibilityLoading = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleRefundServiceInterface.getRefundEligibility(orderDetailsId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic data = ApiEnvelope.content(apiResponse.response!.data)['data'];
      if (data is Map<String, dynamic>) {
        _refundInfoModel = WholesaleRefundInfoModel.fromJson(data);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isEligibilityLoading = false;
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponseModel> getRefundResult(int orderDetailsId) async {
    _selectedOrderDetailsId = orderDetailsId;
    _isLoading = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleRefundServiceInterface.getRefundResult(orderDetailsId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic data = ApiEnvelope.content(apiResponse.response!.data)['data'];
      if (data is Map<String, dynamic>) {
        _refundResultModel = WholesaleRefundResultModel.fromJson(data);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponseModel> submitRefundRequest({required int orderId, required int orderDetailsId, required String refundReason}) async {
    setSelectedOrderDetailsId(orderDetailsId);
    _isLoading = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleRefundServiceInterface.submitRefundRequest(
      orderDetailsId: orderDetailsId,
      refundReason: refundReason,
      images: refundImages,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic data = ApiEnvelope.content(apiResponse.response!.data)['data'];
      if (data is Map<String, dynamic>) {
        _refundResultModel = WholesaleRefundResultModel.fromJson(data);
      }
      Navigator.pop(Get.context!);
      showCustomSnackBarWidget(getTranslated('successfully_requested_for_refund', Get.context!), Get.context!, snackBarType: SnackBarType.success);
      Provider.of<WholesaleOrderController>(Get.context!, listen: false).loadOrderDetails(orderId, reload: true);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    refundImages = [];
    _isLoading = false;
    notifyListeners();
    return apiResponse;
  }

  void setSelectedOrderDetailsId(int? orderDetailsId) {
    _selectedOrderDetailsId = orderDetailsId;
  }

  void removeRefundDetails() {
    _refundInfoModel = null;
    _refundResultModel = null;
    notifyListeners();
  }
}
