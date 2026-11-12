import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleClosedNowTagWidget extends StatelessWidget {
  const WholesaleClosedNowTagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(
            getTranslated('closed_now', context) ?? 'Closed Now',
            maxLines: 1,
            style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: color),
          ),
        ],
      ),
    );
  }
}
