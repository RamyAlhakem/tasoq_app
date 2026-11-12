import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_discount_badge_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_out_of_stock_badge_widget.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleMostDemandedProductCard extends StatelessWidget {
  final WholesaleProduct product;
  final VoidCallback? onTap;

  const WholesaleMostDemandedProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  void _openDetails(BuildContext context) {
    final String? slug = product.slug;
    if (slug == null || slug.isEmpty) return;
    RouterHelper.getWholesaleProductDetailsRoute(slug: slug, action: RouteAction.push);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final bool hasDiscount = (product.discountedPercentage ?? 0) > 0;
    final double minDiscounted = product.minDiscountedPrice ?? product.minPrice ?? 0;
    final double maxDiscounted = product.maxDiscountedPrice ?? product.maxPrice ?? 0;
    final bool isRange = minDiscounted != maxDiscounted;

    final String currentMinPrice = PriceConverter.convertPrice(context, minDiscounted);
    final String currentMaxPrice = isRange ? PriceConverter.convertPrice(context, maxDiscounted) : '';
    final String originalMinPrice = hasDiscount ? PriceConverter.convertPrice(context, product.minPrice) : '';
    final String originalMaxPrice = hasDiscount && isRange ? PriceConverter.convertPrice(context, product.maxPrice) : '';

    final int? moq = product.minimumOrderQuantity;
    final int? previousMoq = product.previousMinimumOrderQuantity;
    final bool hasReducedMoq = previousMoq != null && moq != null && previousMoq > moq;

    return InkWell(
      onTap: onTap ?? () => _openDetails(context),
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2)),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImage(context, hasDiscount),
              Container(width: 2, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
              Expanded(child: _buildContent(context, hasDiscount, isRange, currentMinPrice, currentMaxPrice, originalMinPrice, originalMaxPrice, moq, hasReducedMoq ? previousMoq : null)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, bool hasDiscount) {
    return SizedBox(
      width: 108,
      height: 107,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadiusDirectional.horizontal(start: Radius.circular(Dimensions.radiusDefault)),
            child: CustomImageWidget(
              image: product.thumbnailFullUrl?.path ?? '',
              fit: BoxFit.cover,
            ),
          ),

          if (product.currentStock != null && product.currentStock! <= 0)
            const WholesaleOutOfStockBadgeWidget(
              borderRadius: BorderRadiusDirectional.only(bottomStart: Radius.circular(Dimensions.radiusDefault)),
            ),

          if (hasDiscount)
            PositionedDirectional(
              top: 0,
              start: 0,
              child: WholesaleDiscountBadgeWidget(percentage: product.discountedPercentage!,radius: Dimensions.radiusDefault,),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool hasDiscount,
    bool isRange,
    String currentMinPrice,
    String currentMaxPrice,
    String originalMinPrice,
    String originalMaxPrice,
    int? moq,
    int? previousMoq,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeSmall,
        vertical: Dimensions.paddingSizeSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            product.productName ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: titilliumRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),

          if (hasDiscount) ...[
            CustomDirectionalityWidget(
              child: Text(
                isRange ? '$originalMinPrice - $originalMaxPrice' : originalMinPrice,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Theme.of(context).hintColor,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
          ],

          CustomDirectionalityWidget(
            child: Text(
              isRange ? '$currentMinPrice-$currentMaxPrice' : currentMinPrice,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: titilliumBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),

          if (moq != null && moq > 0) ...[
            const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
            if (previousMoq != null)
              Text.rich(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${getTranslated('new_moq', context) ?? 'New MOQ'} : $previousMoq -> ',
                      style: titilliumRegular.copyWith(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    TextSpan(
                      text: '$moq ${getTranslated('pcs', context) ?? 'Pcs'}',
                      style: titilliumRegular.copyWith(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                '${getTranslated('moq', context) ?? 'MOQ'} : $moq',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
