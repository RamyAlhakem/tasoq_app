import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/helper/wholesale_cart_action_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleCartFooterWidget extends StatelessWidget {
  final double total;

  final VoidCallback? onCheckout;

  final Widget? shippingPicker;

  final bool isUpdatingPrices;

  const WholesaleCartFooterWidget({
    super.key,
    required this.total,
    required this.onCheckout,
    this.shippingPicker,
    this.isUpdatingPrices = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeDefault),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (shippingPicker != null) ...[
              shippingPicker!,
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(getTranslated('total_price', context)!,
                          style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                      CustomDirectionalityWidget(
                        child: Text(
                          PriceConverter.convertPrice(context, total),
                          style: titilliumBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: isUpdatingPrices ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                SizedBox(
                  width: 170,
                  child: CustomButton(
                    radius: 6,
                    buttonText: getTranslated('proceed_to_checkout', context),
                    onTap: isUpdatingPrices ? () {} : onCheckout,
                    backgroundColor: isUpdatingPrices ? Theme.of(context).hintColor : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WholesaleCartWideShippingPicker extends StatelessWidget {
  final List<WholesaleCartGroup> groups;
  const WholesaleCartWideShippingPicker({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final List<WholesaleCartShippingMethod> methods = groups.first.shippingMethods;

    final int? selectedId = groups.every((group) => group.selectedShippingMethodId == groups.first.selectedShippingMethodId)
        ? groups.first.selectedShippingMethodId
        : null;
    final WholesaleCartShippingMethod? selected = selectedId == null ? null : groups.first.selectedShippingMethod;

    return InkWell(
      onTap: () => wholesaleChooseShippingMethod(
        context,
        cartGroupIds: groups.map((group) => group.cartGroupId!).toList(),
        methods: methods,
        selectedMethodId: selectedId,
      ),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: isDark ? Theme.of(context).hintColor.withValues(alpha: .4) : Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(children: [
          SizedBox(width: 15, height: 15, child: Image.asset(Images.delivery, color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(
            getTranslated('choose_shipping_method', context)!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Text(
              selected?.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: titilliumSemiBold.copyWith(color: Theme.of(context).hintColor),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white : Theme.of(context).primaryColor),
        ]),
      ),
    );
  }
}

class WholesaleCartBlockerList extends StatelessWidget {
  final List<String> blockers;
  const WholesaleCartBlockerList({super.key, required this.blockers});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: blockers
          .map((blocker) => Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline, size: 14, color: color),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Expanded(child: Text(blocker, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: color))),
                ]),
              ))
          .toList(),
    );
  }
}
