import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/app_mode_selector_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/controllers/wholesale_banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/domain/wholesale_banner_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/controllers/wholesale_ai_fab_visibility_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/controllers/wholesale_home_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_explore_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_home_search_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_products_tab_content.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/controllers/wholesale_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/widgets/wholesale_wholesalers_tab_content.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleHomeScreen extends StatefulWidget {
  const WholesaleHomeScreen({super.key});

  @override
  State<WholesaleHomeScreen> createState() => _WholesaleHomeScreenState();
}

class _WholesaleHomeScreenState extends State<WholesaleHomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  static const double _paginationTriggerOffset = 200;

  final GlobalKey _nestedKey = GlobalKey();
  final GlobalKey _exploreTabBarKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _searchBarRevealAnim;
  bool _searchBarHidden = false;

  late final WholesaleAiFabVisibilityController _aiFab;

  static const double _exploreStickyLine = kTextTabBarHeight + WholesaleHomeSearchBarWidget.height;
  static const double _exploreStickyTolerance = 4;

  final GlobalKey _searchBarKey = GlobalKey();
  final GlobalKey _productsBodyKey = GlobalKey();
  final GlobalKey _manufacturersBodyKey = GlobalKey();
  final ValueNotifier<double> _refreshEdgeOffset = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)..addListener(_onTabChanged);
    _searchBarRevealAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    )..addListener(() {
      if (mounted) setState(() {});
      _syncRefreshEdgeOffset();
    });
    _scrollController.addListener(_syncSearchBarVisibility);
    _scrollController.addListener(_syncRefreshEdgeOffset);

    _aiFab = WholesaleAiFabVisibilityController(vsync: this, scrollController: _scrollController, nested: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Provider.of<WholesaleHomeController>(context, listen: false).fetchWithCache(isLoggedIn: _isLoggedIn);
    });
  }

  void _onTabChanged() {
    if (_tabController.index != 0 && _searchBarHidden) {
      _searchBarHidden = false;
      _searchBarRevealAnim.value = 1.0;
    }
    setState(() {});

    if (_tabController.index == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncSearchBarVisibility());
    }
  }

  void _syncSearchBarVisibility() {
    if (!mounted || _tabController.index != 0) return;

    final RenderObject? tabBar = _exploreTabBarKey.currentContext?.findRenderObject();
    final RenderObject? nested = _nestedKey.currentContext?.findRenderObject();

    bool reachedHeader = false;
    if (tabBar is RenderBox && tabBar.attached && tabBar.hasSize && nested is RenderBox) {
      final double top = tabBar.localToGlobal(Offset.zero, ancestor: nested).dy;
      reachedHeader = _searchBarHidden
          ? top < _exploreStickyLine + _exploreStickyTolerance
          : top <= _exploreStickyLine + _exploreStickyTolerance;
    }

    if (reachedHeader == _searchBarHidden) return;
    _searchBarHidden = reachedHeader;
    _searchBarRevealAnim.animateTo(reachedHeader ? 0.0 : 1.0, curve: reachedHeader ? Curves.easeOut : Curves.easeIn);
  }

  void _syncRefreshEdgeOffset() {
    if (!mounted) return;

    final RenderObject? searchBar = _searchBarKey.currentContext?.findRenderObject();
    final RenderObject? body = (_productsBodyKey.currentContext ?? _manufacturersBodyKey.currentContext)?.findRenderObject();
    if (searchBar is! RenderBox || body is! RenderBox || !searchBar.attached || !body.attached) return;

    final double searchBarBottom = searchBar.localToGlobal(Offset.zero).dy + _SliverSearchBarDelegate._height * _searchBarRevealAnim.value;
    final double bodyTop = body.localToGlobal(Offset.zero).dy;
    final double offset = (searchBarBottom - bodyTop).clamp(0.0, double.infinity);

    if ((offset - _refreshEdgeOffset.value).abs() > 0.5) _refreshEdgeOffset.value = offset;
  }

  @override
  void dispose() {
    _refreshEdgeOffset.dispose();
    _aiFab.dispose();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.removeListener(_syncSearchBarVisibility);
    _scrollController.removeListener(_syncRefreshEdgeOffset);
    _scrollController.dispose();
    _searchBarRevealAnim.dispose();
    super.dispose();
  }

  bool get _isLoggedIn => Provider.of<AuthController>(context, listen: false).isLoggedIn();

  Future<void> _refreshHomeSections() {
    final WholesaleBannerController bannerController = Provider.of<WholesaleBannerController>(context, listen: false);

    return Future.wait([
      Provider.of<WholesaleHomeController>(context, listen: false).getAllHomeSections(isLoggedIn: _isLoggedIn),
      bannerController.getBannerList(bannerType: WholesaleBannerTypeEnum.main.value, reload: true),
      bannerController.getBannerList(bannerType: WholesaleBannerTypeEnum.mainSection.value, reload: true),
    ]);
  }

  Future<void> _refreshManufacturersTab() async {
    await Future.wait([
      _refreshHomeSections(),
      Provider.of<WholesaleHomeController>(context, listen: false).refreshCategoryRails(WholesaleHomeTabScope.manufacturers),
    ]);
  }

  Future<void> _refreshProductsTab() async {
    final WholesaleProductController productController = Provider.of<WholesaleProductController>(context, listen: false);
    productController.clearCategoryProductCache();
    productController.clearRailProductCache();

    await Future.wait([
      _refreshHomeSections(),
      Provider.of<WholesaleHomeController>(context, listen: false).refreshCategoryRails(WholesaleHomeTabScope.products),
      productController.getRecentlyViewedProducts(isLoggedIn: _isLoggedIn, reload: true),
      productController.getCategoryProducts(productController.selectedCategoryId, 1),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          floatingActionButton: Provider.of<SplashController>(context, listen: false).configModel?.wholesaleConfig?.aiShoppingAssistantStatus == true
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 68),
                  child: SlideTransition(
                    position: _aiFab.slide,
                    child: FadeTransition(
                      opacity: _aiFab.fade,
                      child: FloatingActionButton(
                        onPressed: () => RouterHelper.getWholesaleAiShoppingRoute(action: RouteAction.push),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 4,
                        shape: const CircleBorder(),
                        child: const Icon(Icons.auto_awesome, color: Colors.white),
                      ),
                    ),
                  ),
                )
              : null,
          body: NotificationListener<ScrollNotification>(
            onNotification: _aiFab.onScrollNotification,
            child: NestedScrollView(
            key: _nestedKey,
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: false,
                  elevation: 0,
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).primaryColor,
                  toolbarHeight: 0,
                  expandedHeight: 44,
                  flexibleSpace: _CustomizableSpaceBarWidget(
                    builder: (context, scrollingRate) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeSmall,
                          left: Dimensions.homePagePadding,
                          right: Dimensions.homePagePadding
                        ),
                        child: Opacity(
                          opacity: (1 - scrollingRate).clamp(0.0, 1.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(child: AppModeSelectorWidget()),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Consumer<ProfileController>(
                                builder: (context, profileController, _) => GestureDetector(
                                  onTap: () => RouterHelper.getMoreScreenRoute(action: RouteAction.push),
                                  child: ClipOval(
                                    child: CustomImageWidget(
                                      image: profileController.userInfoModel?.imageFullUrl?.path ?? '',
                                      width: 32, height: 32,
                                      placeholder: Images.guestProfile,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    primary: false,
                    elevation: 0,
                    backgroundColor: Theme.of(context).primaryColor,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    floating: true,
                    expandedHeight: 0,
                    toolbarHeight: 0,
                    surfaceTintColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).primaryColor,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      controller: _tabController,
                      isScrollable: false,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 4, color: Theme.of(context).colorScheme.secondary),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        insets: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withValues(alpha: 0.65),
                      labelStyle: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, height: 1.0),
                      unselectedLabelStyle: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, height: 1.0),
                      tabs: [
                        Tab(text: getTranslated('products', context)!),
                        Tab(text: getTranslated('manufacturers', context)!),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverSearchBarDelegate(
                    revealT: _searchBarRevealAnim.value,
                    child: Container(
                      key: _searchBarKey,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: InkWell(
                        onTap: () => _tabController.index == 0
                            ? RouterHelper.getWholesaleSearchScreenRoute(action: RouteAction.push)
                            : RouterHelper.getWholesaleManufacturerSearchScreenRoute(action: RouteAction.push),
                        child: WholesaleHomeSearchBarWidget(
                          hintText: _tabController.index == 0 ? null : (getTranslated('search_manufacturers', context) ?? 'Search Manufacturers'),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                Builder(
                  builder: (context) => ValueListenableBuilder<double>(
                    valueListenable: _refreshEdgeOffset,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification.metrics.axis != Axis.vertical) return false;

                        _syncSearchBarVisibility();
                        if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent - _paginationTriggerOffset) {
                          context.read<WholesaleProductController>().loadNextPage();
                        }
                        return false;
                      },
                      child: CustomScrollView(
                        key: _productsBodyKey,
                        slivers: [
                          SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                          const WholesaleProductsTabContent(),
                          WholesaleExploreSection(tabBarKey: _exploreTabBarKey),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: Dimensions.paddingSizeSmall + kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
                            ),
                          ),
                        ],
                      ),
                    ),
                    builder: (context, edgeOffset, child) => RefreshIndicator(
                      onRefresh: _refreshProductsTab,
                      edgeOffset: edgeOffset,
                      child: child!,
                    ),
                  ),
                ),
                Builder(
                  builder: (context) => ValueListenableBuilder<double>(
                    valueListenable: _refreshEdgeOffset,
                    builder: (context, edgeOffset, child) => RefreshIndicator(
                      onRefresh: _refreshManufacturersTab,
                      edgeOffset: edgeOffset,
                      child: child!,
                    ),
                    child: CustomScrollView(
                      key: _manufacturersBodyKey,
                      slivers: [
                        SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                        const WholesaleWholesalersTabContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  final double revealT;

  static const double _height = WholesaleHomeSearchBarWidget.height;

  const _SliverSearchBarDelegate({required this.child, required this.revealT});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.topCenter,
        minHeight: 0,
        maxHeight: _height,
        child: Opacity(opacity: revealT, child: child),
      ),
    );
  }

  @override
  double get maxExtent => _height * revealT;

  @override
  double get minExtent => _height * revealT;

  @override
  bool shouldRebuild(_SliverSearchBarDelegate oldDelegate) => oldDelegate.child != child || oldDelegate.revealT != revealT;
}

class _CustomizableSpaceBarWidget extends StatelessWidget {
  final Widget Function(BuildContext context, double scrollingRate) builder;

  const _CustomizableSpaceBarWidget({required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
        final deltaExtent = settings.maxExtent - settings.minExtent;
        final scrollingRate = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);
        return builder(context, scrollingRate);
      },
    );
  }
}
