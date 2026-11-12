import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCartTotalRowWidget extends StatelessWidget {
  final double total;
  final double? originalTotal;

  final bool isExpandable;
  final bool isExpanded;
  final VoidCallback onToggle;

  const WholesaleCartTotalRowWidget({
    super.key,
    required this.total,
    this.originalTotal,
    required this.isExpandable,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = originalTotal != null && originalTotal! > total;
    final Color? textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return InkWell(
      onTap: isExpandable ? onToggle : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeDefault),
        child: Row(children: [
          Text(getTranslated('total', context)!, style: robotoBold.copyWith(color: textColor, fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Dimensions.paddingSizeExtraSmall,
              children: [
                if (hasDiscount)
                  CustomDirectionalityWidget(
                    child: Text(
                      PriceConverter.convertPrice(context, originalTotal),
                      style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, decoration: TextDecoration.lineThrough, decorationColor: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),
                CustomDirectionalityWidget(
                  child: Text(PriceConverter.convertPrice(context, total), style: titilliumBold.copyWith(color: textColor, fontSize: Dimensions.fontSizeLarge)),
                ),
              ],
            ),
          ),

          if (isExpandable) ...[
            const SizedBox(width: Dimensions.paddingSizeSmall),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_up, color: textColor),
            ),
          ],
        ]),
      ),
    );
  }
}
