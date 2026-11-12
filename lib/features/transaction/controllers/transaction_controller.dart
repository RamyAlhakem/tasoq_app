import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/transaction/domain/models/commission_pay_request_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/features/transaction/domain/models/commission_pay_response_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/transaction/domain/models/withdraw_method_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/transaction/domain/models/withdraw_store_or_update_response_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/transaction/domain/service/transaction_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';

class TransactionController extends ChangeNotifier {
  final TransactionServiceInterface transactionServiceInterface;

  TransactionController({required this.transactionServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<WithdrawMethodModel> _withdrawMethods = [];
  List<WithdrawMethodModel> get withdrawMethods => _withdrawMethods;

  bool _isCommissionPayLoading = false;
  bool get isCommissionPayLoading => _isCommissionPayLoading;
  String? _commissionPayRedirectLink;
  String? get commissionPayRedirectLink => _commissionPayRedirectLink;

  bool _isWithdrawLoading = false;
  bool get isWithdrawLoading => _isWithdrawLoading;
  WithdrawStoreOrUpdateResponseModel? _withdrawResponse;
  WithdrawStoreOrUpdateResponseModel? get withdrawResponse => _withdrawResponse;

  bool _isWithdrawSubmitted = false;
  bool get isWithdrawSubmitted => _isWithdrawSubmitted;
  String? _withdrawMethodName;
  String? get withdrawMethodName => _withdrawMethodName;
  String? _withdrawAccountDisplay;
  String? get withdrawAccountDisplay => _withdrawAccountDisplay;

  Future<void> getWithdrawMethodList(BuildContext context) async {
    _isLoading = true;
    _withdrawMethods = [];
    notifyListeners();

    final response = await transactionServiceInterface.getWithdrawMethodList();

    final int? statusCode = response?.response?.statusCode;
    if (statusCode == 200 || statusCode == 201) {
      _withdrawMethods = WithdrawMethodList.fromJson(response?.response?.data).methods;
    } else if (response != null) {
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> payCommission(
    BuildContext context, {
    required int auctionProductId,
    required double feeAmount,
    required String currencyCode,
    required String paymentMethod,
    String? paymentNote,
    int? methodId,
    String? methodName,
    Map<String, String>? methodInformations,
    String? externalRedirectLink,
  }) async {
    _isCommissionPayLoading = true;
    _commissionPayRedirectLink = null;
    notifyListeners();

    final response = await transactionServiceInterface.payCommission(
      commissionPayRequest: CommissionPayRequestModel(
        auctionProductId: auctionProductId,
        feeAmount: feeAmount,
        currencyCode: currencyCode,
        paymentMethod: paymentMethod,
        paymentNote: paymentNote,
        methodId: methodId,
        methodName: methodName,
        methodInformations: methodInformations,
        externalRedirectLink: externalRedirectLink,
      ),
    );

    final int? statusCode = response?.response?.statusCode;
    final dynamic data = response?.response?.data;

    if (statusCode != null && (statusCode == 200 || statusCode == 201)) {
      if (data is Map) {
        final model = CommissionPayResponseModel.fromJson(Map<String, dynamic>.from(data));
        _commissionPayRedirectLink = model.redirectLink;
      }
      if (_commissionPayRedirectLink == null) {
        showCustomSnackBarWidget(
          ApiEnvelope.message(data) ?? getTranslated('commission_paid_successfully', Get.context!),
          Get.context!, snackBarType: SnackBarType.success);
      }
    } else if (statusCode == 403 || statusCode == 404 || statusCode == 409 || statusCode == 422) {

      final String? reason = ApiEnvelope.errorMessage(data);
      showCustomSnackBarWidget(
        (reason != null && reason.isNotEmpty) ? reason : getTranslated('commission_no_due_or_missing_phone', Get.context!),
        Get.context!, snackBarType: SnackBarType.error);
    } else {
      ApiChecker.checkApi(response!);
    }

    _isCommissionPayLoading = false;
    notifyListeners();
  }

  Future<void> createWithdraw(
    BuildContext context, {
    required int auctionProductId,
    required int withdrawMethodId,
    double? amount,
    Map<String, dynamic>? methodInfo,
    String? transactionNote,
    String? displayMethodName,
    String? displayAccountInfo,
  }) async {
    await _submitWithdraw(
      context,
      request: (currentCurrencyCode) => transactionServiceInterface.createWithdraw(
        auctionProductId: auctionProductId,
        withdrawMethodId: withdrawMethodId,
        amount: amount,
        methodInfo: methodInfo,
        transactionNote: transactionNote,
        currentCurrencyCode: currentCurrencyCode,
      ),
      successKey: 'withdrawal_request_submitted_successfully',
      displayMethodName: displayMethodName,
      displayAccountInfo: displayAccountInfo,
    );
  }

  Future<void> updateWithdraw(
    BuildContext context, {
    required int withdrawId,
    required int auctionProductId,
    required int withdrawMethodId,
    double? amount,
    Map<String, dynamic>? methodInfo,
    String? transactionNote,
    String? displayMethodName,
    String? displayAccountInfo,
  }) async {
    await _submitWithdraw(
      context,
      request: (currentCurrencyCode) => transactionServiceInterface.updateWithdraw(
        withdrawId: withdrawId,
        auctionProductId: auctionProductId,
        withdrawMethodId: withdrawMethodId,
        amount: amount,
        methodInfo: methodInfo,
        transactionNote: transactionNote,
        currentCurrencyCode: currentCurrencyCode,
      ),
      successKey: 'withdrawal_request_updated_successfully',
      displayMethodName: displayMethodName,
      displayAccountInfo: displayAccountInfo,
    );
  }

  Future<void> _submitWithdraw(
    BuildContext context, {
    required Future<dynamic> Function(String? currentCurrencyCode) request,
    required String successKey,
    String? displayMethodName,
    String? displayAccountInfo,
  }) async {
    _isWithdrawLoading = true;
    _withdrawResponse = null;
    _isWithdrawSubmitted = false;
    notifyListeners();

    final String? currentCurrencyCode = Provider.of<SplashController>(context, listen: false).myCurrency?.code;

    final response = await request(currentCurrencyCode);

    final int? statusCode = response?.response?.statusCode;
    final dynamic data = response?.response?.data;

    if (statusCode != null && (statusCode == 200 || statusCode == 201)) {
      if (data is Map) {
        _withdrawResponse = WithdrawStoreOrUpdateResponseModel.fromJson(Map<String, dynamic>.from(data));
      }
      _isWithdrawSubmitted = true;
      _withdrawMethodName = displayMethodName;
      _withdrawAccountDisplay = displayAccountInfo;
      showCustomSnackBarWidget(
        ApiEnvelope.message(data) ?? getTranslated(successKey, Get.context!),
        Get.context!, snackBarType: SnackBarType.success);
    } else if (statusCode == 403 || statusCode == 404 || statusCode == 409 || statusCode == 422) {
      final String? reason = ApiEnvelope.errorMessage(data);
      showCustomSnackBarWidget(
        (reason != null && reason.isNotEmpty) ? reason : getTranslated('auction_not_eligible_for_withdrawal', Get.context!),
        Get.context!, snackBarType: SnackBarType.error);
    } else {
      ApiChecker.checkApi(response!);
    }

    _isWithdrawLoading = false;
    notifyListeners();
  }
}