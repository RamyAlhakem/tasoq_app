import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleOrderPaymentWidget extends StatelessWidget {
  final String paymentStatus;
  final String paymentMethod;
  const WholesaleOrderPaymentWidget({super.key, required this.paymentStatus, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    final bool isPaid = paymentStatus.toLowerCase() == 'paid';
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      decoration: BoxDecoration(
        boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
        color: Theme.of(context).cardColor,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Text(getTranslated('payment_info', context) ?? '',
            style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
        ),
        SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(getTranslated('payment_status_title', context) ?? '',
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium?.color)),
              Text(
                isPaid ? getTranslated('paid', context) ?? '' : getTranslated('unpaid', context) ?? '',
                style: titilliumSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: isPaid ? Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.error,
                ),
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text( getTranslated('payment_method', context) ?? '',
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium?.color)),
              Text( paymentMethod, style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
            ]),
          ]),
        ),


      ]),
    );
  }
}
