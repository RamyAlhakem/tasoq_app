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

class WholesaleSellerCard extends StatelessWidget {
  final WholesaleSeller seller;
  final VoidCallback? onChat;
  final VoidCallback? onTap;
  final bool useShadowStyle;

  const WholesaleSellerCard({
    super.key,
    required this.seller,
    this.onChat,
    this.onTap,
    this.useShadowStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildProductsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final TextStyle hintStyle = titilliumRegular.copyWith(
      fontSize: Dimensions.fontSizeSmall,
      color: Theme.of(context).hintColor,
    );

    final TextStyle boldStyle = titilliumBold.copyWith(
      fontSize: Dimensions.fontSizeSmall,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).cardColor,
            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
          ),
          child: ClipOval(
            child: CustomImageWidget(image: seller.shopLogoUrl?.path ?? '', fit: BoxFit.cover),
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
                    child: Text(seller.shopName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titilliumBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.w600,
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

                  Text((seller.rating ?? 0).toStringAsFixed(1), style: boldStyle),
                  const SizedBox(width: Dimensions.paddingSizeExtraExtraSmall),

                  Text.rich(
                    TextSpan(style: hintStyle, children: [
                      const TextSpan(text: '('),
                      TextSpan(text: '${seller.reviewCount ?? 0}', style: boldStyle),
                      TextSpan(text: ' ${getTranslated('reviews', context) ?? 'Reviews'})'),
                    ]),
                  ),
                  ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Text('•', style: hintStyle),
                    ),
                    Flexible(
                      child: Text.rich(
                        TextSpan(style: hintStyle, children: [
                          TextSpan(text: '${getTranslated('avg_moq', context) ?? 'Avg MOQ'} '),
                          TextSpan(text: seller.hasMoa ? PriceConverter.convertPrice(context, seller.avgMoq) : 'N/A', style: boldStyle),
                        ]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
            width: 24, height: 24,
            color: isDark ? Colors.white : Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  void _openProductDetails(WholesaleProduct product) {
    final String? slug = product.slug;
    if (slug == null || slug.isEmpty) return;
    RouterHelper.getWholesaleProductDetailsRoute(slug: slug, action: RouteAction.push);
  }

  Widget _buildProductsSection(BuildContext context) {
    final displayProducts = seller.products.take(2).toList();
    if (displayProducts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(2, (index) {
          if (index >= displayProducts.length) {
            return const Expanded(child: SizedBox.shrink());
          }
          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                end: index == 1 ? 0 : Dimensions.paddingSizeExtraSmall,
              ),
              child: InkWell(
                onTap: () => _openProductDetails(displayProducts[index]),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: _buildSimpleProductCard(context, displayProducts[index]),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSimpleProductCard(BuildContext context, WholesaleProduct product) {
    final bool hasDiscount = (product.discountedPercentage ?? 0) > 0;
    final double minPrice = product.minDiscountedPrice ?? product.minPrice ?? 0;
    final double maxPrice = product.maxDiscountedPrice ?? product.maxPrice ?? 0;
    final bool isRange = minPrice != maxPrice;
    final String priceText = isRange
        ? '${PriceConverter.convertPrice(context, minPrice)} - ${PriceConverter.convertPrice(context, maxPrice)}'
        : PriceConverter.convertPrice(context, minPrice);
    final String originalPriceText = isRange
        ? '${PriceConverter.convertPrice(context, product.minPrice)} - ${PriceConverter.convertPrice(context, product.maxPrice)}'
        : PriceConverter.convertPrice(context, product.minPrice);
    final int? moq = product.minimumOrderQuantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: Stack(
                children: [
                  CustomImageWidget(
                    image: product.thumbnailFullUrl?.path ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  if (hasDiscount)
                    WholesaleDiscountBadgeWidget(percentage: product.discountedPercentage!, radius: Dimensions.radiusDefault),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeEight),
        Text(
          product.productName ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        if (hasDiscount && product.minPrice != null) ...[
          CustomDirectionalityWidget(
            child: Text(
              originalPriceText,
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
            priceText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titilliumBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),

        if (moq != null && moq > 0) ...[
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text.rich(
            TextSpan(
              style: titilliumRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor,
              ),
              children: [
                TextSpan(text: '${getTranslated('moq', context) ?? 'MOQ'} : '),
                TextSpan(
                  text: '$moq',
                  style: titilliumBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                TextSpan(
                  text: ' ${getTranslated('pcs', context) ?? 'Pcs'}',
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
