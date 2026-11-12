import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleOrderPaymentInfoWidget extends StatelessWidget {
  final WholesaleOrderDetailsModel orderDetails;
  const WholesaleOrderPaymentInfoWidget({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      decoration: BoxDecoration(
        boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Column(children: [
          const SizedBox(height: Dimensions.paddingSizeDefault),

          if (orderDetails.verificationCode != null && orderDetails.verificationCode!.isNotEmpty) ...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(getTranslated('order_verification_code', context) ?? '', style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)),
              Text(
                orderDetails.verificationCode!,
                style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault),
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],


          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(getTranslated('order_date_details', context) ?? '', style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)),
            Text(
              DateConverter.localDateToIsoStringAMPMOrder(orderDetails.orderDate),
              textDirection: TextDirection.ltr,
              style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(getTranslated('order_type', context) ?? '', style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.1) : Theme.of(context).primaryColor.withValues(alpha: 0.10),
              ),
              padding: EdgeInsets.symmetric( horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraExtraSmall),
              child: Text(
                orderDetails.orderTypeLabel,
                style: textMedium.copyWith(color: isDark ? Theme.of(context).hintColor : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
              ),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ]),
      ),
    );
  }
}
