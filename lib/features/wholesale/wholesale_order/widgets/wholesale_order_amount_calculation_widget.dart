import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleOrderAmountCalculationWidget extends StatelessWidget {
  final WholesaleOrderDetailsModel orderDetails;
  const WholesaleOrderAmountCalculationWidget({super.key, required this.orderDetails});

  static const Map<String, String> _labelKeys = {
    'item price': 'item_price',
    'item discount': 'item_discount',
    'discount': 'discount',
    'sub total': 'sub_total',
    'subtotal': 'sub_total',
    'coupon discount': 'coupon_voucher',
    'coupon & voucher': 'coupon_voucher',
    'tax': 'tax',
    'vat': 'tax',
    'shipping fee': 'shipping_fee',
    'delivery fee': 'shipping_fee',
  };

  String _translateLabel(BuildContext context, String label) {
    final String? key = _labelKeys[label.trim().toLowerCase()];
    return key == null ? label : (getTranslated(key, context) ?? label);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      decoration: BoxDecoration(
        boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
        color: Theme.of(context).cardColor,
      ),
      child: Column(children: [
        Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(children: [
            Text(getTranslated('billing_summery', context)!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color)),
          ]),
        ),
        SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),

        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          color: Theme.of(context).cardColor,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (orderDetails.editedStatus == 1)
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(getTranslated('total_bill_has_been_updated_after', context) ?? '',
                  style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault)),
              ),

            for (final row in orderDetails.summaryRows.where((row) => !row.isTotal && row.quantity == null))
              WholesaleAmountWidget(
                title: _translateLabel(context, row.label),
                amount: '${row.isDeduction ? '- ' : ''}${PriceConverter.convertPrice(context, row.amount)}',
              ),

            SizedBox(height: 1, child: Divider(thickness: .300, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),

            WholesaleAmountWidget(
              isTitleBlack: true,
              title: getTranslated('total_payable', context),
              amount: PriceConverter.convertPrice(context, orderDetails.totalPayable),
            ),

            if ((orderDetails.latestEditHistory?.orderDueAmount ?? 0) > 0) ...[
              WholesaleAmountWidget(
                isTitleBlack: true,
                title: getTranslated('paid_amount', context),
                amount: PriceConverter.convertPrice(context, orderDetails.totalPayable - orderDetails.latestEditHistory!.orderDueAmount!),
              ),
              WholesaleAmountWidget(
                isTitleBlack: true,
                title: getTranslated('due', context),
                isPaid: orderDetails.latestEditHistory?.orderDuePaymentStatus == 'paid',
                titleStyle: textBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                  color: orderDetails.latestEditHistory?.orderDuePaymentStatus == 'paid' ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).colorScheme.error),
                amountStyle: textBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                  color: orderDetails.latestEditHistory?.orderDuePaymentStatus == 'paid' ? (isDark ? Theme.of(context).hintColor : Theme.of(context).primaryColor) : Theme.of(context).colorScheme.error),
                amount: PriceConverter.convertPrice(context, orderDetails.latestEditHistory!.orderDueAmount!),
              ),
            ],

            if ((orderDetails.latestEditHistory?.orderReturnAmount ?? 0) > 0)
              WholesaleAmountWidget(
                isTitleBlack: true,
                title: getTranslated('amount_to_return', context),
                isReturned: orderDetails.latestEditHistory?.orderReturnPaymentStatus == 'returned',
                titleStyle: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                amountStyle: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: isDark ? Theme.of(context).hintColor : Theme.of(context).colorScheme.primary),
                amount: PriceConverter.convertPrice(context, orderDetails.latestEditHistory!.orderReturnAmount!),
              ),
          ]),
        ),
      ]),
    );
  }
}
