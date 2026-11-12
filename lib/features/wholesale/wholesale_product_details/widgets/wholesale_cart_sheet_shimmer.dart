import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCartSheetShimmer extends StatelessWidget {
  const WholesaleCartSheetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const WholesaleShimmerBoxWidget(width: 90, height: 90),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              WholesaleShimmerBoxWidget(width: double.infinity, height: 14),
              SizedBox(height: Dimensions.paddingSizeEight),
              WholesaleShimmerBoxWidget(width: 120, height: 18),
              SizedBox(height: Dimensions.paddingSizeEight),
              WholesaleShimmerBoxWidget(width: 90, height: 11),
            ]),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        const _WholesaleSheetAxisShimmer(optionCount: 4),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        const _WholesaleSheetAxisShimmer(optionCount: 3),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        const WholesaleShimmerBoxWidget(width: 120, height: 13),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        const WholesaleShimmerBoxWidget(width: double.infinity, height: 44),
      ]),
    );
  }
}

class _WholesaleSheetAxisShimmer extends StatelessWidget {
  final int optionCount;
  const _WholesaleSheetAxisShimmer({required this.optionCount});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const WholesaleShimmerBoxWidget(width: 80, height: 12),
      const SizedBox(height: Dimensions.paddingSizeSmall),
      Wrap(
        spacing: Dimensions.paddingSizeSmall,
        runSpacing: Dimensions.paddingSizeSmall,
        children: List.generate(optionCount, (index) => const WholesaleShimmerBoxWidget(width: 72, height: 32, borderRadius: Dimensions.radiusSmall)),
      ),
    ]);
  }
}
