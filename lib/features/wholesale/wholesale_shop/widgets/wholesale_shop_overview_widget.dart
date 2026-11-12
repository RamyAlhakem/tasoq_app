import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/domain/models/wholesale_coupon_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/widgets/wholesale_shop_coupon_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/controllers/wholesale_shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleShopOverviewWidget extends StatelessWidget {
  final WholesaleShopController controller;
  final VoidCallback onSeeAllProducts;
  final VoidCallback onSeeAllCoupons;

  const WholesaleShopOverviewWidget({super.key, required this.controller, required this.onSeeAllProducts, required this.onSeeAllCoupons});

  static const int _shimmerItemCount = 4;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: Dimensions.paddingSizeEight),
      _buildCoupons(context),
      _buildRail(
        context,
        titleKey: 'best_selling',
        titleFallback: 'Best Selling',
        products: controller.topSellingProducts,
      ),
      _buildRail(
        context,
        titleKey: 'featured_products',
        titleFallback: 'Featured Products',
        products: controller.featuredProducts,
      ),
      const SizedBox(height: Dimensions.paddingSizeLarge),
    ]);
  }

  Widget _buildCoupons(BuildContext context) {
    final List<WholesaleCoupon>? coupons = controller.coupons;

    if (coupons != null && coupons.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (coupons == null)
        const Padding(
          padding: EdgeInsets.fromLTRB(
            Dimensions.homePagePadding, Dimensions.paddingSizeSmall, Dimensions.homePagePadding, 0,
          ),
          child: WholesaleShimmerBoxWidget(width: double.infinity, height: 110),
        )
      else
        _WholesaleShopCouponCarousel(coupons: coupons),
      const SizedBox(height: Dimensions.paddingSizeSmall),
    ]);
  }

  Widget _buildRail(BuildContext context, {required String titleKey, required String titleFallback, required List<WholesaleProduct>? products}) {
    if (products != null && products.isEmpty) return const SizedBox.shrink();

    final double cardWidth = (MediaQuery.sizeOf(context).width - (Dimensions.homePagePadding * 2) - Dimensions.paddingSizeSmall) / 2;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      WholesaleSectionHeader(titleKey: titleKey, titleFallback: titleFallback, onViewAll: onSeeAllProducts, showViewAll: false),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.homePagePadding,
          vertical: Dimensions.paddingSizeExtraSmall,
        ),
        itemCount: products?.length ?? _shimmerItemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Dimensions.paddingSizeSmall,
          mainAxisSpacing: Dimensions.paddingSizeSmall,
          mainAxisExtent: cardWidth + 110,
        ),
        itemBuilder: (context, index) => products == null
            ? const WholesaleProductCardShimmerWidget() : WholesaleProductCardWidget(product: products[index]),
      ),
    ]);
  }
}

class _WholesaleShopCouponCarousel extends StatefulWidget {
  final List<WholesaleCoupon> coupons;
  const _WholesaleShopCouponCarousel({required this.coupons});

  @override
  State<_WholesaleShopCouponCarousel> createState() => _WholesaleShopCouponCarouselState();
}

class _WholesaleShopCouponCarouselState extends State<_WholesaleShopCouponCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final List<WholesaleCoupon> coupons = widget.coupons;
    final bool hasMultiple = coupons.length > 1;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Stack(children: [
      CarouselSlider.builder(
        options: CarouselOptions(
          viewportFraction: 1,
          aspectRatio: 16 / (size.width > 380 ? 7 : 7.5),
          autoPlay: hasMultiple,
          scrollPhysics: hasMultiple ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
          enlargeCenterPage: true,
          disableCenter: true,
          onPageChanged: (index, _) => setState(() => _currentIndex = index),
        ),
        itemCount: coupons.length,
        itemBuilder: (context, index, _) => WholesaleShopCouponItemWidget(coupon: coupons[index]),
      ),

      if (hasMultiple)
        Positioned.fill(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(coupons.length, (index) {
              final Color color = index == _currentIndex ? primaryColor : primaryColor.withValues(alpha: .25);
              return TabPageSelectorIndicator(backgroundColor: color, borderColor: color, size: 5);
            })),
          ),
        )),

      Positioned.fill(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeThirtyFive, vertical: Dimensions.paddingSizeDefault),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('${_currentIndex + 1}',
              style: textMedium.copyWith(color: primaryColor, fontSize: Dimensions.fontSizeExtraSmall)),
            Text('/${coupons.length}',
              style: textRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall)),
          ]),
        ),
      )),
    ]);
  }
}

class WholesaleShopOverviewEmptyWidget extends StatelessWidget {
  const WholesaleShopOverviewEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
      child: Center(
        child: Text(getTranslated('no_data_found', context) ?? ''),
      ),
    );
  }
}
