import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleOrderDetailsShimmer extends StatelessWidget {
  const WholesaleOrderDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).highlightColor,
        toolbarHeight: 80,
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Material(
          color: Theme.of(context).cardColor,
          elevation: 3.0,
          shadowColor: Theme.of(context).cardColor,
          child: Container(),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Row(children: [
            const WholesaleShimmerBoxWidget(width: 24, height: 24, borderRadius: Dimensions.radiusSmall),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: const [
                WholesaleShimmerBoxWidget(width: 120, height: 14),
                SizedBox(height: Dimensions.paddingSizeExtraSmall),
                WholesaleShimmerBoxWidget(width: 80, height: 11),
              ]),
            ),
            const WholesaleShimmerBoxWidget(width: 30, height: 30, borderRadius: Dimensions.radiusSmall),
          ]),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          _WholesaleOrderSectionShimmer(lineCount: 3),
          _WholesaleOrderSectionShimmer(lineCount: 2),
          _WholesaleOrderSectionShimmer(lineCount: 3),
          _WholesaleOrderProductRowShimmer(),
          _WholesaleOrderProductRowShimmer(),
          _WholesaleOrderSectionShimmer(lineCount: 4),
        ],
      ),
    );
  }
}

class _WholesaleOrderSectionShimmer extends StatelessWidget {
  final int lineCount;
  const _WholesaleOrderSectionShimmer({required this.lineCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const WholesaleShimmerBoxWidget(width: 140, height: 14),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        ...List.generate(lineCount, (index) => Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
            WholesaleShimmerBoxWidget(width: 100, height: 11),
            WholesaleShimmerBoxWidget(width: 70, height: 11),
          ]),
        )),
      ]),
    );
  }
}

class _WholesaleOrderProductRowShimmer extends StatelessWidget {
  const _WholesaleOrderProductRowShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const WholesaleShimmerBoxWidget(width: 60, height: 60, borderRadius: Dimensions.radiusSmall),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            WholesaleShimmerBoxWidget(width: double.infinity, height: 13),
            SizedBox(height: Dimensions.paddingSizeSmall),
            WholesaleShimmerBoxWidget(width: 130, height: 11),
            SizedBox(height: Dimensions.paddingSizeSmall),
            WholesaleShimmerBoxWidget(width: 90, height: 11),
          ]),
        ),
      ]),
    );
  }
}
