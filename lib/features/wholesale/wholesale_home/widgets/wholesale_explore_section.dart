import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/widgets/wholesale_home_brand_section_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/controllers/wholesale_category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/domain/models/wholesale_category_node_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_explore_tab_bar.dart';import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/controllers/wholesale_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class WholesaleExploreSection extends StatefulWidget {
  final GlobalKey? tabBarKey;

  const WholesaleExploreSection({super.key, this.tabBarKey});

  @override
  State<WholesaleExploreSection> createState() => _WholesaleExploreSectionState();
}

class _WholesaleExploreSectionState extends State<WholesaleExploreSection> {
  static const int _shimmerItemCount = 6;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Provider.of<WholesaleCategoryController>(context, listen: false).getCategoryList();

      Provider.of<WholesaleProductController>(context, listen: false).getCategoryProductsDebounced(null);
    });
  }

  void _selectTab(int index, List<WholesaleCategoryNode> categories) {
    Provider.of<WholesaleProductController>(context, listen: false)
        .selectCategory(index == 0 ? null : categories[index - 1].id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WholesaleCategoryController, WholesaleProductController>(
      builder: (context, categoryController, productController, _) {
        final List<WholesaleCategoryNode> categories = categoryController.categoryList;
        final List<String> tabNames = [
          getTranslated('all', context) ?? 'All',
          ...categories.map((category) => category.name ?? ''),
        ];

        final int? selectedCategoryId = productController.selectedCategoryId;
        final int selectedIndex = selectedCategoryId == null
            ? 0
            : categories.indexWhere((category) => category.id == selectedCategoryId) + 1;

        final WholesaleProductListModel? model = productController.categoryProductsFor(selectedCategoryId);
        final List<WholesaleProduct> products = model?.products ?? [];
        final Color backgroundColor = Theme.of(context).cardColor;

        return SliverMainAxisGroup(
          slivers: [
            const SliverToBoxAdapter(child: WholesaleHomeBrandSectionWidget()),

            SliverToBoxAdapter(
              child: Container(
                color: backgroundColor,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    WholesaleSectionHeader(
                      titleKey: 'explore_all_items',
                      titleFallback: 'Explore All Items',
                      showViewAll: false,
                    ),
                  ],
                ),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _ExploreTabBarDelegate(
                containerKey: widget.tabBarKey,
                backgroundColor: backgroundColor,
                child: WholesaleExploreTabBar(
                  tabNames: tabNames,
                  selectedIndex: selectedIndex,
                  onTabSelected: (index) => _selectTab(index, categories),
                ),
              ),
            ),

            if (model == null)
              _buildGrid(
                context,
                backgroundColor: backgroundColor,
                itemCount: _shimmerItemCount,
                itemBuilder: (_, __) => const WholesaleProductCardShimmerWidget(),
              )
            else if (products.isEmpty)
              SliverToBoxAdapter(child: _buildEmptyState(context, backgroundColor))
            else
              _buildGrid(
                context,
                backgroundColor: backgroundColor,
                itemCount: products.length,
                itemBuilder: (context, index) => RepaintBoundary(child: WholesaleProductCardWidget(product: products[index])),
              ),

            if (productController.isPaginating)
              SliverToBoxAdapter(
                child: Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildGrid(
    BuildContext context, {
    required Color backgroundColor,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return DecoratedSliver(
      decoration: BoxDecoration(color: backgroundColor),
      sliver: SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          Dimensions.homePagePadding - Dimensions.paddingSizeExtraSmall,
          Dimensions.paddingSizeSmall,
          Dimensions.homePagePadding - Dimensions.paddingSizeExtraSmall,
          0,
        ),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
          childCount: itemCount,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: itemBuilder(context, index),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color backgroundColor) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.homePagePadding,
        vertical: Dimensions.paddingSizeExtraLarge,
      ),
      child: Center(
        child: Text(
          getTranslated('no_product_found', context) ?? 'No product found',
          style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}

class _ExploreTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color backgroundColor;
  final Key? containerKey;

  static const double _height = 44;

  const _ExploreTabBarDelegate({
    required this.child,
    required this.backgroundColor,
    this.containerKey,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      key: containerKey,
      color: backgroundColor,
      alignment: AlignmentDirectional.bottomStart,
      child: child,
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(_ExploreTabBarDelegate oldDelegate) =>
      oldDelegate.child != child || oldDelegate.backgroundColor != backgroundColor || oldDelegate.containerKey != containerKey;
}
