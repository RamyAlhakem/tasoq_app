import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_closed_now_tag_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_discount_badge_widget.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleRecommendedSellerCard extends StatelessWidget {
  final WholesaleSeller seller;
  final VoidCallback? onTap;
  final VoidCallback? onChat;

  const WholesaleRecommendedSellerCard({
    super.key,
    required this.seller,
    this.onTap,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Divider(height: 1, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
            _buildProductsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.paddingSizeTwelve,
        Dimensions.paddingSizeTwelve,
        Dimensions.paddingSizeTwelve,
        Dimensions.paddingSizeTwelve - 4.5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2)),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                image: seller.shopLogoUrl?.path ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        seller.shopName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: titilliumBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    if (seller.isVerified) ...[
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      CustomAssetImageWidget(Images.varifiedBadge, width: 16, height: 16),
                    ],

                    if (seller.isClosed) ...[
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      const WholesaleClosedNowTagWidget(),
                    ],
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: Dimensions.iconSizeSmall),
                    const SizedBox(width: 2),
                    Text((seller.rating ?? 0).toStringAsFixed(1),
                      style: titilliumBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraExtraSmall),
                    Text('(${seller.reviewCount ?? 0} ${getTranslated('reviews', context) ?? 'Reviews'})',
                      style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Text('•',
                        style: titilliumRegular.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),
                    Flexible(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(text: '${getTranslated('avg_moq', context) ?? 'Avg MOQ'} ',
                              style: titilliumRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            TextSpan(text: seller.hasMoa ? PriceConverter.convertPrice(context, seller.avgMoq!) : 'N/A',
                              style: titilliumBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
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
          const SizedBox(width: Dimensions.paddingSizeSmall),
          InkWell(
            onTap: onChat,
            borderRadius: BorderRadius.circular(30),
            child: CustomAssetImageWidget(
              Images.chatIcon,
              width: 20, height: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _openProductDetails(WholesaleProduct product) {
    final String? slug = product.slug;
    if (slug == null || slug.isEmpty) return;
    RouterHelper.getWholesaleProductDetailsRoute(slug: slug, action: RouteAction.push);
  }

  static const int _productSlots = 3;

  Widget _buildProductsSection(BuildContext context) {
    final displayProducts = seller.products.take(_productSlots).toList();
    if (displayProducts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeTwelve),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_productSlots, (index) {
          if (index >= displayProducts.length) {
            return const Expanded(child: SizedBox.shrink());
          }
          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                end: index == _productSlots - 1 ? 0 : Dimensions.paddingSizeExtraSmall,
              ),
              child: InkWell(
                onTap: () => _openProductDetails(displayProducts[index]),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: _buildProductCard(context, displayProducts[index]),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, WholesaleProduct product) {
    final bool hasDiscount = (product.discountedPercentage ?? 0) > 0;
    final double price = product.minDiscountedPrice ?? product.minPrice ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                child: CustomImageWidget(
                  image: product.thumbnailFullUrl?.path ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              if (hasDiscount)
                WholesaleDiscountBadgeWidget(percentage: product.discountedPercentage!, radius: null,),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
        Text(
          product.productName ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
        CustomDirectionalityWidget(
          child: Text(
            PriceConverter.convertPrice(context, price),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titilliumBold.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        if (product.minimumOrderQuantity != null && product.minimumOrderQuantity! > 0) ...[
          Text(
            '${getTranslated('moq', context) ?? 'MOQ'} : ${product.minimumOrderQuantity} ${getTranslated('pcs', context) ?? 'Pcs'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titilliumRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
        ],
      ],
    );
  }
}
