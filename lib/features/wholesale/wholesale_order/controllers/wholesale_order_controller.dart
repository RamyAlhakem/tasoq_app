import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_tracking_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_tracking_summary_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/services/wholesale_order_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class WholesaleOrderController with ChangeNotifier {
  final WholesaleOrderServiceInterface wholesaleOrderServiceInterface;
  WholesaleOrderController({required this.wholesaleOrderServiceInterface});

  static const List<String> _tabStatuses = ['ongoing', 'delivered', 'canceled'];

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  void setTabIndex(int index) {
    if (_tabIndex == index) return;
    _tabIndex = index;
    getOrderList(reload: true);
  }

  List<WholesaleOrderModel>? orderList;
  WholesaleOrderListResponseModel? orderListResponse;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getOrderList({int offset = 1, bool reload = false}) async {
    if (_isLoading) return;
    if (offset == 1 && orderList != null && !reload) return;

    _isLoading = true;
    if (offset == 1) {
      orderList = null;
      notifyListeners();
    }

    final ApiResponseModel apiResponse = await wholesaleOrderServiceInterface.getOrderList(
      offset: offset,
      status: _tabStatuses[_tabIndex],
    );

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleOrderListResponseModel parsed = WholesaleOrderListResponseModel.fromJson(apiResponse.response!.data);

      orderList = offset == 1 ? parsed.orders : [...?orderList, ...parsed.orders];
      orderListResponse = parsed;
    } else {
      orderList ??= [];
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  final Map<int, WholesaleOrderDetailsModel> _orderDetails = {};
  final Map<int, bool> _orderDetailsLoading = {};

  WholesaleOrderDetailsModel? orderDetailsFor(int orderId) => _orderDetails[orderId];
  bool isOrderDetailsLoading(int orderId) => _orderDetailsLoading[orderId] ?? false;

  Future<void> loadOrderDetails(int orderId, {bool reload = false}) async {
    if (_orderDetails.containsKey(orderId) && !reload) return;

    _orderDetailsLoading[orderId] = true;
    notifyListeners();

    final ApiResponseModel headerResponse = await wholesaleOrderServiceInterface.getOrderDetails(orderId);
    final ApiResponseModel itemsResponse = await wholesaleOrderServiceInterface.getOrderItems(orderId);

    if (headerResponse.response?.statusCode == 200 && itemsResponse.response?.statusCode == 200) {
      final dynamic headerData = ApiEnvelope.content(headerResponse.response!.data)['data'];
      final dynamic itemsData = ApiEnvelope.content(itemsResponse.response!.data)['data'];

      _orderDetails[orderId] = WholesaleOrderDetailsModel.fromJson(
        headerData is Map ? Map<String, dynamic>.from(headerData) : {},
        itemsData is List ? itemsData : [],
      );
    } else {
      ApiChecker.checkApi(headerResponse.response?.statusCode == 200 ? itemsResponse : headerResponse);
    }

    _orderDetailsLoading[orderId] = false;
    notifyListeners();
  }

  final Map<int, WholesaleOrderTrackingHistory> _trackingHistory = {};
  final Map<int, bool> _trackingLoading = {};
  final Map<int, bool> _trackingFailed = {};

  WholesaleOrderTrackingHistory? trackingHistoryFor(int orderId) => _trackingHistory[orderId];
  bool isTrackingLoading(int orderId) => _trackingLoading[orderId] ?? false;
  bool didTrackingFail(int orderId) => _trackingFailed[orderId] ?? false;

  Future<void> loadTrackingHistory(int orderId, {bool reload = false, String? phoneNumber}) async {
    if (_trackingHistory.containsKey(orderId) && !reload) return;

    _trackingLoading[orderId] = true;
    _trackingFailed[orderId] = false;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleOrderServiceInterface.getOrderStatusHistory(orderId, phoneNumber: phoneNumber);

    if (apiResponse.response?.statusCode == 200) {
      final dynamic steps = ApiEnvelope.content(apiResponse.response!.data)['data'];
      _trackingHistory[orderId] = WholesaleOrderTrackingHistory.fromJson(steps is List ? steps : []);
    } else {
      _trackingFailed[orderId] = true;
      ApiChecker.checkApi(apiResponse);
    }

    _trackingLoading[orderId] = false;
    notifyListeners();
  }

  final Map<int, WholesaleOrderTrackingSummaryModel> _trackingSummary = {};

  WholesaleOrderTrackingSummaryModel? trackingSummaryFor(int orderId) => _trackingSummary[orderId];

  Future<void> loadOrderTracking(int orderId, {bool reload = false, String? phoneNumber}) async {
    if (_trackingSummary.containsKey(orderId) && !reload) return;

    final ApiResponseModel apiResponse = await wholesaleOrderServiceInterface.getOrderTracking(orderId, phoneNumber: phoneNumber);

    if (apiResponse.response?.statusCode == 200) {
      final dynamic data = ApiEnvelope.content(apiResponse.response!.data)['data'];
      _trackingSummary[orderId] = WholesaleOrderTrackingSummaryModel.fromJson(data is Map ? Map<String, dynamic>.from(data) : {});
      notifyListeners();
    }
  }

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  Future<ApiResponseModel> trackOrder({required int orderId, String? phoneNumber}) async {
    _isTracking = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleOrderServiceInterface.trackOrder(orderId: orderId, phoneNumber: phoneNumber);

    if (apiResponse.response?.statusCode != 200) {
      ApiChecker.checkApi(apiResponse);
    }

    _isTracking = false;
    notifyListeners();
    return apiResponse;
  }

  bool _isInvoiceLoading = false;
  bool get isInvoiceLoading => _isInvoiceLoading;

  Future<void> requestStoragePermission() async {
    final PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> getOrderInvoice(int orderId, BuildContext context) async {
    _isInvoiceLoading = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleOrderServiceInterface.getOrderInvoice(orderId);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      await requestStoragePermission();
      final Directory downloadsDirectory = Directory('/storage/emulated/0/Download');
      final List<int> bytes = List<int>.from(apiResponse.response!.data['content']['data']);

      String fileName = '$orderId.pdf';
      String filePath = path.join(downloadsDirectory.path, fileName);

      int fileCounter = 1;
      while (await File(filePath).exists()) {
        fileName = '$orderId($fileCounter).pdf';
        filePath = path.join(downloadsDirectory.path, fileName);
        fileCounter++;
      }

      final File file = File(filePath);
      await file.writeAsBytes(bytes);
      await OpenFile.open(filePath);
      if (context.mounted) {
        showCustomSnackBarWidget(getTranslated('invoice_downloaded_successfully', context), context, snackBarType: SnackBarType.success);
      }
    } else if (context.mounted) {
      showCustomSnackBarWidget(getTranslated('invoice_download_failed', context), context, snackBarType: SnackBarType.error);
    }

    _isInvoiceLoading = false;
    notifyListeners();
  }

  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;

  Future<ApiResponseModel> cancelOrder(int orderId) async {
    _isCancelling = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleOrderServiceInterface.cancelOrder(orderId);

    if (apiResponse.response?.statusCode == 200) {
      await loadOrderDetails(orderId, reload: true);
      await getOrderList(reload: true);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isCancelling = false;
    notifyListeners();
    return apiResponse;
  }

  int? _dueSettlementOrderId;
  int? get dueSettlementOrderId => _dueSettlementOrderId;

  Future<void> settleEditOrderDueAmount({required int orderId, required String paymentMethod}) async {
    _dueSettlementOrderId = orderId;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final WholesaleOrderDetailsModel? current = _orderDetails[orderId];
    if (current?.latestEditHistory != null) {
      _orderDetails[orderId] = current!.copyWith(
        latestEditHistory: current.latestEditHistory!.copyWith(orderDuePaymentStatus: 'paid', orderDuePaymentMethod: paymentMethod),
      );
    }

    _dueSettlementOrderId = null;
    notifyListeners();
  }
}
