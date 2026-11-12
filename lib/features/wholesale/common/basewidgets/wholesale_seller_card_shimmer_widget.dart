import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleSellerCardShimmerWidget extends StatelessWidget {
  const WholesaleSellerCardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WholesaleShimmerBoxWidget(width: 42, height: 42, borderRadius: 21),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WholesaleShimmerBoxWidget(height: 12, width: 120),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      const WholesaleShimmerBoxWidget(height: 10, width: 160),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimensions.paddingSizeSmall,
              0,
              Dimensions.paddingSizeSmall,
              Dimensions.paddingSizeSmall,
            ),
            child: Row(children: [
              Expanded(child: AspectRatio(aspectRatio: 1, child: WholesaleShimmerBoxWidget())),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Expanded(child: AspectRatio(aspectRatio: 1, child: WholesaleShimmerBoxWidget())),
            ]),
          ),
        ],
      ),
    );
  }
}
