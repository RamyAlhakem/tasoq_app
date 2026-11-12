import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_wishlist/widgets/wholesale_favourite_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_discount_badge_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_out_of_stock_badge_widget.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleProductCardWidget extends StatelessWidget {
  final WholesaleProduct product;
  final VoidCallback? onTap;

  const WholesaleProductCardWidget({
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
    final bool hasDiscount = (product.discountedPercentage ?? 0) > 0;
    final double minDiscounted = product.minDiscountedPrice ?? product.minPrice ?? 0;
    final double maxDiscounted = product.maxDiscountedPrice ?? product.maxPrice ?? 0;
    final bool isRange = minDiscounted != maxDiscounted;

    final bool hasPriceDrop = product.previousMinPrice != null && product.previousMinPrice! > minDiscounted;
    final bool showWasPrice = hasDiscount || hasPriceDrop;

    final String currentMinPrice = PriceConverter.convertPrice(context, minDiscounted);
    final String currentMaxPrice = isRange ? PriceConverter.convertPrice(context, maxDiscounted) : '';
    final double? wasMinPrice = hasPriceDrop ? product.previousMinPrice : product.minPrice;
    final double? wasMaxPrice = hasPriceDrop ? product.previousMaxPrice : product.maxPrice;
    final String originalMinPrice = showWasPrice ? PriceConverter.convertPrice(context, wasMinPrice) : '';
    final String originalMaxPrice = showWasPrice && isRange ? PriceConverter.convertPrice(context, wasMaxPrice) : '';

    final int? moq = product.minimumOrderQuantity;
    final bool isOutOfStock = product.currentStock != null && product.currentStock! <= 0;

    return InkWell(
      onTap: onTap ?? () => _openDetails(context),
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05), width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                      child: CustomImageWidget(
                        width: double.infinity,
                        height: double.infinity,
                        image: product.thumbnailFullUrl?.path ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                if (isOutOfStock)
                  const WholesaleOutOfStockBadgeWidget(),

                if (hasDiscount)
                  PositionedDirectional(
                    top: 0,
                    start: 0,
                    child: WholesaleDiscountBadgeWidget(percentage: product.discountedPercentage!, radius: null),
                  ),

                PositionedDirectional(
                  bottom: Dimensions.paddingSizeExtraSmall,
                  end: Dimensions.paddingSizeExtraSmall,
                  child: WholesaleFavouriteButtonWidget(
                    productId: product.id,
                    backgroundColor: Provider.of<ThemeController>(context, listen: false).darkTheme
                        ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(product.productName ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),

                if (showWasPrice) ...[
                  CustomDirectionalityWidget(
                    child: Text(isRange ? '$originalMinPrice – $originalMaxPrice' : originalMinPrice,
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
                  child: Text(isRange ? '$currentMinPrice-$currentMaxPrice' : currentMinPrice,
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
                  Text('${getTranslated('moq', context) ?? 'MOQ'} : $moq',
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
          ],
        ),
      ),
    );
  }
}
