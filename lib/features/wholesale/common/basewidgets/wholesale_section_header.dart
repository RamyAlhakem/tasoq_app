import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleSectionHeader extends StatelessWidget {
  final String titleKey;
  final String? titleFallback;
  final VoidCallback? onViewAll;
  final Color? viewAllColor;
  final bool showViewAll;

  const WholesaleSectionHeader({super.key, required this.titleKey, this.titleFallback, this.onViewAll, this.viewAllColor, this.showViewAll = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            getTranslated(titleKey, context) ?? titleFallback ?? titleKey,
            style: titilliumBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          if (showViewAll)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                getTranslated('view_all', context) ?? 'View All',
                style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  fontWeight: FontWeight.w400,
                  color: viewAllColor ?? Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
