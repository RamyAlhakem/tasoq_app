import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_add_to_cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/services/wholesale_cart_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';

class WholesaleCartController extends ChangeNotifier {
  final WholesaleCartServiceInterface wholesaleCartServiceInterface;

  WholesaleCartController({required this.wholesaleCartServiceInterface});

  WholesaleCartListModel? _cart;
  WholesaleCartListModel? get cart => _cart;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _couponCode;

  bool _isCouponUpdating = false;
  bool get isCouponUpdating => _isCouponUpdating;

  bool _isAdding = false;
  bool get isAdding => _isAdding;

  bool _isBuyingNow = false;
  bool get isBuyingNow => _isBuyingNow;

  Future<void> getCart({int? guestId, String? couponCode, bool reload = false}) async {
    if (couponCode != null) _couponCode = couponCode;

    if (_cart == null || reload) {
      _isLoading = true;
      notifyListeners();
    }

    final ApiResponseModel apiResponse = await wholesaleCartServiceInterface.getCart(guestId: guestId, couponCode: _couponCode);
    final int? statusCode = apiResponse.response?.statusCode;

    if (statusCode == 200) {
      _applyCart(apiResponse);
    } else if (statusCode == 401) {
      _cart = const WholesaleCartListModel();
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateSelection({int? cartId, String? cartGroupId, required bool isChecked, int? guestId}) async {
    final ApiResponseModel apiResponse = await wholesaleCartServiceInterface.updateSelection(
      cartId: cartId,
      cartGroupId: cartGroupId,
      isChecked: isChecked,
      guestId: guestId,
      couponCode: _couponCode,
    );
    return _handleMutation(apiResponse, guestId: guestId);
  }

  final Set<int> _removingIds = {};
  bool isRemoving(int? cartId) => _removingIds.contains(cartId);

  Future<bool> removeItem({required int cartId, int? guestId}) async {
    if (!_removingIds.add(cartId)) return false;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCartServiceInterface.removeItem(
      cartId: cartId,
      guestId: guestId,
      couponCode: _couponCode,
    );
    _removingIds.remove(cartId);

    final bool isSuccess = await _handleMutation(apiResponse, guestId: guestId);
    if (!isSuccess) notifyListeners();
    return isSuccess;
  }

  final Map<int, int> _pendingQuantities = {};

  final Map<int, String?> _quantityErrors = {};
  final Map<int, DebounceHelper> _quantityDebouncers = {};

  final Map<int, int> _quantitySequence = {};

  int quantityFor(WholesaleCartRow row) => (row.id != null ? _pendingQuantities[row.id] : null) ?? row.quantity;

  String? quantityErrorFor(int? cartId) => cartId == null ? null : _quantityErrors[cartId];

  final Map<int, int> _inFlightQuantityRequests = {};

  bool isUpdatingQuantity(int? cartId) => cartId != null && (_inFlightQuantityRequests[cartId] ?? 0) > 0;

  bool get isUpdatingAnyQuantity => _inFlightQuantityRequests.values.any((count) => count > 0);

  void setItemQuantity(WholesaleCartRow row, int quantity, {required bool immediate, int? guestId}) {
    final int? cartId = row.id;
    if (cartId == null) return;

    final int clamped = _clampQuantity(quantity, row.minimumQuantity, row.maximumQuantity);
    if (clamped == quantityFor(row)) return;

    _pendingQuantities[cartId] = clamped;
    _quantityErrors.remove(cartId);
    notifyListeners();

    if (immediate) {
      _quantityDebouncers[cartId]?.dispose();
      _commitQuantity(cartId, clamped, guestId);
    } else {
      (_quantityDebouncers[cartId] ??= DebounceHelper(milliseconds: 400)).run(() => _commitQuantity(cartId, clamped, guestId));
    }
  }

  int _clampQuantity(int quantity, int minimumQuantity, int? maximumQuantity) {
    if (quantity < minimumQuantity) return minimumQuantity;
    if (maximumQuantity != null && quantity > maximumQuantity) return maximumQuantity;
    return quantity;
  }

  Future<void> _commitQuantity(int cartId, int quantity, int? guestId) async {
    final int mySequence = (_quantitySequence[cartId] ?? 0) + 1;
    _quantitySequence[cartId] = mySequence;

    _inFlightQuantityRequests[cartId] = (_inFlightQuantityRequests[cartId] ?? 0) + 1;
    notifyListeners();

    try {
      final ApiResponseModel apiResponse = await wholesaleCartServiceInterface.updateItemQuantity(
        cartId: cartId,
        quantity: quantity,
        guestId: guestId,
        couponCode: _couponCode,
      );

      if (_quantitySequence[cartId] != mySequence) return;

      final int? statusCode = apiResponse.response?.statusCode;

      if (statusCode == 200) {
        _applyCart(apiResponse);
        _pendingQuantities.remove(cartId);
        _quantityErrors.remove(cartId);
        return;
      }

      if (statusCode == 422) {
        final dynamic content = apiResponse.response?.data is Map ? apiResponse.response?.data['content'] : null;
        final dynamic data = content is Map ? content['data'] : null;
        final int? restoredQty = data is Map ? _toInt(data['qty']) : null;

        if (restoredQty != null) {
          _pendingQuantities[cartId] = restoredQty;
        } else {
          _pendingQuantities.remove(cartId);
        }
        _quantityErrors[cartId] = _errorMessage(apiResponse.response?.data);
        return;
      }

      if (statusCode == 404) {
        _pendingQuantities.remove(cartId);
        _quantityErrors.remove(cartId);
        showCustomSnackBarWidget(_errorMessage(apiResponse.response?.data), Get.context, snackBarType: SnackBarType.error);
        await getCart(guestId: guestId);
        return;
      }

      if (statusCode != 401) {
        ApiChecker.checkApi(apiResponse);
      }
      _pendingQuantities.remove(cartId);
    } finally {
      final int remaining = (_inFlightQuantityRequests[cartId] ?? 1) - 1;
      if (remaining <= 0) {
        _inFlightQuantityRequests.remove(cartId);
      } else {
        _inFlightQuantityRequests[cartId] = remaining;
      }
      notifyListeners();
    }
  }

  int? _toInt(dynamic value) => value is int ? value : int.tryParse('${value ?? ''}');

  @override
  void dispose() {
    for (final DebounceHelper debouncer in _quantityDebouncers.values) {
      debouncer.dispose();
    }
    super.dispose();
  }

  Future<bool> setShippingMethod({required List<String> cartGroupIds, required int shippingMethodId, int? guestId}) async {
    for (final String cartGroupId in cartGroupIds) {
      final ApiResponseModel apiResponse = await wholesaleCartServiceInterface.setShippingMethod(
        cartGroupId: cartGroupId,
        shippingMethodId: shippingMethodId,
        guestId: guestId,
        couponCode: _couponCode,
      );
      if (!await _handleMutation(apiResponse, guestId: guestId)) return false;
    }
    return true;
  }

  Future<bool> applyCoupon(String code, {int? guestId, BuildContext? overlayContext}) async {
    _isCouponUpdating = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCartServiceInterface.applyCoupon(code: code, guestId: guestId);
    final int? statusCode = apiResponse.response?.statusCode;
    bool isSuccess = false;

    if (statusCode == 200) {
      _couponCode = code;
      _applyCart(apiResponse);
      isSuccess = true;
    } else if (statusCode == 404 || statusCode == 422) {
      final String? message = _errorMessage(apiResponse.response?.data);
      if (overlayContext != null && overlayContext.mounted) {
        showOverlaySnackBar(overlayContext, message, snackBarType: SnackBarType.error);
      } else {
        showCustomSnackBarWidget(message, Get.context, snackBarType: SnackBarType.error);
      }
    } else if (statusCode != 401) {
      ApiChecker.checkApi(apiResponse, useOverlay: overlayContext != null && overlayContext.mounted, overlayContext: overlayContext);
    }

    _isCouponUpdating = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> removeCoupon({int? guestId}) async {
    _isCouponUpdating = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCartServiceInterface.removeCoupon(guestId: guestId);
    final bool isSuccess = await _handleMutation(apiResponse, guestId: guestId);
    if (isSuccess) _couponCode = null;

    _isCouponUpdating = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> _handleMutation(ApiResponseModel apiResponse, {int? guestId}) async {
    final int? statusCode = apiResponse.response?.statusCode;

    if (statusCode == 200) {
      _applyCart(apiResponse);
      notifyListeners();
      return true;
    }

    if (statusCode == 404 || statusCode == 422) {
      showCustomSnackBarWidget(_errorMessage(apiResponse.response?.data), Get.context, snackBarType: SnackBarType.error);
      if (statusCode == 404) await getCart(guestId: guestId);
    } else if (statusCode != 401) {
      ApiChecker.checkApi(apiResponse);
    }
    return false;
  }

  void _applyCart(ApiResponseModel apiResponse) {
    final dynamic content = apiResponse.response?.data is Map ? apiResponse.response?.data['content'] : null;
    final dynamic data = content is Map ? content['data'] : null;
    _cart = data is Map ? WholesaleCartListModel.fromJson(Map<String, dynamic>.from(data)) : const WholesaleCartListModel();
    if (_cart?.coupon == null) _couponCode = null;
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

  Future<WholesaleAddToCartResult> addToCart({
    required int productId,
    required int quantity,
    Map<String, String> variation = const {},
    bool buyNow = false,
    int? shippingMethodId,
    int? guestId,
  }) async {
    if (_isAdding || _isBuyingNow) return const WholesaleAddToCartResult();

    _setBusy(buyNow, true);

    final ApiResponseModel apiResponse = await wholesaleCartServiceInterface.addItem(
      productId: productId,
      quantity: quantity,
      variation: variation,
      buyNow: buyNow,
      shippingMethodId: shippingMethodId,
      guestId: guestId,
    );

    final int? statusCode = apiResponse.response?.statusCode;
    final WholesaleAddToCartResult result = WholesaleAddToCartResult.fromResponse(statusCode, apiResponse.response?.data);

    if (statusCode != 200 && !const {401, 404, 422}.contains(statusCode)) {
      ApiChecker.checkApi(apiResponse);
    }

    _setBusy(buyNow, false);
    return result;
  }

  void _setBusy(bool buyNow, bool value) {
    if (buyNow) {
      _isBuyingNow = value;
    } else {
      _isAdding = value;
    }
    notifyListeners();
  }

  bool _isRequestingRestock = false;
  bool get isRequestingRestock => _isRequestingRestock;

  Future<bool> requestRestock({required int productId, Map<String, String> variation = const {}}) async {
    _isRequestingRestock = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCartServiceInterface.requestRestock(productId: productId, variation: variation);
    final int? statusCode = apiResponse.response?.statusCode;
    final dynamic data = apiResponse.response?.data;
    final bool alreadyRequested = statusCode == 409;
    bool isSuccess = false;

    if (statusCode == 200 || alreadyRequested) {
      final dynamic content = data is Map ? data['content'] : null;
      final dynamic topic = content is Map ? content['topic'] : null;
      if (topic is String && topic.isNotEmpty) {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
      }
      showCustomSnackBarWidget(_errorMessage(data), Get.context, snackBarType: alreadyRequested ? SnackBarType.error : SnackBarType.success);
      isSuccess = true;
    } else if (statusCode == 401 || statusCode == 403 || statusCode == 404 || statusCode == 422) {
      showCustomSnackBarWidget(_errorMessage(data), Get.context, snackBarType: SnackBarType.error);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isRequestingRestock = false;
    notifyListeners();
    return isSuccess;
  }

  bool _isDeletingRestockRequest = false;
  bool get isDeletingRestockRequest => _isDeletingRestockRequest;

  Future<bool> deleteRestockRequest({int? id, bool all = false}) async {
    _isDeletingRestockRequest = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCartServiceInterface.deleteRestockRequest(id: id, all: all);
    final int? statusCode = apiResponse.response?.statusCode;
    final dynamic data = apiResponse.response?.data;
    bool isSuccess = false;

    if (statusCode == 200) {
      showCustomSnackBarWidget(_errorMessage(data), Get.context, snackBarType: SnackBarType.success);
      isSuccess = true;
    } else if (statusCode == 401 || statusCode == 404 || statusCode == 422) {
      showCustomSnackBarWidget(_errorMessage(data), Get.context, snackBarType: SnackBarType.error);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isDeletingRestockRequest = false;
    notifyListeners();
    return isSuccess;
  }
}
