import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_recent_order_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_recent_order_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleRecentlyOrderedSection extends StatelessWidget {
  final List<WholesaleRecentOrder>? orders;
  const WholesaleRecentlyOrderedSection({super.key, required this.orders});

  static const int _shimmerItemCount = 2;

  @override
  Widget build(BuildContext context) {
    final List<WholesaleRecentOrder>? orders = this.orders;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WholesaleSectionHeader(
          titleKey: 'recently_ordered',
          titleFallback: 'Recently Ordered',
          onViewAll: () => RouterHelper.getWholesaleOrderScreenRoute(action: RouteAction.push),
        ),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeExtraSmall),
            itemCount: orders?.length ?? _shimmerItemCount,
            separatorBuilder: (_, __) => const SizedBox(width: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) => SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.88,
              child: orders == null
                  ? const WholesaleShimmerBoxWidget()
                  : WholesaleRecentOrderCard(order: orders[index]),
            ),
          ),
        ),
      ],
    );
  }
}
