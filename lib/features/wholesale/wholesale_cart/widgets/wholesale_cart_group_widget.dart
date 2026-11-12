import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/helper/wholesale_cart_action_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_cart_checkbox_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_cart_footer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_cart_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleCartGroupWidget extends StatelessWidget {
  final WholesaleCartGroup group;
  const WholesaleCartGroupWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final bool hasShopShipping = group.isOrderWiseShipping && wholesaleIsSellerWiseShipping(context);
    final WholesaleCartShippingMethod? selectedMethod = group.selectedShippingMethod;

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WholesaleCartShopHeader(group: group, hasShopShipping: hasShopShipping),

          if (hasShopShipping && selectedMethod != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, 0),
              child: WholesaleCartShippingInfo(method: selectedMethod),
            ),

          ...group.items.map((row) => WholesaleCartItemWidget(row: row)),

          if (group.blockers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.homePagePadding, Dimensions.paddingSizeSmall, Dimensions.homePagePadding, 0),
              child: WholesaleCartBlockerList(blockers: group.blockers),
            ),
        ],
      ),
    );
  }
}

class WholesaleCartShopHeader extends StatelessWidget {
  final WholesaleCartGroup group;
  final bool hasShopShipping;

  const WholesaleCartShopHeader({super.key, required this.group, required this.hasShopShipping});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final WholesaleCartShop? shop = group.shop;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: Dimensions.homePagePadding),
      child: Row(children: [
        WholesaleCartCheckboxWidget(
          value: group.isGroupChecked,
          onChanged: group.cartGroupId == null
              ? null
              : (_) => wholesaleToggleCartSelection(context, cartGroupId: group.cartGroupId, isChecked: !group.isGroupChecked),
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: CustomImageWidget(image: shop?.imageUrl ?? '', height: 24, width: 24),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: Row(children: [
            Flexible(
              child: Text(
                shop?.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              child: Text('(${group.items.length})', style: textBold.copyWith(color: isDark ? Theme.of(context).hintColor : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
            ),

            if (shop?.isClosed ?? false)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(
                  getTranslated('closed', context) ?? 'Closed',
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error),
                ),
              ),
          ]),
        ),

        if (hasShopShipping && group.cartGroupId != null)
          SizedBox(width: 180, child: WholesaleCartShopShippingPicker(group: group))
        else
          const SizedBox(width: Dimensions.homePagePadding),
      ]),
    );
  }
}

class WholesaleCartShopShippingPicker extends StatelessWidget {
  final WholesaleCartGroup group;
  const WholesaleCartShopShippingPicker({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final WholesaleCartShippingMethod? selected = group.selectedShippingMethod;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: () => wholesaleChooseShippingMethod(
          context,
          cartGroupIds: [group.cartGroupId!],
          methods: group.shippingMethods,
          selectedMethodId: group.selectedShippingMethodId,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.15) : Theme.of(context).primaryColor.withValues(alpha: 0.15)),
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: Row(children: [
            if (selected == null) ...[
              SizedBox(width: 15, height: 15, child: Image.asset(Images.delivery, color: Theme.of(context).textTheme.bodyLarge?.color)),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            ],
            Expanded(
              child: Text(
                selected?.title ?? getTranslated('choose_shipping', context)!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: selected == null
                    ? textRegular.copyWith(color: Theme.of(context).textTheme.bodySmall?.color)
                    : titilliumSemiBold.copyWith(color: Theme.of(context).hintColor),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
          ]),
        ),
      ),
    );
  }
}

class WholesaleCartShippingInfo extends StatelessWidget {
  final WholesaleCartShippingMethod method;
  const WholesaleCartShippingInfo({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    final TextStyle style = textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall);

    return Wrap(spacing: Dimensions.paddingSizeSmall, children: [
      CustomDirectionalityWidget(
        child: Text('${getTranslated('shipping_cost', context) ?? ''} : ${PriceConverter.convertPrice(context, method.cost)}', style: style),
      ),
      if ((method.duration ?? '').isNotEmpty) Text('${getTranslated('shipping_time', context) ?? ''} : ${method.duration}', style: style),
    ]);
  }
}
