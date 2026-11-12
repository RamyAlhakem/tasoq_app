import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/wholesale_offer_type.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleDiscountedProductsSection extends StatelessWidget {
  static const int _shimmerItemCount = 4;

  final List<WholesaleProduct>? products;
  const WholesaleDiscountedProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products != null && products!.isEmpty) return const SizedBox.shrink();

    final double cardWidth = MediaQuery.sizeOf(context).width * 0.45;
    final List<WholesaleProduct>? preview = products;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [BoxShadow(color: Color(0x12000000), offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          WholesaleSectionHeader(
            titleKey: 'discounted_product',
            titleFallback: 'Discounted Products',
            onViewAll: () => RouterHelper.getWholesaleOfferProductsScreenRoute(
              action: RouteAction.push,
              title: getTranslated('discounted_product', Get.context!) ?? 'Discounted Products',
              type: WholesaleOfferType.discounted,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          SizedBox(
            height: cardWidth + 105,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(
                left: Dimensions.homePagePadding,
                right: Dimensions.homePagePadding,
                bottom: Dimensions.paddingSizeExtraSmall,
              ),
              itemCount: preview?.length ?? _shimmerItemCount,
              separatorBuilder: (_, __) => const SizedBox(width: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) => SizedBox(
                width: cardWidth,
                child: preview == null ? const WholesaleProductCardShimmerWidget() : WholesaleProductCardWidget(product: preview[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
