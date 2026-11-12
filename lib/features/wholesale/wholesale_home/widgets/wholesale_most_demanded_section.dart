import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_most_demanded_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/controllers/wholesale_home_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/enums/wholesale_product_list_type.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleMostDemandedSection extends StatelessWidget {
  final List<WholesaleProduct>? products;
  const WholesaleMostDemandedSection({super.key, required this.products});

  static const int _shimmerItemCount = 4;

  @override
  Widget build(BuildContext context) {
    final List<WholesaleProduct>? products = this.products;
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.85;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WholesaleSectionHeader(
          titleKey: 'most_in_demand_items',
          titleFallback: 'Most In-Demand Items',
          onViewAll: () => RouterHelper.getWholesaleViewAllProductsScreenRoute(
            action: RouteAction.push,
            type: WholesaleProductListType.mostDemanded,
            categoryId:
                Provider.of<WholesaleHomeController>(context, listen: false)
                    .categoryIdFor(WholesaleHomeTabScope.products),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        if (products != null && products.length == 1)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.homePagePadding),
            child: SizedBox(
              width: cardWidth,
              child: WholesaleMostDemandedProductCard(product: products.first),
            ),
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
              itemBuilder: (context, index) => products == null
                  ? const WholesaleShimmerBoxWidget()
                  : WholesaleMostDemandedProductCard(product: products[index]),
            ),
          ),
      ],
    );
  }
}
