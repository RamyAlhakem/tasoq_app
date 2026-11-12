import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/domain/models/wholesale_coupon_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/domain/services/wholesale_coupon_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class WholesaleCouponController extends ChangeNotifier {
  final WholesaleCouponServiceInterface wholesaleCouponServiceInterface;
  WholesaleCouponController({required this.wholesaleCouponServiceInterface});

  List<WholesaleCoupon>? couponList;
  WholesaleCouponResponseModel? couponResponseModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getCouponList({int offset = 1, bool reload = false}) async {
    if (_isLoading) return;
    if (offset == 1 && couponList != null && !reload) return;

    _isLoading = true;
    if (offset == 1) {
      couponList = null;
      notifyListeners();
    }

    final ApiResponseModel apiResponse = await wholesaleCouponServiceInterface.getCouponList(offset: offset);

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleCouponResponseModel parsed = WholesaleCouponResponseModel.fromJson(apiResponse.response!.data);

      couponList = offset == 1 ? (parsed.coupons ?? []) : [...?couponList, ...?parsed.coupons];
      couponResponseModel = parsed;
    } else {
      couponList ??= [];
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }


  List<WholesaleCoupon>? shopCouponList;
  WholesaleCouponResponseModel? shopCouponResponseModel;

  bool shopNotFound = false;

  bool _isShopLoading = false;
  bool get isShopLoading => _isShopLoading;

  Future<void> getShopCouponList(String slug, {int offset = 1, bool reload = false}) async {
    if (_isShopLoading) return;
    if (offset == 1 && shopCouponList != null && !reload) return;

    _isShopLoading = true;
    if (offset == 1) {
      shopCouponList = null;
      shopNotFound = false;
      notifyListeners();
    }

    final ApiResponseModel apiResponse = await wholesaleCouponServiceInterface.getShopCouponList(slug, offset: offset);

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleCouponResponseModel parsed = WholesaleCouponResponseModel.fromJson(apiResponse.response!.data);

      shopCouponList = offset == 1 ? (parsed.coupons ?? []) : [...?shopCouponList, ...?parsed.coupons];
      shopCouponResponseModel = parsed;
    } else if (apiResponse.response?.statusCode == 404) {
      shopNotFound = true;
      shopCouponList = [];
    } else {
      shopCouponList ??= [];
      ApiChecker.checkApi(apiResponse);
    }

    _isShopLoading = false;
    notifyListeners();
  }

  void resetShopCoupons() {
    shopCouponList = null;
    shopCouponResponseModel = null;
    shopNotFound = false;
  }

  List<WholesaleCoupon>? applicableCouponList;

  bool _isApplicableLoading = false;
  bool get isApplicableLoading => _isApplicableLoading;

  Future<void> getApplicableCoupons({bool reload = false}) async {
    if (_isApplicableLoading) return;
    if (applicableCouponList != null && !reload) return;

    _isApplicableLoading = true;
    applicableCouponList = null;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCouponServiceInterface.getApplicableCoupons();

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleCouponResponseModel parsed = WholesaleCouponResponseModel.fromJson(apiResponse.response!.data);
      applicableCouponList = parsed.coupons ?? [];
    } else {
      applicableCouponList = [];
      ApiChecker.checkApi(apiResponse);
    }

    _isApplicableLoading = false;
    notifyListeners();
  }

  void resetApplicableCoupons() {
    applicableCouponList = null;
  }
}
