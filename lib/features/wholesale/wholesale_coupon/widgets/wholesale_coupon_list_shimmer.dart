import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleCouponListShimmer extends StatelessWidget {
  final int itemCount;
  final bool fromCheckout;
  final bool shrinkWrap;

  const WholesaleCouponListShimmer({super.key, this.itemCount = 5, this.fromCheckout = false, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) => _WholesaleCouponCardShimmer(fromCheckout: fromCheckout),
    );
  }
}

class _WholesaleCouponCardShimmer extends StatelessWidget {
  final bool fromCheckout;
  const _WholesaleCouponCardShimmer({required this.fromCheckout});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Padding(
      padding: fromCheckout
          ? const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeSmall, 0, 0)
          : const EdgeInsets.fromLTRB(Dimensions.homePagePadding, Dimensions.paddingSizeSmall, Dimensions.homePagePadding, 0),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          boxShadow: isDark ? null : [
            BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: .12), spreadRadius: 1, blurRadius: 1, offset: const Offset(1, 1)),
          ],
        ),
        child: Row(children: [
          Expanded(
            flex: 4,
            child: Column(children: const [
              WholesaleShimmerBoxWidget(width: 30, height: 30, borderRadius: Dimensions.radiusSmall),
              SizedBox(height: Dimensions.paddingSizeSmall),
              WholesaleShimmerBoxWidget(width: 60, height: 16),
            ]),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            flex: 7,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              WholesaleShimmerBoxWidget(width: double.infinity, height: 14),
              SizedBox(height: Dimensions.paddingSizeEight),
              WholesaleShimmerBoxWidget(width: 140, height: 11),
              SizedBox(height: Dimensions.paddingSizeEight),
              WholesaleShimmerBoxWidget(width: 100, height: 11),
            ]),
          ),
        ]),
      ),
    );
  }
}
