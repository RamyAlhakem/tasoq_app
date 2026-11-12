import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleOrderListShimmer extends StatelessWidget {
  final int itemCount;
  const WholesaleOrderListShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const WholesaleOrderCardShimmer(),
    );
  }
}

class WholesaleOrderCardShimmer extends StatelessWidget {
  const WholesaleOrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: isDark ? null : [
          BoxShadow(color: Colors.grey.withValues(alpha: .12), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const WholesaleShimmerBoxWidget(width: 56, height: 56, borderRadius: Dimensions.radiusSmall),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Row(children: [
              WholesaleShimmerBoxWidget(width: 110, height: 14),
              Spacer(),
              WholesaleShimmerBoxWidget(width: 70, height: 20, borderRadius: Dimensions.radiusSmall),
            ]),
            SizedBox(height: Dimensions.paddingSizeSmall),

            WholesaleShimmerBoxWidget(width: 150, height: 11),
            SizedBox(height: Dimensions.paddingSizeSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              WholesaleShimmerBoxWidget(width: 80, height: 14),
              WholesaleShimmerBoxWidget(width: 120, height: 11),
            ]),
          ]),
        ),
      ]),
    );
  }
}
