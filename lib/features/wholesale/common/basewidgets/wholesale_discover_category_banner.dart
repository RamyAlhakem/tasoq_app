import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleDiscoverCategoryBanner extends StatelessWidget {
  final VoidCallback? onTap;
  final String titleKey;
  final String? titleFallback;

  const WholesaleDiscoverCategoryBanner({
    super.key,
    this.onTap,
    this.titleKey = 'discover_products_by_category',
    this.titleFallback,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE6ECFF), Color(0xFFFFEED9)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(
                children: [
                  CustomAssetImageWidget(Images.discoverCategoryIcon, width: 20, height: 20),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Text(
                      getTranslated(titleKey, context) ?? titleFallback ?? titleKey,
                      style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Transform.flip(
                    flipX: !isLtr,
                    child: CustomAssetImageWidget(Images.arrowIcon, width: 15, height: 11, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
