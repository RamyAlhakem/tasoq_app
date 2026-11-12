import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/controllers/wholesale_checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_create_account_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleShippingDetailsWidget extends StatelessWidget {
  final bool billingAddress;
  final GlobalKey<FormState> passwordFormKey;

  const WholesaleShippingDetailsWidget({super.key, required this.billingAddress, required this.passwordFormKey});

  @override
  Widget build(BuildContext context) {
    final bool isGuestMode = !Provider.of<AuthController>(context, listen: false).isLoggedIn();

    return Consumer<WholesaleCheckoutController>(
      builder: (context, checkoutController, _) {
        return Consumer<AddressController>(
          builder: (context, locationProvider, _) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _WholesaleDeliveryAddressCard(isGuestMode: isGuestMode),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if (isGuestMode) WholesaleCreateAccountWidget(formKey: passwordFormKey),
              if (isGuestMode) const SizedBox(height: Dimensions.paddingSizeSmall),

              if (billingAddress)
                _WholesaleBillingAddressCard(isGuestMode: isGuestMode),
            ]);
          },
        );
      },
    );
  }
}

class _WholesaleDeliveryAddressCard extends StatelessWidget {
  final bool isGuestMode;
  const _WholesaleDeliveryAddressCard({required this.isGuestMode});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WholesaleCheckoutController, AddressController>(
      builder: (context, checkoutController, locationProvider, _) {
        final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
        final bool hasAddress = checkoutController.addressIndex != null &&
            (locationProvider.addressList?.isNotEmpty ?? false);

        return Container(
          decoration: BoxDecoration(
            boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.3), spreadRadius: 2, blurRadius: 10)],
            color: Theme.of(context).cardColor,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Row(children: [
                    CustomAssetImageWidget(Images.deliveryTo, height: 20, width: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Text(
                        getTranslated('delivery_to', context) ?? '',
                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                  ]),
                ),
                InkWell(
                  onTap: () => RouterHelper.getSavedAddressListRoute(fromGuest: isGuestMode, forWholesale: true),
                  child: SizedBox(width: 20, child: Image.asset(Images.edit, scale: 3, color: isDark ? Colors.white : Theme.of(context).primaryColor)),
                ),
              ]),
            ),
            SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            hasAddress
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Expanded(
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('${getTranslated('name', context)} : ',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium?.color)),
                            Expanded(
                              child: Text(
                                locationProvider.addressList![checkoutController.addressIndex!].contactPersonName ?? '',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color, overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                            ),
                          ]),
                        ),
                        Expanded(
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('${getTranslated('phone', context)} : ',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium?.color)),
                            Expanded(
                              child: Text(
                                locationProvider.addressList![checkoutController.addressIndex!].phone ?? '',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color, overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                            ),
                          ]),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.07),
                        ),
                        child: Row(children: [
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          CustomAssetImageWidget(Images.savedAddressLocationIcon, height: 20, width: 20),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Text('${locationProvider.addressList![checkoutController.addressIndex!].addressType ?? ''}: ',
                              style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: isDark ? Theme.of(context).hintColor : Theme.of(context).primaryColor)),
                          Expanded(
                            child: Text(
                              locationProvider.addressList![checkoutController.addressIndex!].address ?? '',
                              style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color, overflow: TextOverflow.ellipsis),
                              maxLines: 1,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ]),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      CustomAssetImageWidget(Images.deliveryTo, height: 30, width: 30, color: Theme.of(context).hintColor),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text(getTranslated('please_set_your_delivery_info', context) ?? '',
                          style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor)),
                    ]),
                  ),
          ]),
        );
      },
    );
  }
}

class _WholesaleBillingAddressCard extends StatelessWidget {
  final bool isGuestMode;
  const _WholesaleBillingAddressCard({required this.isGuestMode});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WholesaleCheckoutController, AddressController>(
      builder: (context, checkoutController, locationProvider, _) {
        final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
        final bool hasBillingAddress = checkoutController.billingAddressIndex != null &&
            (locationProvider.addressList?.isNotEmpty ?? false);

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 3, blurRadius: 3)],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: Row(children: [
                    CustomAssetImageWidget(Images.billingTo, height: 20, width: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Text(
                        getTranslated('billing_to', context) ?? '',
                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                  ]),
                ),

                Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.07),
                    ),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () => checkoutController.setSameAsBilling(),
                      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDark
                                    ? (checkoutController.sameAsBilling ? Colors.white : Theme.of(context).hintColor.withValues(alpha: .5))
                                    : Theme.of(context).primaryColor.withValues(alpha: .75),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(2),
                              color: checkoutController.sameAsBilling ? (isDark ? Colors.white : Theme.of(context).primaryColor) : Theme.of(context).cardColor,
                            ),
                            child: Icon(CupertinoIcons.checkmark_alt, size: 15,
                                color: checkoutController.sameAsBilling ? Theme.of(context).cardColor : Colors.transparent),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          child: Text(getTranslated('same_as_delivery', context) ?? '',
                              style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                        ),
                      ]),
                    ),
                  ),

                if (!checkoutController.sameAsBilling) const SizedBox(width: Dimensions.paddingSizeSmall),
                if (!checkoutController.sameAsBilling)
                  InkWell(
                    onTap: () => RouterHelper.getSavedBillingAddressListRoute(fromGuest: isGuestMode, forWholesale: true),
                    child: SizedBox(width: 20, child: Image.asset(Images.edit, scale: 3, color: isDark ? Colors.white : Theme.of(context).primaryColor)),
                  ),
              ]),
            ),

            if (!checkoutController.sameAsBilling) ...[
              SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              hasBillingAddress
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('${getTranslated('name', context)} : ',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodySmall?.color)),
                            Text(locationProvider.addressList![checkoutController.billingAddressIndex!].contactPersonName ?? '',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          ]),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('${getTranslated('phone', context)} : ',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodySmall?.color)),
                            Text(locationProvider.addressList![checkoutController.billingAddressIndex!].phone ?? '',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          ]),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.07),
                          ),
                          child: Row(children: [
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            CustomAssetImageWidget(Images.savedAddressLocationIcon, height: 20, width: 20),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text('${locationProvider.addressList![checkoutController.billingAddressIndex!].addressType ?? ''}: ',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: isDark ? Theme.of(context).hintColor : Theme.of(context).primaryColor)),
                            Expanded(
                              child: Text(
                                locationProvider.addressList![checkoutController.billingAddressIndex!].address ?? '',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color, overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ]),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        CustomAssetImageWidget(Images.deliveryTo, height: 30, width: 30, color: Theme.of(context).hintColor),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text(getTranslated('please_set_your_billing_info', context) ?? '',
                            style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor)),
                      ]),
                    ),
            ],
          ]),
        );
      },
    );
  }
}
