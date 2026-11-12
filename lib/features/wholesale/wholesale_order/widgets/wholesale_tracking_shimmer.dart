import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleTrackingShimmer extends StatelessWidget {
  final int stepCount;
  const WholesaleTrackingShimmer({super.key, this.stepCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const Padding(
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Center(child: WholesaleShimmerBoxWidget(width: 160, height: 16)),
        ),

        Container(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Column(
            children: List.generate(stepCount, (index) => _WholesaleTrackingStepShimmer(isLast: index == stepCount - 1)),
          ),
        ),
      ],
    );
  }
}

class _WholesaleTrackingStepShimmer extends StatelessWidget {
  final bool isLast;
  const _WholesaleTrackingStepShimmer({required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          const WholesaleShimmerBoxWidget(width: 32, height: 32, borderRadius: Dimensions.radiusHundred),
          if (!isLast) const WholesaleShimmerBoxWidget(width: 2, height: 40, borderRadius: 0),
        ]),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              WholesaleShimmerBoxWidget(width: 150, height: 13),
              SizedBox(height: Dimensions.paddingSizeEight),
              WholesaleShimmerBoxWidget(width: 110, height: 11),
            ]),
          ),
        ),
      ]),
    );
  }
}
