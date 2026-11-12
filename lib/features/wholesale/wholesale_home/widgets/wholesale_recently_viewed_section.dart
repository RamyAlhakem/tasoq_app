import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/controllers/wholesale_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/enums/wholesale_product_list_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleRecentlyViewedSection extends StatefulWidget {
  const WholesaleRecentlyViewedSection({super.key});

  @override
  State<WholesaleRecentlyViewedSection> createState() => _WholesaleRecentlyViewedSectionState();
}

class _WholesaleRecentlyViewedSectionState extends State<WholesaleRecentlyViewedSection> {
  static const int _shimmerItemCount = 3;
  static const int _viewAllThreshold = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Provider.of<WholesaleProductController>(context, listen: false).getRecentlyViewedProducts(
        isLoggedIn: Provider.of<AuthController>(context, listen: false).isLoggedIn(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.45;

    return Consumer<WholesaleProductController>(
      builder: (context, productController, _) {
        final List<WholesaleProduct>? products = productController.recentlyViewedProducts;
        final int totalSize = productController.recentlyViewedModel?.totalSize ?? products?.length ?? 0;

        if (products != null && products.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Theme.of(context).cardColor, Theme.of(context).cardColor.withValues(alpha: 0)]
                      : const [Color(0xFFFFFFFF), Color(0x00FFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  WholesaleSectionHeader(
                    titleKey: 'recently_viewed',
                    titleFallback: 'Recently Viewed',
                    showViewAll: totalSize > _viewAllThreshold,
                    onViewAll: () => RouterHelper.getWholesaleViewAllProductsScreenRoute(
                      action: RouteAction.push,
                      type: WholesaleProductListType.recentlyViewed,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  SizedBox(
                    height: cardWidth + 105,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.homePagePadding,
                      ),
                      itemCount: products?.length ?? _shimmerItemCount,
                      separatorBuilder: (_, __) => const SizedBox(width: Dimensions.paddingSizeSmall),
                      itemBuilder: (context, index) => SizedBox(
                        width: cardWidth,
                        child: products == null
                            ? const WholesaleProductCardShimmerWidget()
                            : WholesaleProductCardWidget(product: products[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ],
        );
      },
    );
  }
}
