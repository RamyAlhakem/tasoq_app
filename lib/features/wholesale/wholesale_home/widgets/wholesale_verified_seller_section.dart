import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_verified_seller_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';

class WholesaleVerifiedSellerSection extends StatelessWidget {
  final List<WholesaleSeller>? sellers;
  const WholesaleVerifiedSellerSection({super.key, required this.sellers});

  static const int _shimmerItemCount = 2;

  @override
  Widget build(BuildContext context) {
    final List<WholesaleSeller>? sellers = this.sellers;
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.9;
    final double productCardWidth = (cardWidth - Dimensions.paddingSizeSmall * 2 - Dimensions.paddingSizeExtraSmall * 2) / 2;
    final double sectionHeight = 90 + productCardWidth + 100;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor.withValues(alpha: 0.08), Theme.of(context).primaryColor.withValues(alpha: 0.08)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimensions.paddingSizeLarge),
              WholesaleSectionHeader(
                titleKey: 'verified_seller',
                titleFallback: 'Verified Seller',
                onViewAll: () => RouterHelper.getWholesaleAllManufacturersScreenRoute(
                  action: RouteAction.push,
                  title: getTranslated('verified_seller', context) ?? 'Verified Seller',
                  manufacturerType: WholesaleSellerRailEnum.verifiedSeller.type,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              SizedBox(
                height: sectionHeight,
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
                        : WholesaleVerifiedSellerCard(seller: sellers[index], onChat: () => openWholesaleSellerChat(context, sellers[index]), onTap: () => _openShop(sellers[index])),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
            ],
          ),
        ),
        PositionedDirectional(
          top: 0,
          end: 0,
          child: CustomAssetImageWidget(Images.varifiedStackIcon, width: 30, height: 30),
        ),
      ],
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
