import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/di_container.dart' as di;
import 'package:flutter_sixvalley_ecommerce/features/home/screens/home_screens.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_filter_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_list_result_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_sort_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_search_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/domain/models/wholesale_product_filter_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/controllers/wholesale_shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/widgets/wholesale_shop_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/widgets/wholesale_shop_header_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/widgets/wholesale_shop_overview_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleShopScreen extends StatelessWidget {
  final String slug;
  final int? shopId;
  final String? shopName;

  const WholesaleShopScreen({super.key, required this.slug, this.shopId, this.shopName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WholesaleShopController>(
      create: (_) => di.sl<WholesaleShopController>(),
      child: _WholesaleShopView(slug: slug, shopId: shopId, shopName: shopName),
    );
  }
}

class _WholesaleShopView extends StatefulWidget {
  final String slug;
  final int? shopId;
  final String? shopName;

  const _WholesaleShopView({required this.slug, this.shopId, this.shopName});

  @override
  State<_WholesaleShopView> createState() => _WholesaleShopViewState();
}

class _WholesaleShopViewState extends State<_WholesaleShopView> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleShopController>(context, listen: false).bind(slug: widget.slug, shopId: widget.shopId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    _searchController.clear();
    final WholesaleShopController controller = _controller;
    controller.setTabIndex(index);
    if (index == 0 && controller.query.isNotEmpty) controller.clearSearch();
  }

  void _showAllProducts() {
    _tabController.animateTo(1);
    _onTabChanged(1);
  }

  WholesaleShopController get _controller => Provider.of<WholesaleShopController>(context, listen: false);

  void _back() => Navigator.of(context).pop();

  Future<void> _openSortSheet() async {
    final WholesaleSortOption? sort = await WholesaleProductSortBottomSheet.show(context, selected: _controller.filter.sort);
    if (sort == null || !mounted) return;

    _controller.applySort(sort);
    _controller.loadProducts(page: 1);
  }

  Future<void> _openFilterSheet() async {
    final WholesaleProductFilterModel? filter = await WholesaleProductFilterBottomSheet.show(
      context,
      currentFilter: _controller.filter,
      priceBounds: _controller.priceBounds,
    );
    if (filter == null || !mounted) return;

    _controller.applyFilter(filter);
    _controller.loadProducts(page: 1);
  }

  void _clearFilter() {
    _controller.clearFilter();
    _controller.loadProducts(page: 1);
  }

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    _controller.search(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    _controller.clearSearch();
  }

  void _openCoupons() {
    RouterHelper.getWholesaleShopCouponScreenRoute(
      action: RouteAction.push,
      slug: widget.slug,
      shopName: _controller.shopDetails?.name ?? widget.shopName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Consumer<WholesaleShopController>(
      builder: (context, controller, _) {
        final String? paginationError = controller.paginationError;
        if (paginationError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            controller.consumePaginationError();
            showCustomSnackBarWidget(
              getTranslated(paginationError, context), context, snackBarType: SnackBarType.error,
            );
          });
        }

        if (controller.shopNotFound) {
          return Scaffold(
            appBar: CustomAppBar(title: widget.shopName ?? getTranslated('store', context)),
            body: NoInternetOrDataScreenWidget(isNoInternet: false, message: getTranslated('shop_not_found', context)),
          );
        }

        if (controller.shopErrorMessage != null && !controller.canLoadProducts) {
          return Scaffold(
            appBar: CustomAppBar(title: widget.shopName ?? getTranslated('store', context)),
            body: _buildFullError(context, controller),
          );
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: CustomScrollView(controller: _scrollController, slivers: [
            WholesaleShopAppBarWidget(
              title: controller.shopDetails?.name ?? widget.shopName ?? getTranslated('store', context) ?? '',
              onBack: _back,
              scrollController: _scrollController,
            ),

            SliverToBoxAdapter(
              child: WholesaleShopHeaderWidget(shop: controller.shopDetails, isLoading: controller.isShopLoading),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: SliverDelegate(
                height: controller.tabIndex == 1 ? 120 : 50,
                child: Container(
                  color: isDark ? Theme.of(context).cardColor : Theme.of(context).canvasColor,
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeEight),
                          child: TabBar(
                            controller: _tabController,
                            physics: const NeverScrollableScrollPhysics(),
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            dividerColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor: Theme.of(context).hintColor,
                            indicatorColor: Theme.of(context).primaryColor,
                            indicatorWeight: 1,
                            indicatorPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            labelStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w700),
                            unselectedLabelStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w400),
                            onTap: _onTabChanged,
                            tabs: [
                              Tab(text: getTranslated('overview', context)),
                              Tab(text: getTranslated('all_products', context)),
                            ],
                          ),
                        ),
                      ),
                      if (controller.tabIndex == 1) ...[
                        _buildIconButton(context, icon: Images.sort, isApplied: controller.isSortApplied, onTap: _openSortSheet),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: Dimensions.homePagePadding),
                          child: _buildIconButton(
                            context, icon: Images.filterIcon, isApplied: controller.isFilterApplied, onTap: _openFilterSheet,
                          ),
                        ),
                      ],
                    ]),
                    if (controller.tabIndex == 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                          vertical: Dimensions.paddingSizeExtraSmall,
                        ),
                        child: WholesaleSearchBarWidget(
                          controller: _searchController,
                          hintText: getTranslated('search_products', context),
                          onChanged: () => setState(() {}),
                          onSubmitted: (_) => _submitSearch(),
                          onSearchPressed: _submitSearch,
                          onClearPressed: _clearSearch,
                        ),
                      ),
                  ]),
                ),
              ),
            ),

            if (controller.tabIndex == 0)
              SliverToBoxAdapter(
                child: WholesaleShopOverviewWidget(
                  controller: controller,
                  onSeeAllProducts: _showAllProducts,
                  onSeeAllCoupons: _openCoupons,
                ),
              )
            else
              SliverToBoxAdapter(
                child: WholesaleProductListResultWidget(
                  source: controller,
                  scrollController: _scrollController,
                  isNested: true,
                  showHeader: false,
                  onSortTap: _openSortSheet,
                  onFilterTap: _openFilterSheet,
                  onClearFilter: _clearFilter,
                  onRetry: () => controller.loadProducts(page: 1),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeLarge)),
          ]),
        );
      },
    );
  }

  Widget _buildIconButton(BuildContext context, {required String icon, required bool isApplied, required VoidCallback onTap}) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Stack(clipBehavior: Clip.none, children: [
      InkWell(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .5) : Theme.of(context).primaryColor.withValues(alpha: .5)),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          ),
          child: Center(
            child: CustomAssetImageWidget(
              icon,
              width: 15,
              height: 15,
              color: isDark ? Colors.white : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      if (isApplied)
        PositionedDirectional(
          top: -2,
          end: -2,
          child: CircleAvatar(radius: 5, backgroundColor: Theme.of(context).primaryColor),
        ),
    ]);
  }

  Widget _buildFullError(BuildContext context, WholesaleShopController controller) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return SingleChildScrollView(
      child: Column(children: [
        NoInternetOrDataScreenWidget(
          isNoInternet: false,
          message: getTranslated(controller.shopErrorMessage ?? 'something_went_wrong', context),
        ),
        Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          child: OutlinedButton(
            style: isDark ? OutlinedButton.styleFrom(foregroundColor: Theme.of(context).textTheme.bodyLarge?.color) : null,
            onPressed: () => controller.bind(slug: widget.slug, shopId: widget.shopId),
            child: Text(getTranslated('try_again', context) ?? ''),
          ),
        ),
      ]),
    );
  }
}
