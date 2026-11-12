import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleBottomCartWidget extends StatefulWidget {
  final WholesaleProductDetailsModel? product;
  const WholesaleBottomCartWidget({super.key, required this.product});

  @override
  State<WholesaleBottomCartWidget> createState() => _WholesaleBottomCartWidgetState();
}

class _WholesaleBottomCartWidgetState extends State<WholesaleBottomCartWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final WholesaleCartController cartController = Provider.of<WholesaleCartController>(context, listen: false);
      if (cartController.cart == null && !cartController.isLoading) {
        cartController.getCart(guestId: wholesaleGuestId(context));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;
    return Container(
      height: 70,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: isDark ? null : [
          BoxShadow(color: Theme.of(context).hintColor, blurRadius: .5, spreadRadius: .1)
        ],
      ),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: Stack(children: [
            InkWell(
              onTap: () => RouterHelper.getWholesaleCartScreenRoute(action: RouteAction.push),
              child: Image.asset(Images.cartArrowDownImage, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyMedium?.color),
            ),
            Positioned.fill(
              child: Container(
                transform: Matrix4.translationValues(isLtr ? 10 : -10, -3, 0),
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Consumer<WholesaleCartController>(
                    builder: (context, cartController, _) {
                      final int count = cartController.cart?.cartCount ?? 0;
                      if (count <= 0) return const SizedBox.shrink();

                      return Container(
                        height: ResponsiveHelper.isTab(context) ? 25 : 20,
                        width: ResponsiveHelper.isTab(context) ? 25 : 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        child: Text(
                          count.toString(),
                          style: textRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: isDark ? Colors.white : Theme.of(context).highlightColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefaultAddress),

        Expanded(
          child: InkWell(
            onTap: () => WholesaleCartBottomSheetWidget.show(context, product: widget.product),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                getTranslated('add_to_cart', context)!,
                style: titilliumSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: isDark ? Colors.white
                      : Theme.of(context).highlightColor,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
