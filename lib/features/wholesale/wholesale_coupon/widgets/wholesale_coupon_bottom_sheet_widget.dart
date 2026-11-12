import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/controllers/wholesale_coupon_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/widgets/wholesale_coupon_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/widgets/wholesale_coupon_list_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleCouponBottomSheetWidget extends StatefulWidget {
  const WholesaleCouponBottomSheetWidget({super.key});

  @override
  State<WholesaleCouponBottomSheetWidget> createState() => _WholesaleCouponBottomSheetWidgetState();
}

class _WholesaleCouponBottomSheetWidgetState extends State<WholesaleCouponBottomSheetWidget> {
  final TextEditingController couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleCouponController>(context, listen: false).getApplicableCoupons(reload: true);
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  void _applyCode(String code) {
    if (code.isEmpty) return;
    Provider.of<WholesaleCartController>(context, listen: false).applyCoupon(code, guestId: wholesaleGuestId(context), overlayContext: context).then((isSuccess) {
      if (isSuccess && mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Consumer<WholesaleCouponController>(
      builder: (context, wholesaleCouponProvider, _) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75, minHeight: MediaQuery.of(context).size.height * 0.5),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: isDark ? Theme.of(context).cardColor : Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeDefault), topRight: Radius.circular(Dimensions.paddingSizeDefault)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                child: Center(
                  child: Container(
                    width: 35,
                    height: 4,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault), color: Theme.of(context).hintColor.withValues(alpha: .5)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<WholesaleCartController>(
                  builder: (context, cartController, _) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .15) : Theme.of(context).primaryColor.withValues(alpha: .15)),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))),
                            child: TextFormField(
                              controller: couponController,
                              enabled: !cartController.isCouponUpdating,
                              decoration: InputDecoration(
                                helperStyle: textRegular.copyWith(),
                                prefixIcon: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: Image.asset(Images.eCoupon)),
                                suffixIcon: cartController.isCouponUpdating
                                    ? const Padding(
                                        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                                      )
                                    : InkWell(
                                        onTap: () => _applyCode(couponController.text.trim()),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                          child: Container(
                                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall))),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                                              child: Text('${getTranslated('apply', context)}', style: textMedium.copyWith(color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                      ),
                                hintText: getTranslated('enter_coupon', context),
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                suffixIconConstraints: const BoxConstraints(maxHeight: 40),
                                hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor),
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .15) : Theme.of(context).primaryColor.withValues(alpha: .125), width: 0.125)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 0.125)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .15) : Theme.of(context).primaryColor.withValues(alpha: .125), width: 0.125)),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Text('${getTranslated('available_promo', context)}', style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              ),
              wholesaleCouponProvider.applicableCouponList != null
                  ? wholesaleCouponProvider.applicableCouponList!.isNotEmpty
                      ? Expanded(
                          child: CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return WholesaleCouponItemWidget(
                                        coupon: wholesaleCouponProvider.applicableCouponList![index],
                                        fromCheckout: true,
                                        onCopy: (String? code) {
                                          couponController.text = code ?? '';
                                        },
                                      );
                                    },
                                    childCount: wholesaleCouponProvider.applicableCouponList!.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const NoInternetOrDataScreenWidget(isNoInternet: false)
                  : const Expanded(child: WholesaleCouponListShimmer(fromCheckout: true)),
            ],
          ),
        );
      },
    );
  }
}
