import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_most_demanded_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_most_demanded_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/wholesale_offer_type.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleReducedMoqProductsSection extends StatelessWidget {
  static const int _shimmerItemCount = 4;

  final List<WholesaleProduct>? products;
  const WholesaleReducedMoqProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products != null && products!.isEmpty) return const SizedBox.shrink();

    final double cardWidth = MediaQuery.sizeOf(context).width * 0.85;

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
            titleKey: 'reduced_moq_products',
            titleFallback: 'Reduced MOQ Products',
            showViewAll: products?.length != 1,
            onViewAll: () => RouterHelper.getWholesaleOfferProductsScreenRoute(
              action: RouteAction.push,
              title: getTranslated('reduced_moq_products', Get.context!) ?? 'Reduced MOQ Products',
              type: WholesaleOfferType.reducedMoq,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          if (products != null && products!.length == 1)
            Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.homePagePadding,
                right: Dimensions.homePagePadding,
                bottom: Dimensions.paddingSizeExtraSmall,
              ),
              child: SizedBox(width: cardWidth, child: WholesaleMostDemandedProductCard(product: products!.first)),
            )
          else
            SizedBox(
              height: 255,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                  left: Dimensions.homePagePadding,
                  right: Dimensions.homePagePadding,
                  bottom: Dimensions.paddingSizeExtraSmall,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: Dimensions.paddingSizeSmall,
                  mainAxisSpacing: Dimensions.paddingSizeSmall,
                  mainAxisExtent: cardWidth,
                ),
                itemCount: products?.length ?? _shimmerItemCount,
                itemBuilder: (context, index) =>
                    products == null ? const WholesaleMostDemandedProductCardShimmerWidget() : WholesaleMostDemandedProductCard(product: products![index]),
              ),
            ),
        ],
      ),
    );
  }
}
