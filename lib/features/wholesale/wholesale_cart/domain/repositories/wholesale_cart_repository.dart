import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/repositories/wholesale_cart_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class WholesaleCartRepository implements WholesaleCartRepositoryInterface {
  final DioClient? dioClient;
  WholesaleCartRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> addItem({
    required int productId,
    required int quantity,
    Map<String, String> variation = const {},
    bool buyNow = false,
    int? shippingMethodId,
    int? guestId,
  }) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleCartItemUri,
        data: {
          'product_id': productId,

          'quantity': quantity,
          if (variation.isNotEmpty) 'variation': variation,
          'buy_now': buyNow,
          if (shippingMethodId != null) 'shipping_method_id': shippingMethodId,
          if (guestId != null) 'guest_id': guestId,
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> getCart({int? guestId, String? couponCode}) async {
    try {
      final response = await dioClient!.get(
        AppConstants.wholesaleCartUri,
        queryParameters: _ownerParams(guestId, couponCode),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> updateSelection({int? cartId, String? cartGroupId, required bool isChecked, int? guestId, String? couponCode}) async {
    try {
      final response = await dioClient!.put(
        AppConstants.wholesaleCartSelectionUri,
        queryParameters: _ownerParams(guestId, couponCode),
        data: {
          if (cartId != null) 'cart_id': cartId else 'cart_group_id': cartGroupId,
          'is_checked': isChecked,
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> removeItem({required int cartId, int? guestId, String? couponCode}) async {
    try {
      final response = await dioClient!.delete(
        '${AppConstants.wholesaleCartItemUri}/$cartId',
        queryParameters: _ownerParams(guestId, couponCode),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> updateItemQuantity({required int cartId, required int quantity, int? guestId, String? couponCode}) async {
    try {
      final response = await dioClient!.put(
        '${AppConstants.wholesaleCartItemUri}/$cartId',
        queryParameters: _ownerParams(guestId, couponCode),
        data: {'quantity': quantity},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> setShippingMethod({required String cartGroupId, required int shippingMethodId, int? guestId, String? couponCode}) async {
    try {
      final response = await dioClient!.put(
        AppConstants.wholesaleCartShippingMethodUri,
        queryParameters: _ownerParams(guestId, couponCode),
        data: {'cart_group_id': cartGroupId, 'shipping_method_id': shippingMethodId},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> applyCoupon({required String code, int? guestId}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleCartCouponUri,
        queryParameters: _ownerParams(guestId, null),
        data: {'code': code},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> removeCoupon({int? guestId}) async {
    try {
      final response = await dioClient!.delete(
        AppConstants.wholesaleCartCouponUri,
        queryParameters: _ownerParams(guestId, null),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> requestRestock({required int productId, Map<String, String> variation = const {}}) async {
    try {
      final response = await dioClient!.post(
        AppConstants.wholesaleRestockRequestUri,
        data: {
          'id': productId,
          if (variation.isNotEmpty) 'variation': variation,
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> deleteRestockRequest({int? id, bool all = false}) async {
    try {
      final response = await dioClient!.delete(
        AppConstants.wholesaleRestockRequestUri,
        queryParameters: all ? {'type': 'all'} : {'id': id},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  Map<String, dynamic> _ownerParams(int? guestId, String? couponCode) => {
        if (guestId != null) 'guest_id': guestId,
        if (couponCode != null && couponCode.isNotEmpty) 'coupon_code': couponCode,
      };

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }
}
