import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleDiscountBadgeWidget extends StatelessWidget {
  final double percentage;
  final double? radius;

  const WholesaleDiscountBadgeWidget({super.key, required this.percentage, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraExtraSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(radius ?? Dimensions.radiusSmall),
          bottomEnd: const Radius.circular(Dimensions.radiusDefault),
        ),
      ),
      child: CustomDirectionalityWidget(
        child: Text('-${percentage.toStringAsFixed(0)}%',
          style: titilliumBold.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: Dimensions.fontSizeExtraSmall,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
