import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/animated_custom_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_order_refresh_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/controllers/wholesale_checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/domain/models/wholesale_order_place_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_checkout_condition_checkbox.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_checkout_order_note_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_choose_payment_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_order_place_bottomsheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_payment_method_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_shipping_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_checkout_order_summary_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_wallet_payment_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/widgets/wholesale_coupon_apply_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleCheckoutScreen extends StatefulWidget {
  final List<WholesaleCartItemModel> cartItems;
  final bool showBackButton;

  const WholesaleCheckoutScreen(
      {super.key, required this.cartItems, this.showBackButton = true});

  @override
  State<WholesaleCheckoutScreen> createState() => _WholesaleCheckoutScreenState();
}

class _WholesaleCheckoutScreenState extends State<WholesaleCheckoutScreen> {
  final FocusNode _orderNoteNode = FocusNode();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<AddressController>(context, listen: false).getAddressList();
    Provider.of<WholesaleCheckoutController>(context, listen: false)
        .resetPaymentMethod();

    final SplashController splashController =
        Provider.of<SplashController>(context, listen: false);
    if (splashController.configModel?.offlinePayment != null) {
      Provider.of<WholesaleCheckoutController>(context, listen: false)
          .getOfflinePaymentList();
    }
    if (Provider.of<WholesaleCheckoutController>(context, listen: false)
        .isAcceptTerms) {
      Provider.of<WholesaleCheckoutController>(context, listen: false)
          .toggleTermsCheck(isUpdate: false);
    }
    Provider.of<WholesaleCheckoutController>(context, listen: false).clearData();
  }

  @override
  void dispose() {
    _orderNoteNode.dispose();
    super.dispose();
  }

  bool get _billingAddressRequired =>
      Provider.of<SplashController>(context, listen: false).configModel?.wholesaleConfig?.order?.billingAddress ?? false;

  void _handleProceed(WholesaleCheckoutController orderProvider,
      AddressController locationProvider) {
    final bool isLoggedIn =
        Provider.of<AuthController>(context, listen: false).isLoggedIn();

    if (orderProvider.addressIndex == null) {
      RouterHelper.getSavedAddressListRoute(fromGuest: !isLoggedIn, forWholesale: true);
      showCustomSnackBarWidget(
          getTranslated('select_a_shipping_address', context), Get.context!,
          snackBarType: SnackBarType.warning);
      return;
    }

    if (orderProvider.isCheckCreateAccount &&
        !(_passwordFormKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_billingAddressRequired &&
        !orderProvider.sameAsBilling &&
        orderProvider.billingAddressIndex == null) {
      RouterHelper.getSavedBillingAddressListRoute(fromGuest: !isLoggedIn, forWholesale: true);
      showCustomSnackBarWidget(
          getTranslated('select_a_billing_address', context), Get.context!,
          snackBarType: SnackBarType.warning);
      return;
    }

    final WholesaleCartController cartController =
        Provider.of<WholesaleCartController>(context, listen: false);

    if (orderProvider.paymentMethodIndex != -1) {
      _createDigitalPaymentLink(orderProvider, locationProvider, cartController);
    } else if (orderProvider.isCODChecked) {
      _placeCashOnDelivery(orderProvider, locationProvider, cartController);
    } else if (orderProvider.isOfflineChecked) {
      RouterHelper.getWholesaleOfflinePaymentScreen(
        payableAmount: cartController.cart?.summary.total ?? 0,
        callback: _handlePlacementResult,
      );
    } else if (orderProvider.isWalletChecked) {
      _showWalletConfirm(orderProvider, locationProvider, cartController);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (c) => const WholesalePaymentMethodBottomSheetWidget(onlyDigital: false),
      );
    }
  }

  (String?, String?) _resolveAddressIds(
      WholesaleCheckoutController orderProvider, AddressController locationProvider) {
    final String? addressId = orderProvider.addressIndex != null
        ? locationProvider.addressList![orderProvider.addressIndex!].id.toString()
        : null;

    String? billingAddressId;
    if (_billingAddressRequired) {
      billingAddressId = !orderProvider.sameAsBilling
          ? (orderProvider.billingAddressIndex != null
              ? locationProvider.addressList![orderProvider.billingAddressIndex!].id.toString()
              : null)
          : addressId;
    }
    return (addressId, billingAddressId);
  }

  Future<void> _placeCashOnDelivery(WholesaleCheckoutController orderProvider,
      AddressController locationProvider, WholesaleCartController cartController) async {
    final (addressId, billingAddressId) = _resolveAddressIds(orderProvider, locationProvider);
    final WholesaleOrderPlaceResult result = await orderProvider.placeCashOnDelivery(
      addressId: addressId,
      billingAddressId: billingAddressId,
      couponCode: cartController.cart?.coupon?.code,
      orderNote: orderProvider.orderNoteController.text.trim(),
    );
    _handlePlacementResult(result);
  }

  void _showWalletConfirm(WholesaleCheckoutController orderProvider,
      AddressController locationProvider, WholesaleCartController cartController) {
    final double payableAmount = cartController.cart?.summary.total ?? 0;
    final double currentBalance =
        Provider.of<ProfileController>(context, listen: false).balance ?? 0;

    showAnimatedDialog(
      context,
      WholesaleWalletPaymentWidget(
        currentBalance: currentBalance,
        orderAmount: payableAmount,
        onTap: () async {
          if (currentBalance < payableAmount) {
            showCustomSnackBarWidget(
                getTranslated('insufficient_balance', context), context,
                snackBarType: SnackBarType.warning);
            return;
          }
          Navigator.pop(context);
          final (addressId, billingAddressId) = _resolveAddressIds(orderProvider, locationProvider);
          final WholesaleOrderPlaceResult result = await orderProvider.placeWalletPayment(
            addressId: addressId,
            billingAddressId: billingAddressId,
            couponCode: cartController.cart?.coupon?.code,
            orderNote: orderProvider.orderNoteController.text.trim(),
          );
          _handlePlacementResult(result);
        },
      ),
      dismissible: false,
      willFlip: true,
    );
  }

  Future<void> _createDigitalPaymentLink(WholesaleCheckoutController orderProvider,
      AddressController locationProvider, WholesaleCartController cartController) async {
    final (addressId, billingAddressId) = _resolveAddressIds(orderProvider, locationProvider);
    final WholesaleDigitalPaymentLinkResult result = await orderProvider.createDigitalPaymentLink(
      paymentMethod: orderProvider.selectedDigitalPaymentMethodName,
      paymentPlatform: 'app',
      addressId: addressId,
      billingAddressId: billingAddressId,
      couponCode: cartController.cart?.coupon?.code,
      orderNote: orderProvider.orderNoteController.text.trim(),
    );
    if (!mounted) return;

    if (result.isSuccess) {
      RouterHelper.getWholesaleDigitalPaymentScreenRoute(
          url: result.redirectLink!, action: RouteAction.pushReplacement);
    } else {
      showCustomSnackBarWidget(
          result.message ?? getTranslated('payment_method_not_properly_configured', context) ?? '',
          context,
          snackBarType: SnackBarType.error);
    }
  }

  void _handlePlacementResult(WholesaleOrderPlaceResult result) {
    if (!mounted) return;

    if (result.isSuccess) {
      refreshWholesaleDataAfterOrder(context);
      RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page: 'home');

      Future.delayed(const Duration(milliseconds: 300), () {
        showModalBottomSheet(
          isDismissible: false,
          enableDrag: false,
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => WholesaleOrderPlaceBottomSheetWidget(
            orderID: result.order?.orderIdsLabel,
            title: getTranslated('order_placed', Get.context!) ?? '',
            description: getTranslated('your_order_placed', Get.context!) ?? '',
          ),
        );
      });
    } else {
      showCustomSnackBarWidget(
          result.message ?? getTranslated('something_went_wrong', context) ?? '',
          context,
          snackBarType: SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final bool billingAddress = _billingAddressRequired;

    return Scaffold(
      appBar: CustomAppBar(
          title: getTranslated('checkout', context),
          isBackButtonExist: widget.showBackButton),
      bottomNavigationBar: Consumer<AddressController>(
        builder: (context, locationProvider, _) {
          return Consumer<WholesaleCheckoutController>(
            builder: (context, orderProvider, _) {
              return orderProvider.isPlacingOrder
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 30, height: 30, child: CircularProgressIndicator())
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: isDark ? null : [
                          BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 3, blurRadius: 3),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const WholesaleCheckoutConditionCheckBox(),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomButton(
                            onTap: !orderProvider.isAcceptTerms ? null
                                : () => _handleProceed(orderProvider, locationProvider),
                            buttonText: getTranslated('proceed', context),
                          ),
                        ],
                      ),
                    );
            },
          );
        },
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Padding(
            padding:
                const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            child: WholesaleShippingDetailsWidget(
              billingAddress: billingAddress,
              passwordFormKey: _passwordFormKey,
            ),
          ),
          if (Provider.of<AuthController>(context, listen: false).isLoggedIn())
            const Padding(padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              child: WholesaleCouponApplyWidget(),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: WholesaleChoosePaymentWidget(onlyDigital: false),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Consumer<WholesaleCartController>(
            builder: (context, cartController, _) =>
                WholesaleCheckoutOrderSummaryWidget(
              summary: cartController.cart?.summary ?? const WholesaleCartSummary(),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Consumer<WholesaleCheckoutController>(
            builder: (context, orderProvider, _) => WholesaleCheckoutOrderNoteWidget(
              controller: orderProvider.orderNoteController,
              focusNode: _orderNoteNode,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ],
      ),
    );
  }
}
