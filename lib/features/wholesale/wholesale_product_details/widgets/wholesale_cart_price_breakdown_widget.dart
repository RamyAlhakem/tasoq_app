import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCartPriceBreakdownWidget extends StatelessWidget {
  final double discountAmount;
  final double taxAmount;

  const WholesaleCartPriceBreakdownWidget({super.key, this.discountAmount = 0, this.taxAmount = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.homePagePadding, Dimensions.paddingSizeDefault, Dimensions.homePagePadding, 0),
      child: Column(children: [
        if (discountAmount > 0)
          WholesaleCartPriceBreakdownRow(
            title: getTranslated('discount_on_product', context) ?? 'Discount on product',
            amount: '- ${PriceConverter.convertPrice(context, discountAmount)}',
          ),
        if (taxAmount > 0)
          WholesaleCartPriceBreakdownRow(
            title: getTranslated('tax', context) ?? 'Tax',
            amount: PriceConverter.convertPrice(context, taxAmount),
          ),
        Divider(height: Dimensions.paddingSizeSmall, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
      ]),
    );
  }
}

class WholesaleCartPriceBreakdownRow extends StatelessWidget {
  final String title;
  final String amount;

  const WholesaleCartPriceBreakdownRow({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
          child: Text(title, style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault)),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        CustomDirectionalityWidget(
          child: Text(amount, style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault)),
        ),
      ]),
    );
  }
}
