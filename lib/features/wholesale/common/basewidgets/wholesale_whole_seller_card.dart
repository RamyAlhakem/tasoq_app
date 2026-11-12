import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleWholeSellerCard extends StatelessWidget {
  final WholesaleSeller seller;
  final VoidCallback? onTap;
  final VoidCallback? onChat;

  const WholesaleWholeSellerCard({
    super.key,
    required this.seller,
    this.onTap,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15)),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      image: seller.shopLogoUrl?.path ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onChat,
                  borderRadius: BorderRadius.circular(30),
                  child: CustomAssetImageWidget(
                    Images.chatIcon,
                    width: 18, height: 18,
                  )
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(
              children: [
                Flexible(
                  child: Text(
                    seller.shopName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: titilliumBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                if (seller.isVerified) ...[
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  CustomAssetImageWidget(Images.varifiedBadge, width: 18, height: 18),
                ],
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: Dimensions.iconSizeSmall),
                const SizedBox(width: 2),
                Text(
                  (seller.rating ?? 0).toStringAsFixed(1),
                  style: titilliumBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraExtraSmall),
                Text(
                  '(${seller.reviewCount ?? 0} ${getTranslated('reviews', context) ?? 'Reviews'})',
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Text(
                    '•',
                    style: titilliumRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                ),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${getTranslated('avg_moq', context) ?? 'Avg MOQ'} ',
                          style: titilliumRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        TextSpan(
                          text: seller.hasMoa ? PriceConverter.convertPrice(context, seller.avgMoq!) : 'N/A',
                          style: titilliumBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
