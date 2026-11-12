import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCategoryShimmer extends StatelessWidget {
  const WholesaleCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        flex: 3,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeEight),
          height: double.infinity,
          color: Theme.of(context).highlightColor,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, index) => const _WholesaleCategoryTileShimmer(),
          ),
        ),
      ),

      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
            color: Theme.of(context).highlightColor,
            child: const WholesaleSubCategoryListShimmer(),
          ),
        ),
      ),
    ]);
  }
}

class WholesaleSubCategoryListShimmer extends StatelessWidget {
  final int itemCount;
  final bool shrinkWrap;

  const WholesaleSubCategoryListShimmer({super.key, this.itemCount = 9, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      separatorBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Divider(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.10), thickness: 1),
      ),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeTwelve),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: WholesaleShimmerBoxWidget(width: index.isEven ? 150 : 110, height: 12),
        ),
      ),
    );
  }
}

class _WholesaleCategoryTileShimmer extends StatelessWidget {
  const _WholesaleCategoryTileShimmer();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Container(
          height: boxConstraints.maxWidth,
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            color: Theme.of(context).hintColor.withValues(alpha: 0.07),
          ),
          child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: const [
            WholesaleShimmerBoxWidget(width: 40, height: 40, borderRadius: Dimensions.radiusHundred),
            SizedBox(height: Dimensions.paddingSizeEight),
            WholesaleShimmerBoxWidget(width: 50, height: 10),
          ])),
        );
      },
    );
  }
}
