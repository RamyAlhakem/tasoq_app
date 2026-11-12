import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_whole_seller_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleRecentlyViewedSellersSection extends StatelessWidget {
  final List<WholesaleSeller>? sellers;
  const WholesaleRecentlyViewedSellersSection({super.key, required this.sellers});

  static const int _shimmerItemCount = 2;

  @override
  Widget build(BuildContext context) {
    final List<WholesaleSeller>? sellers = this.sellers;
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.7;

    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeTwelve),
          WholesaleSectionHeader(
            titleKey: 'recently_viewed',
            titleFallback: 'Recently Viewed',
            onViewAll: () => RouterHelper.getWholesaleAllManufacturersScreenRoute(
              action: RouteAction.push,
              title: getTranslated('recently_viewed', context) ?? 'Recently Viewed',
              sellers: sellers ?? [],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          SizedBox(
            height: 135,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.homePagePadding,
                vertical: Dimensions.paddingSizeExtraSmall,
              ),
              itemCount: sellers?.length ?? _shimmerItemCount,
              separatorBuilder: (_, __) => const SizedBox(width: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) => SizedBox(
                width: cardWidth,
                child: sellers == null
                    ? const WholesaleShimmerBoxWidget()
                    : WholesaleWholeSellerCard(seller: sellers[index], onChat: () => openWholesaleSellerChat(context, sellers[index]), onTap: () => _openShop(sellers[index])),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeTwelve),
        ],
      ),
    );
  }

  void _openShop(WholesaleSeller seller) {
    if (seller.slug == null) return;
    RouterHelper.getWholesaleShopRoute(
      action: RouteAction.push,
      slug: seller.slug!,
      shopId: seller.id,
      shopName: seller.shopName,
    );
  }
}
