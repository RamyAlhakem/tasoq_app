import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/controllers/wholesale_checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_payment_method_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

class WholesaleChoosePaymentWidget extends StatelessWidget {
  final bool onlyDigital;
  const WholesaleChoosePaymentWidget({super.key, this.onlyDigital = false});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Consumer<WholesaleCheckoutController>(
      builder: (context, checkoutController, _) {
        return Consumer<SplashController>(
          builder: (context, configProvider, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 3, blurRadius: 3)],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                    CustomAssetImageWidget(Images.paymentMethodSelectIcon, height: 15, width: 15),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(
                      child: Text(
                        getTranslated('payment_method', context) ?? '',
                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                    InkWell(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (c) => WholesalePaymentMethodBottomSheetWidget(onlyDigital: onlyDigital),
                      ),
                      child: SizedBox(width: 20, child: Image.asset(Images.edit, scale: 3)),
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                if (checkoutController.isCODChecked || checkoutController.isOfflineChecked || checkoutController.isWalletChecked || (checkoutController.paymentMethodIndex != -1))
                  SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),

                if (checkoutController.isCODChecked || checkoutController.isOfflineChecked || checkoutController.isWalletChecked || (checkoutController.paymentMethodIndex != -1))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        (checkoutController.paymentMethodIndex != -1)
                            ? Row(children: [
                                SizedBox(
                                  width: 40,
                                  child: CustomImageWidget(
                                    image: '${configProvider.configModel?.paymentMethodImagePath}/${configProvider.configModel!.paymentMethods![checkoutController.paymentMethodIndex].additionalDatas!.gatewayImage ?? ''}',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                  child: Text(
                                    configProvider.configModel!.paymentMethods![checkoutController.paymentMethodIndex].additionalDatas!.gatewayTitle ?? '',
                                    style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                                  ),
                                ),
                              ])
                            : checkoutController.isCODChecked
                                ? Text(getTranslated('cash_on_delivery', context) ?? '', style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color))
                                : checkoutController.isOfflineChecked
                                    ? Text(getTranslated('offline_payment', context) ?? '', style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color))
                                    : checkoutController.isWalletChecked
                                        ? Text(getTranslated('wallet_payment', context) ?? '', style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color))
                                        : InkWell(
                                            onTap: () => showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (c) => WholesalePaymentMethodBottomSheetWidget(onlyDigital: onlyDigital),
                                            ),
                                            child: Row(children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeSmall),
                                                child: Icon(Icons.add_circle_outline_outlined, size: 20, color: isDark ? Colors.white : Theme.of(context).primaryColor),
                                              ),
                                              Text(
                                                '${getTranslated('add_payment_method', context)}',
                                                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                                                maxLines: 3,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ]),
                                          ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ],
                    ),
                  ),
              ]),
            );
          },
        );
      },
    );
  }
}
