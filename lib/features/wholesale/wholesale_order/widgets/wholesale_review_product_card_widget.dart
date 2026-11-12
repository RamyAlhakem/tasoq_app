import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';

class WholesaleReviewProductCardWidget extends StatelessWidget {
  final WholesaleOrderProductItemModel product;
  const WholesaleReviewProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        color: Theme.of(context).cardColor,
        boxShadow: isDark ? null : [BoxShadow(color: Colors.grey.withValues(alpha: .2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: .125),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            border: Border.all(width: 1, color: Theme.of(context).primaryColor.withValues(alpha: .125)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            child: CustomImageWidget(image: product.image, width: 70, height: 70, fit: BoxFit.scaleDown),
          ),
        ),
        const SizedBox(width: Dimensions.marginSizeDefault),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
            const SizedBox(height: Dimensions.marginSizeExtraSmall),

            Row(children: [
              Text('${getTranslated('price', context)}: ', style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: 14)),
              CustomDirectionalityWidget(
                child: Text(PriceConverter.convertPrice(context, product.price), maxLines: 1,
                  style: titilliumSemiBold.copyWith(color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyMedium?.color, fontSize: 16)),
              ),
            ]),
            const SizedBox(height: Dimensions.marginSizeExtraSmall),

            Text('${getTranslated('qty', context)}: ${product.qty}', style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: 14)),

            if (product.variation != null && product.variation!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${getTranslated('variations', context)}: ', style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null)),
                  Flexible(child: Text(product.variation!, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor))),
                ]),
              ),
          ]),
        ),
      ]),
    );
  }
}
