import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_seller_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_seller_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/color_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleTopDiscountedManufacturersSection extends StatelessWidget {
  static const int _shimmerItemCount = 3;

  final List<WholesaleSeller>? sellers;
  const WholesaleTopDiscountedManufacturersSection({super.key, required this.sellers});

  @override
  Widget build(BuildContext context) {
    if (sellers != null && sellers!.isEmpty) return const SizedBox.shrink();

    final double cardWidth = MediaQuery.sizeOf(context).width * 0.9;
    final double productCardWidth =
        (cardWidth - Dimensions.paddingSizeSmall * 2 - Dimensions.paddingSizeExtraSmall * 2) / 2;
    final double sectionHeight = 88 + productCardWidth + 100;

    final Color base = Theme.of(context).scaffoldBackgroundColor;
    final Color gradientStart = ColorHelper.blendColors(base, const Color(0xFFFFE8B0), 0.5);
    final Color gradientEnd = ColorHelper.blendColors(base, const Color(0xFFD6E4FF), 0.5);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientStart, gradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          WholesaleSectionHeader(
            titleKey: 'top_discounted_manufacturers',
            titleFallback: 'Top Discounted Manufacturers',
            onViewAll: () => RouterHelper.getWholesaleAllManufacturersScreenRoute(
              action: RouteAction.push,
              title: getTranslated('top_discounted_manufacturer', context) ?? 'Top Discounted Manufacturer',
              manufacturerType: 'top-discounted',
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          SizedBox(
            height: sectionHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(
                left: Dimensions.homePagePadding,
                right: Dimensions.homePagePadding,
                bottom: Dimensions.paddingSizeExtraSmall,
              ),
              itemCount: sellers?.length ?? _shimmerItemCount,
              separatorBuilder: (_, __) => const SizedBox(width: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) => SizedBox(
                width: cardWidth,
                child: sellers == null
                    ? const WholesaleSellerCardShimmerWidget()
                    : WholesaleSellerCard(
                        seller: sellers![index],
                        onChat: () => openWholesaleSellerChat(context, sellers![index]),
                        onTap: () => _openShop(sellers![index]),
                      ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ],
      ),
    );
  }

  void _openShop(WholesaleSeller seller) {
    if (seller.slug == null) return;
    RouterHelper.getWholesaleShopRoute(action: RouteAction.push, slug: seller.slug!, shopId: seller.id, shopName: seller.shopName);
  }



}
