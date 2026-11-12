import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/controllers/wholesale_checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/domain/models/wholesale_order_place_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/widgets/wholesale_offline_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleOfflinePaymentScreen extends StatefulWidget {
  final double payableAmount;
  final void Function(WholesaleOrderPlaceResult result) callback;
  const WholesaleOfflinePaymentScreen({super.key, required this.payableAmount, required this.callback});

  @override
  State<WholesaleOfflinePaymentScreen> createState() => _WholesaleOfflinePaymentScreenState();
}

class _WholesaleOfflinePaymentScreenState extends State<WholesaleOfflinePaymentScreen> {
  final TextEditingController paymentNoteController = TextEditingController();
  final GlobalKey<FormState> offlineFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    paymentNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('offline_payment', context)),
      body: Consumer<WholesaleCheckoutController>(
        builder: (context, checkoutProvider, _) {
          return CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Center(child: SizedBox(height: 100, child: Image.asset(Images.offlinePayment))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Text('${getTranslated('offline_payment_helper_text', context)}', textAlign: TextAlign.center, style: textRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault)),
                  ),
                  if (checkoutProvider.offlinePaymentModel?.offlineMethods?.isNotEmpty ?? false)
                    SizedBox(
                      height: 190,
                      child: RepaintBoundary(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: checkoutProvider.offlinePaymentModel!.offlineMethods!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                if (checkoutProvider.offlinePaymentModel?.offlineMethods?.isNotEmpty ?? false) {
                                  checkoutProvider.setOfflinePaymentMethodSelectedIndex(index);
                                }
                              },
                              child: WholesaleOfflineCardWidget(offlinePaymentModel: checkoutProvider.offlinePaymentModel!.offlineMethods![index], index: index),
                            );
                          },
                        ),
                      ),
                    ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Text('${getTranslated('amount', context)} : ${PriceConverter.convertPrice(context, widget.payableAmount)}', style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ),
                  ),
                  Text('${getTranslated('payment_info', context)}', style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  if (checkoutProvider.offlineMethodSelectedIndex >= 0)
                    Form(
                      key: offlineFormKey,
                      child: RepaintBoundary(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: checkoutProvider.keyList.length,
                          itemBuilder: (context, index) {
                            final methodInformation = checkoutProvider.offlinePaymentModel?.offlineMethods?[checkoutProvider.offlineMethodSelectedIndex].methodInformations?[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                              child: CustomTextFieldWidget(
                                controller: checkoutProvider.inputFieldControllerList[index],
                                required: methodInformation?.isRequired == 1,
                                labelText: '${methodInformation?.customerInput}'.replaceAll('_', ' ').wholesaleCapitalize(),
                                hintText: '${methodInformation?.customerPlaceholder}'.replaceAll('_', ' ').wholesaleCapitalize(),
                                validator: (value) {
                                  if (methodInformation?.isRequired == 1) {
                                    return ValidateCheck.validateEmptyText(value, '${methodInformation?.customerInput}'.replaceAll('_', ' ').wholesaleCapitalize());
                                  }
                                  return null;
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  CustomTextFieldWidget(controller: paymentNoteController, labelText: getTranslated('note', context), hintText: getTranslated('note', context)),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ]);
        },
      ),
      bottomNavigationBar: Consumer<WholesaleCheckoutController>(
        builder: (context, checkoutProvider, _) {
          return Consumer<WholesaleCartController>(
            builder: (context, cartController, _) {
              return Consumer<AddressController>(
                builder: (context, locationProvider, _) {
                  return Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: CustomButton(
                      isLoading: checkoutProvider.isPlacingOrder,
                      onTap: () async {
                        if (offlineFormKey.currentState?.validate() ?? false) {
                          final String? addressId = checkoutProvider.addressIndex != null
                              ? locationProvider.addressList![checkoutProvider.addressIndex!].id.toString()
                              : null;
                          final bool billingRequired = Provider.of<SplashController>(context, listen: false).configModel?.wholesaleConfig?.order?.billingAddress ?? false;
                          String? billingAddressId;
                          if (billingRequired) {
                            billingAddressId = !checkoutProvider.sameAsBilling
                                ? (checkoutProvider.billingAddressIndex != null ? locationProvider.addressList![checkoutProvider.billingAddressIndex!].id.toString() : null)
                                : addressId;
                          }

                          final WholesaleOrderPlaceResult result = await checkoutProvider.placeOfflinePayment(
                            addressId: addressId,
                            billingAddressId: billingAddressId,
                            couponCode: cartController.cart?.coupon?.code,
                            orderNote: checkoutProvider.orderNoteController.text.trim(),
                            paymentNote: paymentNoteController.text.trim(),
                          );
                          widget.callback(result);
                        }
                      },
                      buttonText: getTranslated('proceed', context),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
