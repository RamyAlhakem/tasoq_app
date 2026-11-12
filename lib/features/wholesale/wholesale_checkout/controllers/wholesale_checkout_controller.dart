import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/domain/services/checkout_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/offline_payment/domain/models/offline_payment_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/domain/models/wholesale_order_place_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/domain/services/wholesale_checkout_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class WholesaleCheckoutController with ChangeNotifier {
  final CheckoutServiceInterface checkoutServiceInterface;
  final WholesaleCheckoutServiceInterface wholesaleCheckoutServiceInterface;
  WholesaleCheckoutController({required this.checkoutServiceInterface, required this.wholesaleCheckoutServiceInterface});

  int? _addressIndex;
  int? get addressIndex => _addressIndex;
  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }

  void shippingAddressNull() {
    _addressIndex = null;
    notifyListeners();
  }

  int? _billingAddressIndex;
  int? get billingAddressIndex => _billingAddressIndex;
  void setBillingAddressIndex(int index) {
    _billingAddressIndex = index;
    notifyListeners();
  }

  void billingAddressNull() {
    _billingAddressIndex = null;
    notifyListeners();
  }

  bool sameAsBilling = false;
  void setSameAsBilling({bool isUpdate = true}) {
    sameAsBilling = !sameAsBilling;
    if (isUpdate) {
      notifyListeners();
    }
  }

  bool _isAcceptTerms = false;
  bool get isAcceptTerms => _isAcceptTerms;
  void toggleTermsCheck({bool isUpdate = true}) {
    _isAcceptTerms = !_isAcceptTerms;
    if (isUpdate) {
      notifyListeners();
    }
  }

  final TextEditingController orderNoteController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isCheckCreateAccount = false;
  bool get isCheckCreateAccount => _isCheckCreateAccount;
  void setIsCheckCreateAccount(bool isCheck, {bool update = true}) {
    _isCheckCreateAccount = isCheck;
    if (update) {
      notifyListeners();
    }
  }

  int _paymentMethodIndex = -1;
  int get paymentMethodIndex => _paymentMethodIndex;
  String selectedDigitalPaymentMethodName = '';
  bool isCODChecked = false;
  bool isOfflineChecked = false;
  bool isWalletChecked = false;

  void resetPaymentMethod() {
    _paymentMethodIndex = -1;
    isCODChecked = false;
    isWalletChecked = false;
    isOfflineChecked = false;
  }

  void setOfflineChecked(String type, {bool notify = true}) {
    if (type == 'offline') {
      isOfflineChecked = !isOfflineChecked;
      isCODChecked = false;
      isWalletChecked = false;
      _paymentMethodIndex = -1;
      setOfflinePaymentMethodSelectedIndex(0, notify: false);
    } else if (type == 'cod') {
      isCODChecked = !isCODChecked;
      isOfflineChecked = false;
      isWalletChecked = false;
      _paymentMethodIndex = -1;
    } else if (type == 'wallet') {
      isWalletChecked = !isWalletChecked;
      isOfflineChecked = false;
      isCODChecked = false;
      _paymentMethodIndex = -1;
    }

    if (notify) {
      notifyListeners();
    }
  }

  void setDigitalPaymentMethodName(int index, String name) {
    _paymentMethodIndex = index;
    selectedDigitalPaymentMethodName = name;
    isCODChecked = false;
    isWalletChecked = false;
    isOfflineChecked = false;
    notifyListeners();
  }

  void updatePaymentSelection() {
    notifyListeners();
  }

  OfflinePaymentModel? offlinePaymentModel;
  Future<void> getOfflinePaymentList() async {
    ApiResponseModel apiResponse = await checkoutServiceInterface.offlinePaymentList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      offlineMethodSelectedIndex = 0;
      offlinePaymentModel = OfflinePaymentModel.fromJson(apiResponse.response?.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  List<TextEditingController> inputFieldControllerList = [];
  List<String?> keyList = [];
  int offlineMethodSelectedIndex = -1;
  int offlineMethodSelectedId = 0;
  String offlineMethodSelectedName = '';

  void _disposeInputFieldControllers() {
    for (final controller in inputFieldControllerList) {
      controller.dispose();
    }
  }

  void setOfflinePaymentMethodSelectedIndex(int index, {bool notify = true}) {
    keyList = [];
    _disposeInputFieldControllers();
    inputFieldControllerList = [];
    offlineMethodSelectedIndex = index;
    final List<OfflineMethods>? methods = offlinePaymentModel?.offlineMethods;
    if (methods != null && methods.isNotEmpty) {
      offlineMethodSelectedId = methods[index].id!;
      offlineMethodSelectedName = methods[index].methodName!;
      for (final MethodInformations info in methods[index].methodInformations!) {
        inputFieldControllerList.add(TextEditingController());
        keyList.add(info.customerInput);
      }
    }
    if (notify) {
      notifyListeners();
    }
  }

  double? _cashChangesAmount;
  double? get cashChangesAmount => _cashChangesAmount;
  void onChangeCashChangesAmount(double? amount) => _cashChangesAmount = amount;

  bool _isPlacingOrder = false;
  bool get isPlacingOrder => _isPlacingOrder;

  static const _handledStatusCodes = {401, 403, 409, 422};

  Future<WholesaleOrderPlaceResult> placeCashOnDelivery({
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  }) async {
    _isPlacingOrder = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCheckoutServiceInterface.placeCashOnDelivery(
      addressId: addressId,
      billingAddressId: billingAddressId,
      couponCode: couponCode,
      orderNote: orderNote,
      currentCurrencyCode: currentCurrencyCode,
      bringChangeAmount: _cashChangesAmount,
    );
    final WholesaleOrderPlaceResult result = _handlePlacement(apiResponse);

    _isPlacingOrder = false;
    notifyListeners();
    return result;
  }

  Future<WholesaleOrderPlaceResult> placeOfflinePayment({
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
    String? paymentNote,
  }) async {
    _isPlacingOrder = true;
    notifyListeners();

    final Map<String, String> methodInformations = {};
    for (int i = 0; i < keyList.length && i < inputFieldControllerList.length; i++) {
      final String? key = keyList[i];
      if (key != null && key.isNotEmpty) {
        methodInformations[key] = inputFieldControllerList[i].text.trim();
      }
    }

    final ApiResponseModel apiResponse = await wholesaleCheckoutServiceInterface.placeOfflinePayment(
      methodId: offlineMethodSelectedId,
      paymentNote: paymentNote,
      methodInformations: methodInformations,
      addressId: addressId,
      billingAddressId: billingAddressId,
      couponCode: couponCode,
      orderNote: orderNote,
      currentCurrencyCode: currentCurrencyCode,
    );
    final WholesaleOrderPlaceResult result = _handlePlacement(apiResponse);

    _isPlacingOrder = false;
    notifyListeners();
    return result;
  }

  Future<WholesaleOrderPlaceResult> placeWalletPayment({
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  }) async {
    _isPlacingOrder = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCheckoutServiceInterface.placeWalletPayment(
      addressId: addressId,
      billingAddressId: billingAddressId,
      couponCode: couponCode,
      orderNote: orderNote,
      currentCurrencyCode: currentCurrencyCode,
    );
    final WholesaleOrderPlaceResult result = _handlePlacement(apiResponse);

    _isPlacingOrder = false;
    notifyListeners();
    return result;
  }

  Future<WholesaleDigitalPaymentLinkResult> createDigitalPaymentLink({
    required String paymentMethod,
    String? paymentPlatform,
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? orderNote,
    String? currentCurrencyCode,
  }) async {
    _isPlacingOrder = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCheckoutServiceInterface.createDigitalPaymentLink(
      paymentMethod: paymentMethod,
      paymentPlatform: paymentPlatform,
      addressId: addressId,
      billingAddressId: billingAddressId,
      couponCode: couponCode,
      orderNote: orderNote,
      currentCurrencyCode: currentCurrencyCode,
    );
    final int? statusCode = apiResponse.response?.statusCode;
    final WholesaleDigitalPaymentLinkResult result = WholesaleDigitalPaymentLinkResult.fromResponse(statusCode, apiResponse.response?.data);

    if (!result.isSuccess && statusCode != 401 && !_handledStatusCodes.contains(statusCode)) {
      ApiChecker.checkApi(apiResponse);
    }

    _isPlacingOrder = false;
    notifyListeners();
    return result;
  }

  Future<WholesaleOrderPlaceResult> getDigitalPaymentOrder(String transactionRef) async {
    final ApiResponseModel apiResponse = await wholesaleCheckoutServiceInterface.getDigitalPaymentOrder(transactionRef);
    final int? statusCode = apiResponse.response?.statusCode;
    final WholesaleOrderPlaceResult result = WholesaleOrderPlaceResult.fromResponse(statusCode, apiResponse.response?.data);

    if (!result.isSuccess && statusCode != 404 && statusCode != 401) {
      ApiChecker.checkApi(apiResponse);
    }
    return result;
  }

  WholesaleOrderPlaceResult _handlePlacement(ApiResponseModel apiResponse) {
    final int? statusCode = apiResponse.response?.statusCode;
    final WholesaleOrderPlaceResult result = WholesaleOrderPlaceResult.fromResponse(statusCode, apiResponse.response?.data);

    if (!result.isSuccess && statusCode != 401 && !_handledStatusCodes.contains(statusCode)) {
      ApiChecker.checkApi(apiResponse);
    }
    return result;
  }

  void clearData() {
    orderNoteController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _isCheckCreateAccount = false;
    _cashChangesAmount = null;
  }

  @override
  void dispose() {
    orderNoteController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _disposeInputFieldControllers();
    super.dispose();
  }
}
