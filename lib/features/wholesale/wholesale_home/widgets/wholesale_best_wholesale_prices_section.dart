import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/color_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/controllers/wholesale_home_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/enums/wholesale_product_list_type.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleBestWholesalePricesSection extends StatelessWidget {
  final List<WholesaleProduct>? products;
  const WholesaleBestWholesalePricesSection({super.key, required this.products});

  static const int _shimmerItemCount = 3;

  @override
  Widget build(BuildContext context) {
    final List<WholesaleProduct>? products = this.products;
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.45;

    final Color base = Theme.of(context).scaffoldBackgroundColor;
    final Color gradientStart = ColorHelper.blendColors(base, const Color(0xFFFFE8B0), 0.5);
    final Color gradientEnd   = ColorHelper.blendColors(base, const Color(0xFFD6E4FF), 0.5);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientStart, gradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: Dimensions.homePagePadding,
              right: Dimensions.homePagePadding,
              top: Dimensions.paddingSizeSmall,
            ),
            child: Row(
              children: [
                CustomAssetImageWidget(Images.fireIcon, width: 20, height: 20),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Expanded(
                  child: Text(
                    getTranslated('best_wholesale_prices', context) ?? 'Best Wholesale Prices',
                    style: titilliumBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => RouterHelper.getWholesaleViewAllProductsScreenRoute(
      action: RouteAction.push,
      type: WholesaleProductListType.bestPrices,
      categoryId: Provider.of<WholesaleHomeController>(context, listen: false).categoryIdFor(WholesaleHomeTabScope.products),
    ),
                  child: Text(
                    getTranslated('view_all', context) ?? 'View All',
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          SizedBox(
            height: cardWidth + 105,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.homePagePadding,
                vertical: Dimensions.paddingSizeExtraSmall,
              ),
              itemCount: products?.length ?? _shimmerItemCount,
              separatorBuilder: (_, __) => const SizedBox(width: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) => SizedBox(
                width: cardWidth,
                child: products == null
                    ? const WholesaleProductCardShimmerWidget()
                    : WholesaleProductCardWidget(product: products[index]),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ],
      ),
    );
  }
}
