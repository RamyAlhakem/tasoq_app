import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:provider/provider.dart';

/// Handles 403 responses telling that the wholesale / auction module was
/// turned off on the server while the app was using it.
class FeatureDisabledHandler {
  static const String wholesaleDisabledCode = 'wholesale_feature_disabled_403';
  static const String auctionDisabledCode = 'auction_feature_disabled_403';

  static bool _isHandling = false;
  static String? _handledMessage;

  static bool isFeatureDisabled(dynamic responseData) {
    final String? code = ApiEnvelope.identicalCode(responseData);
    return code == wholesaleDisabledCode || code == auctionDisabledCode;
  }

  /// Most repositories drop the response when building their error model, so
  /// the code is often unavailable here; while a disable is being handled, the
  /// same server message identifies the rest of that batch.
  static bool shouldSuppressError(dynamic responseData, String? errorMessage) {
    if (isFeatureDisabled(responseData)) return true;
    return _isHandling && (errorMessage?.isNotEmpty ?? false) && errorMessage == _handledMessage;
  }

  static Future<void> handle(String? message) async {
    if (_isHandling) return;
    _isHandling = true;
    _handledMessage = message;

    final BuildContext? context = Get.context;
    if (context == null) {
      _isHandling = false;
      return;
    }

    try {
      final SplashController splashController = Provider.of<SplashController>(context, listen: false);

      // Closes any dialog or bottom sheet left over the disabled module, such
      // as the demo promotional popup shown on entering it.
      Get.navigator?.popUntil((route) => route is! PopupRoute);

      showCustomSnackBarWidget(message, context, snackBarType: SnackBarType.error);

      // Refreshes config and notifies listeners, so the module entry points update.
      await splashController.initConfig(context, null, null);

      splashController.selectMainTab(0);
      RouterHelper.getDashboardRoute(action: RouteAction.pushNamedAndRemoveUntil);
    } finally {
      // The parallel batch of calls that triggered this can still have
      // trailing 403s in flight after this cycle's work is done; keep the
      // lock a bit longer so they're dropped instead of re-triggering a
      // second redirect + toast.
      Future.delayed(const Duration(seconds: 3), () => _isHandling = false);
    }
  }
}
