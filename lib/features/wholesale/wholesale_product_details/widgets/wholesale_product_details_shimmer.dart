import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleProductDetailsShimmer extends StatelessWidget {
  const WholesaleProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const WholesaleShimmerBoxWidget(width: double.infinity, height: 300, borderRadius: 0),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
          child: Row(children: List.generate(
            4,
            (index) => const Padding(
              padding: EdgeInsetsDirectional.only(end: Dimensions.paddingSizeExtraSmall),
              child: WholesaleShimmerBoxWidget(width: 48, height: 48, borderRadius: Dimensions.radiusSmall),
            ),
          )),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            WholesaleShimmerBoxWidget(width: double.infinity, height: 16),
            SizedBox(height: Dimensions.paddingSizeSmall),
            WholesaleShimmerBoxWidget(width: 220, height: 16),
            SizedBox(height: Dimensions.paddingSizeDefault),
            WholesaleShimmerBoxWidget(width: 140, height: 22),
            SizedBox(height: Dimensions.paddingSizeSmall),
            WholesaleShimmerBoxWidget(width: 110, height: 12),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        const _WholesaleDetailsCardShimmer(lineCount: 3),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        const _WholesaleDetailsCardShimmer(lineCount: 2),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
          child: Row(children: [
            const WholesaleShimmerBoxWidget(width: 56, height: 56),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                WholesaleShimmerBoxWidget(width: double.infinity, height: 14),
                SizedBox(height: Dimensions.paddingSizeSmall),
                WholesaleShimmerBoxWidget(width: 120, height: 12),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      ]),
    );
  }
}

class _WholesaleDetailsCardShimmer extends StatelessWidget {
  final int lineCount;
  const _WholesaleDetailsCardShimmer({required this.lineCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const WholesaleShimmerBoxWidget(width: 160, height: 14),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        ...List.generate(lineCount, (index) => const Padding(
          padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: WholesaleShimmerBoxWidget(width: double.infinity, height: 12),
        )),
      ]),
    );
  }
}
