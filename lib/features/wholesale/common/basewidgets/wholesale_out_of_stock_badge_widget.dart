import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleOutOfStockBadgeWidget extends StatelessWidget {
  final BorderRadiusGeometry borderRadius;

  const WholesaleOutOfStockBadgeWidget({
    super.key,
    this.borderRadius = const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.4),
            borderRadius: borderRadius,
          ),
          child: Text(
            getTranslated('out_of_stock', context) ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
          ),
        ),
      ),
    );
  }
}
