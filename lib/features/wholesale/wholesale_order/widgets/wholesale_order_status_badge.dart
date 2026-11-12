import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/enum/wholesale_order_status.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleOrderStatusBadge extends StatelessWidget {
  final WholesaleOrderStatus status;
  const WholesaleOrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraExtraSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: status.color(context).withValues(alpha: .1),
      ),
      child: Text(
        getTranslated(status.label, context) ?? status.label,
        style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: status.color(context)),
      ),
    );
  }
}
