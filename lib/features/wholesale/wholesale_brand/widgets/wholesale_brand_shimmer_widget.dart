import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleBrandShimmerWidget extends StatelessWidget {
  const WholesaleBrandShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1/1.3),
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
      ),
      itemCount: 24,
      itemBuilder: (context, index) => const _WholesaleBrandShimmerItem(),
    );
  }
}

class _WholesaleBrandShimmerItem extends StatelessWidget {
  const _WholesaleBrandShimmerItem();

  @override
  Widget build(BuildContext context) {
    return const Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(child: WholesaleShimmerBoxWidget(borderRadius: Dimensions.paddingSizeSmall)),
      SizedBox(height: Dimensions.paddingSizeSmall),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: WholesaleShimmerBoxWidget(height: 10, borderRadius: Dimensions.radiusSmall),
      ),
      SizedBox(height: Dimensions.paddingSizeSmall),
    ]);
  }
}
