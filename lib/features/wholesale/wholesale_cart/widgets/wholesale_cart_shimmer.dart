import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCartShimmer extends StatelessWidget {
  final int groupCount;
  final int itemsPerGroup;

  const WholesaleCartShimmer({super.key, this.groupCount = 2, this.itemsPerGroup = 2});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsetsDirectional.only(start: Dimensions.homePagePadding),
            child: Row(children: [
              WholesaleShimmerBoxWidget(width: 20, height: 20, borderRadius: Dimensions.radiusSmall),
              SizedBox(width: Dimensions.paddingSizeEight),
              WholesaleShimmerBoxWidget(width: 24, height: 24, borderRadius: Dimensions.radiusSmall),
              SizedBox(width: Dimensions.paddingSizeSmall),
              WholesaleShimmerBoxWidget(width: 140, height: 15),
            ]),
          ),
          ...List.generate(itemsPerGroup, (_) => const _WholesaleCartRowShimmer()),
        ]),
      ),
    );
  }
}

class _WholesaleCartRowShimmer extends StatelessWidget {
  const _WholesaleCartRowShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const WholesaleShimmerBoxWidget(width: 20, height: 20, borderRadius: Dimensions.radiusSmall),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const WholesaleShimmerBoxWidget(width: 60, height: 60, borderRadius: Dimensions.paddingSizeExtraSmall),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  WholesaleShimmerBoxWidget(width: double.infinity, height: 13),
                  SizedBox(height: Dimensions.paddingSizeEight),
                  WholesaleShimmerBoxWidget(width: 130, height: 11),
                  SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  WholesaleShimmerBoxWidget(width: 100, height: 11),
                ]),
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              WholesaleShimmerBoxWidget(width: 90, height: 14),
              WholesaleShimmerBoxWidget(width: 100, height: 28, borderRadius: Dimensions.radiusSmall),
            ]),
          ]),
        ),
      ]),
    );
  }
}
