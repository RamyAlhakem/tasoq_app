import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_seller_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';

class WholesaleTopWholesalersSection extends StatelessWidget {
  final List<WholesaleSeller>? sellers;
  final Color? backgroundColor;
  const WholesaleTopWholesalersSection({super.key, required this.sellers, this.backgroundColor});

  static const int _shimmerItemCount = 2;

  @override
  Widget build(BuildContext context) {
    final List<WholesaleSeller>? sellers = this.sellers;
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.9;
    final double productCardWidth = (cardWidth - Dimensions.paddingSizeSmall * 2 - Dimensions.paddingSizeExtraSmall * 2) / 2;
    final double sectionHeight = 88 + productCardWidth + 100;

    return Container(
      color: backgroundColor ?? Theme.of(context).cardColor,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),
        WholesaleSectionHeader(
          titleKey: 'top_wholesalers',
          titleFallback: 'Top Wholesalers',
          onViewAll: () => RouterHelper.getWholesaleAllManufacturersScreenRoute(
            action: RouteAction.push,
            title: getTranslated('top_wholesalers', context) ?? 'Top Wholesalers',
            manufacturerType: 'top-wholesaler',
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
                  ? const WholesaleShimmerBoxWidget()
                  : WholesaleSellerCard(seller: sellers[index],
                  onChat: () => openWholesaleSellerChat(context, sellers[index]),
                  onTap: () => _openShop(sellers[index],
              )),
            ),


          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      ],
    ));
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
