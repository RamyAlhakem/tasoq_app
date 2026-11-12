import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class WholesaleCampaignShimmer extends StatelessWidget {
  const WholesaleCampaignShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: isDark ? null : [BoxShadow(color: Colors.grey.withValues(alpha: .2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],
          ),
          child: Column(children: [
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
              child: WholesaleShimmerBoxWidget(width: double.infinity, height: 160),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                WholesaleShimmerBoxWidget(width: 200, height: 18),
                SizedBox(height: Dimensions.paddingSizeSmall),
                WholesaleShimmerBoxWidget(width: double.infinity, height: 12),
                SizedBox(height: Dimensions.paddingSizeExtraSmall),
                WholesaleShimmerBoxWidget(width: 240, height: 12),
                SizedBox(height: Dimensions.paddingSizeDefault),

                Row(children: [
                  WholesaleShimmerBoxWidget(width: 90, height: 24, borderRadius: Dimensions.radiusSmall),
                  SizedBox(width: Dimensions.paddingSizeSmall),
                  WholesaleShimmerBoxWidget(width: 90, height: 24, borderRadius: Dimensions.radiusSmall),
                  SizedBox(width: Dimensions.paddingSizeSmall),
                  WholesaleShimmerBoxWidget(width: 90, height: 24, borderRadius: Dimensions.radiusSmall),
                ]),
              ]),
            ),
            const SizedBox(height: Dimensions.homePagePadding),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
              child: WholesaleShimmerBoxWidget(width: 160, height: 16),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            MasonryGridView.count(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding - Dimensions.paddingSizeExtraSmall),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
              itemCount: 4,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: const WholesaleProductCardShimmerWidget(),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
