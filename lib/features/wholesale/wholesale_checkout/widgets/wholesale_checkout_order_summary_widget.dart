import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleCheckoutOrderSummaryWidget extends StatelessWidget {
  final WholesaleCartSummary summary;

  const WholesaleCheckoutOrderSummaryWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  0, Dimensions.paddingSizeDefault,
                  0, Dimensions.paddingSizeSmall,
                ),
                child: Text(
                  getTranslated('order_summary', context) ?? '',
                  style: textMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),

              WholesaleAmountWidget(
                title: getTranslated('item_price', context),
                amount: PriceConverter.convertPrice(context, summary.subtotal),
              ),
              WholesaleAmountWidget(
                title: getTranslated('discount', context),
                amount: PriceConverter.convertPrice(context, summary.discount),
              ),
              WholesaleAmountWidget(
                title: getTranslated('sub_total', context),
                amount: PriceConverter.convertPrice(
                    context, summary.discountedSubtotal),
              ),
              if (summary.couponDiscount > 0)
                WholesaleAmountWidget(
                  title: getTranslated('coupon_voucher', context),
                  amount: PriceConverter.convertPrice(context, summary.couponDiscount),
                ),
              WholesaleAmountWidget(
                title: getTranslated('tax', context),
                amount: PriceConverter.convertPrice(context, summary.tax),
              ),
              WholesaleAmountWidget(
                title: getTranslated('shipping_fee', context),
                amount: PriceConverter.convertPrice(context, summary.shipping),
              ),
              Divider(height: Dimensions.paddingSizeDefault, color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.3) : Theme.of(context).hintColor),
              WholesaleAmountWidget(
                fontSize: Dimensions.fontSizeLarge,
                isTitleBlack: true,
                title: getTranslated('total_payable', context),
                amount: PriceConverter.convertPrice(context, summary.total),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],
          ),
        ),
      ],
    );
  }
}
