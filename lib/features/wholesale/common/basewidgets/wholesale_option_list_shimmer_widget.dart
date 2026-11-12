import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleOptionListShimmerWidget extends StatelessWidget {
  final int itemCount;
  const WholesaleOptionListShimmerWidget({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
        child: Row(children: [
          const WholesaleShimmerBoxWidget(width: 20, height: 20, borderRadius: Dimensions.radiusSmall),
          const SizedBox(width: Dimensions.paddingSizeTwelve),
          WholesaleShimmerBoxWidget(width: index.isEven ? 160 : 120, height: 12),
        ]),
      )),
    );
  }
}
