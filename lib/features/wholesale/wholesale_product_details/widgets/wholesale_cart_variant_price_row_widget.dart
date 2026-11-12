import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCartVariantPriceRowWidget extends StatelessWidget {
  final String variantKey;
  final double? price;
  final double? originalPrice;

  const WholesaleCartVariantPriceRowWidget({super.key, required this.variantKey, required this.price, this.originalPrice});

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = originalPrice != null && price != null && originalPrice! > price!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              variantKey,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          if (hasDiscount) ...[
            CustomDirectionalityWidget(
              child: Text(
                PriceConverter.convertPrice(context, originalPrice),
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor, decoration: TextDecoration.lineThrough, decorationColor: Theme.of(context).hintColor),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          ],
          CustomDirectionalityWidget(
            child: Text(
              price != null ? PriceConverter.convertPrice(context, price) : '',
              style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(
            getTranslated('per_piece', context) ?? '/Piece',
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }
}
