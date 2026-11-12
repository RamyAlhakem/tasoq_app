import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WholesaleProductGridShimmerWidget extends StatelessWidget {
  final int itemCount;
  const WholesaleProductGridShimmerWidget({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding - Dimensions.paddingSizeExtraSmall)
          .copyWith(top: Dimensions.paddingSizeSmall),
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
      itemCount: itemCount,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        child: const WholesaleProductCardShimmerWidget(),
      ),
    );
  }
}

class WholesaleProductSliverGridShimmerWidget extends StatelessWidget {
  final int itemCount;
  const WholesaleProductSliverGridShimmerWidget({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding - Dimensions.paddingSizeExtraSmall),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
        childCount: itemCount,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: const WholesaleProductCardShimmerWidget(),
        ),
      ),
    );
  }
}
