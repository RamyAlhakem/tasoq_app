import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_order_refresh_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/controllers/wholesale_checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/domain/models/wholesale_order_place_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_order_place_bottomsheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/animated_custom_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/order_place_dialog_widget.dart';
import 'package:provider/provider.dart';

class WholesaleDigitalPaymentScreen extends StatefulWidget {
  final String url;
  const WholesaleDigitalPaymentScreen({super.key, required this.url});

  @override
  State<WholesaleDigitalPaymentScreen> createState() => _WholesaleDigitalPaymentScreenState();
}

class _WholesaleDigitalPaymentScreenState extends State<WholesaleDigitalPaymentScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  bool _isConfirming = false;
  bool _canRedirect = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initWebView();
      _isInitialized = true;
    }
  }

  void _initWebView() {
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).cardColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) setState(() => _isLoading = false);
          },
          onPageStarted: _checkRedirect,
          onPageFinished: _checkRedirect,
          onWebResourceError: (e) => debugPrint('WebView error: ${e.description}'),
          onNavigationRequest: (NavigationRequest req) {
            final Uri? uri = Uri.tryParse(req.url);
            if (uri != null && !['http', 'https', 'file', 'chrome', 'data', 'javascript', 'about'].contains(uri.scheme)) {
              launchUrl(uri, mode: LaunchMode.externalApplication);
              return NavigationDecision.prevent;
            }
            if (_isRedirectUrl(req.url)) {
              _checkRedirect(req.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  bool _isRedirectUrl(String url) {
    return ((url.contains('success') && url.contains('token')) || url.contains('fail') || url.contains('cancel')) && url.contains(AppConstants.baseUrl);
  }

  void _checkRedirect(String url) {
    if (_canRedirect && _isRedirectUrl(url)) {
      _canRedirect = false;
      final bool isSuccess = url.contains('success');
      final bool isFailed = url.contains('fail');
      final String? transactionRef = _extractTransactionRef(url);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isSuccess) {
          _confirmPlacedOrder(transactionRef);
        } else {
          _showFailureDialog(isFailed: isFailed);
        }
      });
    }
  }

  String? _extractTransactionRef(String url) {
    try {
      final Uri uri = Uri.parse(url);
      for (final String key in const ['transaction_reference', 'transaction_ref']) {
        final String? value = uri.queryParameters[key];
        if (value != null && value.isNotEmpty) return value;
      }

      final String? rawToken = RegExp(r'(?:^|&)token=([^&]+)').firstMatch(uri.query)?.group(1);
      if (rawToken == null || rawToken.isEmpty) return null;

      final String decoded = utf8.decode(base64.decode(base64.normalize(Uri.decodeComponent(rawToken))));
      for (final String pair in decoded.split('&')) {
        final int separatorIndex = pair.indexOf('=');
        if (separatorIndex > 0 && pair.substring(0, separatorIndex) == 'transaction_reference') {
          final String value = pair.substring(separatorIndex + 1);
          return value.isEmpty ? null : value;
        }
      }
    } catch (e) {
      debugPrint('Transaction ref extraction error: $e');
    }
    return null;
  }

  Future<void> _confirmPlacedOrder(String? transactionRef) async {
    if (transactionRef == null || transactionRef.isEmpty) {
      _showNotConfirmedDialog();
      return;
    }

    setState(() => _isConfirming = true);
    final WholesaleCheckoutController checkoutController = Provider.of<WholesaleCheckoutController>(context, listen: false);

    const List<int> backoffSeconds = [2, 2, 3, 3, 5];
    WholesaleOrderPlaceResult result = await checkoutController.getDigitalPaymentOrder(transactionRef);

    for (final int delay in backoffSeconds) {
      if (result.isSuccess || !mounted) break;
      await Future.delayed(Duration(seconds: delay));
      if (!mounted) return;
      result = await checkoutController.getDigitalPaymentOrder(transactionRef);
    }

    if (!mounted) return;
    setState(() => _isConfirming = false);

    if (result.isSuccess) {
      _showSuccess(result.order?.orderIdsLabel);
    } else {
      _showNotConfirmedDialog();
    }
  }

  void _showSuccess(String? orderIdsLabel) {
    refreshWholesaleDataAfterOrder(context);
    RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page: 'home');
    Future.delayed(const Duration(milliseconds: 300), () {
      if (Get.context == null) return;
      showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: Get.context!,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => WholesaleOrderPlaceBottomSheetWidget(
          orderID: orderIdsLabel,
          title: getTranslated('order_placed', Get.context!) ?? '',
          description: getTranslated('your_order_placed', Get.context!) ?? '',
        ),
      );
    });
  }

  void _showNotConfirmedDialog() {
    _popIfPossible();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (Get.context == null) return;
      showAnimatedDialog(
        Get.context!,
        OrderPlaceDialogWidget(
          icon: Icons.error_outline,
          title: getTranslated('order_placement_failed', Get.context!) ?? getTranslated('payment_failed', Get.context!),
          description: getTranslated('paid_order_not_found', Get.context!) ?? getTranslated('your_payment_failed', Get.context!),
          isFailed: true,
        ),
        dismissible: true,
        willFlip: true,
      );
    });
  }

  void _showFailureDialog({required bool isFailed}) {
    _popIfPossible();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (Get.context == null) return;
      showAnimatedDialog(
        Get.context!,
        OrderPlaceDialogWidget(
          icon: Icons.clear,
          title: getTranslated(isFailed ? 'payment_failed' : 'payment_cancelled', Get.context!),
          description: getTranslated(isFailed ? 'your_payment_failed' : 'your_payment_cancelled', Get.context!),
          isFailed: true,
        ),
        dismissible: true,
        willFlip: true,
      );
    });
  }

  void _popIfPossible() {
    if (Navigator.canPop(Get.context!)) {
      Navigator.of(Get.context!).pop();
    }
  }

  Future<void> _onBackPressed() async {
    if (!_canRedirect) return;
    _canRedirect = false;
    _popIfPossible();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _onBackPressed(),
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          title: Text(getTranslated('payment', context) ?? 'Payment'),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18), onPressed: _onBackPressed),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _webViewController),
                  if (_isLoading || _isConfirming)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                          if (_isConfirming) ...[
                            const SizedBox(height: 12),
                            Text(getTranslated('confirming_your_order', context) ?? getTranslated('please_wait', context) ?? ''),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: bottomPadding),
          ],
        ),
      ),
    );
  }
}
