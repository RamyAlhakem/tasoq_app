import 'package:flutter/foundation.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/domain/models/wholesale_restock_request_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/domain/services/wholesale_restock_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';

class WholesaleRestockController extends ChangeNotifier {
  final WholesaleRestockServiceInterface wholesaleRestockServiceInterface;
  WholesaleRestockController({required this.wholesaleRestockServiceInterface});

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<WholesaleRestockRequestItem>? _requests;
  List<WholesaleRestockRequestItem>? get requests => _requests;
  int? _totalSize;
  int? get totalSize => _totalSize;
  int? _offset;
  int? get offset => _offset;

  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  Future<void> getRestockRequestList({int offset = 1}) async {
    final ApiResponseModel apiResponse = await wholesaleRestockServiceInterface.getRestockRequestList(offset: offset);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final WholesaleRestockRequestListModel page = WholesaleRestockRequestListModel.fromJson(Map<String, dynamic>.from(apiResponse.response!.data));

      if (offset == 1) {
        _requests = page.data;
      } else {
        _requests = [...?_requests, ...page.data];
      }
      _totalSize = page.totalSize;
      _offset = page.offset;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<bool> deleteRestockRequest({int? id, bool all = false}) async {
    _isDeleting = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleRestockServiceInterface.deleteRestockRequest(id: id, all: all);
    final int? statusCode = apiResponse.response?.statusCode;
    bool isSuccess = false;

    if (statusCode == 200) {
      await getRestockRequestList();
      isSuccess = true;
    } else if (statusCode == 401 || statusCode == 404) {
      showCustomSnackBarWidget(_errorMessage(apiResponse.response?.data), Get.context, snackBarType: SnackBarType.error);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isDeleting = false;
    notifyListeners();
    return isSuccess;
  }

  String? _errorMessage(dynamic data) {
    if (data is! Map) return null;
    final dynamic errors = data['errors'];
    if (errors is List && errors.isNotEmpty && errors.first is Map) {
      final String? message = (errors.first as Map)['message']?.toString();
      if (message != null && message.isNotEmpty) return message;
    }
    return data['message']?.toString();
  }

  void emptyRestockRequestList() {
    _requests = [];
    _totalSize = null;
    _offset = null;
    notifyListeners();
  }
}
