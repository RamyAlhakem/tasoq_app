import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/widgets/wholesale_coupon_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleCouponApplyWidget extends StatelessWidget {
  const WholesaleCouponApplyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Consumer<WholesaleCartController>(
      builder: (context, cartController, _) {
        final coupon = cartController.cart?.coupon;

        return Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 3, blurRadius: 3)],
            ),
            child: coupon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomAssetImageWidget(Images.addCouponIcon, height: 20, width: 20),
                            const SizedBox(width: Dimensions.paddingSizeDefault),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                Text(
                                  getTranslated('coupon_applied', context) ?? '',
                                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                      child: Text(
                                        coupon.code ?? '',
                                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.titleMedium?.color),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                      child: CustomDirectionalityWidget(
                                        child: Text(
                                          '(-${PriceConverter.convertPrice(context, coupon.discount)} off)',
                                          style: textBold.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                              ],
                            ),
                          ],
                        ),
                        cartController.isCouponUpdating
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : InkWell(
                                onTap: () => cartController.removeCoupon(guestId: wholesaleGuestId(context)),
                                child: Icon(Icons.clear, size: 20, color: Theme.of(context).colorScheme.error),
                              ),
                      ],
                    ),
                  )
                : InkWell(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (c) => const WholesaleCouponBottomSheetWidget(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomAssetImageWidget(Images.addCouponIcon, height: 20, width: 20),
                              const SizedBox(width: Dimensions.paddingSizeSmall),
                              Text(
                                getTranslated('add_coupon', context) ?? '',
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                              ),
                            ],
                          ),
                          Text(
                            getTranslated('add_more', context) ?? '',
                            style: textMedium.copyWith(color: isDark ? Colors.white : Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
