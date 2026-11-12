import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class WholesaleCampaignInfoCardWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final String? discountRange;
  final String? manufacturerCount;
  final String? productCount;
  final DateTime? validTill;

  const WholesaleCampaignInfoCardWidget({
    super.key,
    this.title,
    this.description,
    this.discountRange,
    this.manufacturerCount,
    this.productCount,
    this.validTill,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final Color bodyColor = Theme.of(context).textTheme.bodyLarge?.color ?? Theme.of(context).hintColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: bodyColor),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            if ((description ?? '').isNotEmpty)
              ReadMoreText(
                description!,
                trimMode: TrimMode.Line,
                trimLines: 2,
                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                colorClickableText: isDark ? Colors.white : Theme.of(context).primaryColor,
                trimCollapsedText: getTranslated('see_more', context) ?? 'See More',
                trimExpandedText: getTranslated('see_less', context) ?? 'See Less',
                moreStyle: titilliumBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: isDark ? Colors.white : Theme.of(context).primaryColor),
                lessStyle: titilliumBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: isDark ? Colors.white : Theme.of(context).primaryColor),
              ),

            if ((discountRange ?? '').isNotEmpty) ...[
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(
                children: [
                  Text('${getTranslated('discount_limit', context) ?? 'Discount Limit'}  ',
                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleMedium?.color)),
                  CustomDirectionalityWidget(
                    child: Text(discountRange!,
                        style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: bodyColor)),
                  ),
                ],
              ),
            ],

            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(
              children: [
                if (manufacturerCount != null)
                  _MetaItem(
                    iconAsset: Images.campaignPersonIcon,
                    label: '$manufacturerCount ${getTranslated('manufacturers', context) ?? 'Manufacturers'}',
                  ),
                if (manufacturerCount != null && productCount != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Container(width: 1, height: 14, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                if (productCount != null)
                  _MetaItem(
                    iconAsset: Images.campaignProductIcon,
                    label: '$productCount ${getTranslated('products', context) ?? 'Products'}',
                  ),
              ],
            ),

            if (validTill != null) ...[
              const SizedBox(height: Dimensions.paddingSizeSmall),
              _MetaItem(
                iconAsset: Images.campaignCalendarIcon,
                label: '${getTranslated('valid_till', context) ?? 'Valid Till'} - ${DateConverter.monthDayYearTime(validTill!)}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String iconAsset;
  final String label;
  const _MetaItem({required this.iconAsset, required this.label});

  @override
  Widget build(BuildContext context) {
    final Color hintColor = Theme.of(context).hintColor;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconAsset,
          height: Dimensions.iconSizeSmall,
          width: Dimensions.iconSizeSmall,
          colorFilter: ColorFilter.mode(hintColor, BlendMode.srcIn),
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Text(label, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
      ],
    );
  }
}
