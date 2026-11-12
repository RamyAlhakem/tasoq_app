import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/controllers/wholesale_banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/domain/wholesale_banner_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/widgets/wholesale_banner_slider_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/controllers/wholesale_home_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_discover_category_banner.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_feature_highlights_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_home_category_filter_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_best_wholesale_prices_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_most_demanded_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_recently_ordered_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_recently_viewed_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_top_wholesalers_section.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleProductsTabContent extends StatelessWidget {
  const WholesaleProductsTabContent({super.key});

  static bool _isShown(List? rows) => rows == null || rows.isNotEmpty;
  static const WholesaleHomeTabScope _scope = WholesaleHomeTabScope.products;

  @override
  Widget build(BuildContext context) {
    final WholesaleHomeController homeController = context.watch<WholesaleHomeController>();
    final List<WholesaleProduct>? mostDemanded = homeController.productRailFor(_scope, WholesaleProductRailEnum.mostDemanded);
    final List<WholesaleProduct>? bestPrices = homeController.productRailFor(_scope, WholesaleProductRailEnum.bestPrice);
    final List<WholesaleSeller>? topWholesalers = homeController.sellerRailFor(_scope, WholesaleSellerRailEnum.topWholesaler);
    final bool isLoggedIn = context.watch<AuthController>().isLoggedIn();
    final WholesaleBannerController bannerController = context.watch<WholesaleBannerController>();
    final List<WholesaleTrustPolicy> highlights = Provider.of<SplashController>(context, listen: false)
        .configModel?.wholesaleConfig?.trustPolicy ?? [];

    return SliverList(
      delegate: SliverChildListDelegate([
        if (highlights.isNotEmpty) ...[
          WholesaleFeatureHighlightsWidget(highlights: highlights),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],

        const WholesaleRecentlyViewedSection(),

        if (isLoggedIn && _isShown(homeController.recentOrders)) ...[
          WholesaleRecentlyOrderedSection(orders: homeController.recentOrders),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],

        ...[
          WholesaleDiscoverCategoryBanner(
            onTap: () => RouterHelper.getWholesaleCategoryScreenRoute(action: RouteAction.push),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],



        if (_isShown(bannerController.bannersOf(WholesaleBannerTypeEnum.main.value))) ...[
          const WholesaleBannerSliderWidget(bannerType: WholesaleBannerTypeEnum.main),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        if (_isShown(homeController.categoryTabs)) ...[
          WholesaleHomeCategoryFilterSection(tabs: homeController.categoryTabs, scope: _scope),
          const SizedBox(height: 14),
        ],
        if (_isShown(mostDemanded)) ...[
          WholesaleMostDemandedSection(products: mostDemanded),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        if (_isShown(bestPrices)) ...[
          WholesaleBestWholesalePricesSection(products: bestPrices),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        if (_isShown(topWholesalers)) ...[
          WholesaleTopWholesalersSection(sellers: topWholesalers),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
        if (_isShown(bannerController.bannersOf(WholesaleBannerTypeEnum.mainSection.value))) ...[
          const WholesaleBannerSliderWidget(bannerType: WholesaleBannerTypeEnum.mainSection, aspectRatio: 4),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
      ]),
    );
  }
}
