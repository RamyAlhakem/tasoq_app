import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/controllers/wholesale_banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/domain/wholesale_banner_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/widgets/wholesale_banner_slider_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/controllers/wholesale_home_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_most_demanded_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_recommended_for_you_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_recently_viewed_sellers_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_top_wholesalers_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_verified_seller_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_discover_category_banner.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_feature_highlights_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_home_category_filter_section.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleWholesalersTabContent extends StatelessWidget {
  const WholesaleWholesalersTabContent({super.key});

  static bool _isShown(List? rows) => rows == null || rows.isNotEmpty;
  static const WholesaleHomeTabScope _scope = WholesaleHomeTabScope.manufacturers;

  @override
  Widget build(BuildContext context) {
    final WholesaleHomeController homeController = context.watch<WholesaleHomeController>();
    final List<WholesaleSeller>? topWholesalers = homeController.sellerRailFor(_scope, WholesaleSellerRailEnum.topWholesaler);
    final List<WholesaleProduct>? mostDemanded = homeController.productRailFor(_scope, WholesaleProductRailEnum.mostDemanded);
    final List<WholesaleSeller>? verifiedSellers = homeController.sellerRailFor(_scope, WholesaleSellerRailEnum.verifiedSeller);
    final List<WholesaleSeller>? recommended = homeController.sellerRailFor(_scope, WholesaleSellerRailEnum.recommended);
    final WholesaleBannerController bannerController = context.watch<WholesaleBannerController>();
    final List<WholesaleTrustPolicy> highlights = Provider.of<SplashController>(context, listen: false)
        .configModel?.wholesaleConfig?.trustPolicy ?? [];

    return SliverList(
      delegate: SliverChildListDelegate([
        if (highlights.isNotEmpty) ...[
          WholesaleFeatureHighlightsWidget(highlights: highlights),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        if (_isShown(homeController.recentlyViewedSellers)) ...[
          WholesaleRecentlyViewedSellersSection(sellers: homeController.recentlyViewedSellers),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        WholesaleDiscoverCategoryBanner(
          titleKey: 'discover_wholesalers_by_category',
          titleFallback: 'Discover Wholesalers by Category',
          onTap: () => RouterHelper.getWholesaleCategoryScreenRoute(
            action: RouteAction.push,
            fromWholesalers: true,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        if (_isShown(bannerController.bannersOf(WholesaleBannerTypeEnum.main.value))) ...[
          const WholesaleBannerSliderWidget(bannerType: WholesaleBannerTypeEnum.main),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        if (_isShown(homeController.categoryTabs)) ...[
          WholesaleHomeCategoryFilterSection(tabs: homeController.categoryTabs, scope: _scope),
          // const SizedBox(height: 24),
        ],

        if (_isShown(topWholesalers)) ...[
          WholesaleTopWholesalersSection(
            sellers: topWholesalers,
            backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.06),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        if (_isShown(mostDemanded)) ...[
          WholesaleMostDemandedSection(products: mostDemanded),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        if (_isShown(verifiedSellers)) ...[
          WholesaleVerifiedSellerSection(sellers: verifiedSellers),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        if (_isShown(bannerController.bannersOf(WholesaleBannerTypeEnum.mainSection.value))) ...[
          const WholesaleBannerSliderWidget(bannerType: WholesaleBannerTypeEnum.mainSection, aspectRatio: 4),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        if (_isShown(recommended))
          WholesaleRecommendedForYouSection(sellers: recommended),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ]),
    );
  }
}
