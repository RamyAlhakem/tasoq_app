import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_recommended_seller_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';

class WholesaleRecommendedForYouSection extends StatelessWidget {
  final List<WholesaleSeller>? sellers;
  const WholesaleRecommendedForYouSection({super.key, required this.sellers});

  static const int _shimmerItemCount = 2;

  @override
  Widget build(BuildContext context) {
    final List<WholesaleSeller>? sellers = this.sellers;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.homePagePadding),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WholesaleSectionHeader(
            titleKey: 'recommended_for_you',
            titleFallback: 'Recommended for you',
            onViewAll: () => RouterHelper.getWholesaleAllManufacturersScreenRoute(
              action: RouteAction.push,
              title: getTranslated('recommended_for_you', context) ?? 'Recommended for you',
              manufacturerType: WholesaleSellerRailEnum.recommended.type,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
            itemCount: sellers?.length ?? _shimmerItemCount,
            separatorBuilder: (_, __) => const SizedBox(height: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) => sellers == null
                ? const WholesaleShimmerBoxWidget(height: 120)
                : WholesaleRecommendedSellerCard(
                    seller: sellers[index],
                    onChat: () => openWholesaleSellerChat(context, sellers[index]),
                    onTap: () => _openShop(sellers[index]),
                  ),
          ),
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
