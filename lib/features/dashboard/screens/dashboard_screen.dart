import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/screens/wholesale_cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_cart_count_badge_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/screens/wholesale_category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/screens/wholesale_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/screens/wholesale_order_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/screens/wholesale_offers_screen.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/screens/my_auction_activity_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/screens/my_bids_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_category/controllers/auction_category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_category/screens/auction_category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_home/controllers/auction_home_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_home/screens/auction_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/screens/offers_product_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/screens/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/widgets/cart_count_badge_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/home_explore_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/restock/controllers/restock_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wallet/controllers/wallet_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/color_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/network_info.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/widgets/app_exit_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/aster_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/fashion_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/screens/order_screen.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  final int? pageIndex;
  const DashBoardScreen({super.key, required this.pageIndex});
  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();

  bool singleVendor = false;

  late List<Widget> _mainScreens;
  late List<Widget> _auctionScreens;
  late List<Widget> _wholesaleScreens;
  late final ValueNotifier<bool> _loginNotifier;
  AppMode? _lastMode;

  final ValueNotifier<int> _homeResetNotifier = ValueNotifier(0);
  final ValueNotifier<int> _auctionResetNotifier = ValueNotifier(0);

  bool _checkIsLoggedIn() =>
      Provider.of<AuthController>(context, listen: false).isLoggedIn();

  void refreshLoginStatus() {
    _loginNotifier.value = _checkIsLoggedIn();
  }

  @override
  void initState() {
    super.initState();
    _loginNotifier = ValueNotifier(_checkIsLoggedIn());

    Provider.of<FlashDealController>(context, listen: false)
        .getFlashDealList(true, false);
    Provider.of<SplashController>(context, listen: false)
        .getBusinessPagesList('default');
    Provider.of<SplashController>(context, listen: false)
        .getBusinessPagesList('pages');
    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<CartController>(context, listen: false).mergeGuestCart();
      Provider.of<WishListController>(context, listen: false).getWishList('');
      Provider.of<ChatController>(context, listen: false)
          .getChatList(1, reload: false, userType: 0);
      Provider.of<ChatController>(context, listen: false)
          .getChatList(1, reload: false, userType: 1);
      Provider.of<RestockController>(context, listen: false)
          .getRestockProductList(1, getAll: true);
      Provider.of<WalletController>(context, listen: false)
          .getTransactionList(1, isUpdate: false);
    }

    final SplashController splashController =
        Provider.of<SplashController>(context, listen: false);
    singleVendor = splashController.configModel?.businessMode == "single";
    Provider.of<SearchProductController>(context, listen: false)
        .getAuthorList(null);
    Provider.of<SearchProductController>(context, listen: false)
        .getPublishingHouseList(null);

    if (splashController.configModel?.activeTheme == "default") {
      // HomePage.loadData(false);
    } else if (splashController.configModel?.activeTheme == "theme_aster") {
      AsterThemeHomeScreen.loadData(false);
    } else {
      FashionThemeHomePage.loadData(false);
    }

    // final Widget homeScreen = (splashController.configModel?.activeTheme == "default")
    //   ? const HomePage()
    //   : (splashController.configModel?.activeTheme == "theme_aster")
    //     ? const AsterThemeHomeScreen()
    //     : const HomePage();

    final Widget homeScreen = HomeExploreScreen(
      resetToExploreListenable: _homeResetNotifier,
      onAuctionSeeAll: () => splashController.enterAuctionTab(),
    );

    _mainScreens = [
      homeScreen,
      const OfferProductListScreen(isBacButtonExist: false),
      const CategoryScreen(isBacButtonExist: false),
      const CartScreen(showBackButton: false, fromDashboard: true),
      OrderScreen(
        isBacButtonExist: false,
        fromDashboard: true,
        loginNotifier: _loginNotifier,
        onLoginSuccess: () => splashController.selectMainTab(4),
      ),
    ];

    _auctionScreens = [
      AuctionHomeScreen(resetToExploreListenable: _auctionResetNotifier),
      const AuctionCategoryScreen(isBacButtonExist: false),
      MyBidsScreen(
        showBackButton: false,
        fromDashboard: true,
        loginNotifier: _loginNotifier,
        onLoginSuccess: () => splashController.selectAuctionTab(2),
      ),
      MyAuctionActivityScreen(
        isBackButtonExist: false,
        fromDashboard: true,
        loginNotifier: _loginNotifier,
        onLoginSuccess: () => splashController.selectAuctionTab(3),
      ),
    ];

    _wholesaleScreens = [
      const WholesaleHomeScreen(),
      const WholesaleOffersScreen(isBackButtonExist: false),
      const WholesaleCategoryScreen(),
      const WholesaleCartScreen(showBackButton: false),
      const WholesaleOrderScreen(isBackButtonExist: false),
    ];

    splashController.initDashboardTab(widget.pageIndex,
        mainTabCount: _mainScreens.length, isUpdate: false);

    NetworkInfo.checkConnectivity(context);

    _loadHomeData();

    _lastMode = splashController.currentMode;
    if (splashController.currentMode == AppMode.auction) {
      _loadAuctionData();
    }
  }

  @override
  void dispose() {
    _loginNotifier.dispose();
    _homeResetNotifier.dispose();
    _auctionResetNotifier.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    refreshLoginStatus();

    final splashController =
        Provider.of<SplashController>(context, listen: false);

    if (splashController.currentMode == AppMode.main) {
      if (index == 0) _homeResetNotifier.value++;
      splashController.selectMainTab(index);
    } else if (splashController.currentMode == AppMode.auction) {
      if (index == 0) _auctionResetNotifier.value++;
      splashController.selectAuctionTab(index);
    } else {
      splashController.selectWholesaleTab(index);
    }
  }

  Future<void> _loadHomeData() async {
    print(
        "---Dashboard-IsLoggedIn: ${Provider.of<AuthController>(context, listen: false).isLoggedIn()}");
    await Future.wait([
      Provider.of<ProfileController>(context, listen: false).getUserInfo(
          context,
          isLoggedIn:
              Provider.of<AuthController>(context, listen: false).isLoggedIn()),
      Provider.of<CategoryController>(context, listen: false).fetchWithCache(),
      Provider.of<BannerController>(context, listen: false).fetchWithCache(),
      Provider.of<FeaturedDealController>(context, listen: false).fetchWithCache(),
      Provider.of<ProductController>(context, listen: false).loadHomeDataWithCache(),
      Provider.of<ShopController>(context, listen: false).fetchWithCache(),
    ]);
  }

  Future<void> _loadAuctionData() async {
    await Future.wait([
      Provider.of<AuctionHomeController>(context, listen: false).fetchWithCache(
          isLoggedIn:
              Provider.of<AuthController>(context, listen: false).isLoggedIn()),
      Provider.of<AuctionCategoryController>(context, listen: false)
          .fetchWithCache(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final splashController = context.watch<SplashController>();
    final currentMode = splashController.currentMode;
    final selectedIndex = splashController.selectedIndex;

    if (_lastMode != currentMode) {
      _lastMode = currentMode;
      if (currentMode == AppMode.auction) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadAuctionData());
      }
    }
    final activeColor = currentMode == AppMode.main
        ? Theme.of(context).primaryColor
        : currentMode == AppMode.auction
            ? Colors.orange
            : Colors.blue;

    final screens = currentMode == AppMode.main
        ? _mainScreens
        : currentMode == AppMode.auction
            ? _auctionScreens
            : _wholesaleScreens;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (selectedIndex != 0) {
          _onItemTapped(0);
          return;
        }

        if (context.mounted) {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: Get.context!,
              builder: (_) => const AppExitCard());
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        body: PageStorage(
          bucket: bucket,
          child: IndexedStack(
            index: selectedIndex,
            children: screens,
          ),
        ),
        bottomNavigationBar: ElevatedNavBar(
          currentMode: currentMode,
          selectedIndex: selectedIndex,
          activeColor: activeColor,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class ElevatedNavBar extends StatelessWidget {
  final AppMode currentMode;
  final int selectedIndex;
  final Color activeColor;
  final ValueChanged<int> onItemTapped;

  const ElevatedNavBar({
    super.key,
    required this.currentMode,
    required this.selectedIndex,
    required this.activeColor,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.03),
              offset: const Offset(-2, 0),
              blurRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: ColoredBox(
            color: ColorHelper.blendColors(
                Theme.of(context).scaffoldBackgroundColor, Colors.black, 0.12),
            child: SizedBox(
              height: 60,
              child: ElevatedCard(
                currentMode: currentMode,
                selectedIndex: selectedIndex,
                activeColor: activeColor,
                onItemTapped: onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ElevatedCard extends StatelessWidget {
  final AppMode currentMode;
  final int selectedIndex;
  final Color activeColor;
  final ValueChanged<int> onItemTapped;

  const ElevatedCard({
    super.key,
    required this.currentMode,
    required this.selectedIndex,
    required this.activeColor,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraSmall),
        child: currentMode == AppMode.main
            ? Row(
                key: const ValueKey('main_menus'),
                children: [
                  NavItem(
                      icon: Images.navHomeIcon,
                      selectedIcon: Images.homeSelectedNavIcon,
                      label: getTranslated('ecom', context) ?? 'eCom',
                      index: 0,
                      selectedIndex: selectedIndex,
                      onTap: onItemTapped),
                  NavItem(
                      icon: Images.offerNavIcon,
                      selectedIcon: Images.offersSelectedNavIcon,
                      label: getTranslated('offers', context) ?? 'Offer',
                      index: 1,
                      selectedIndex: selectedIndex,
                      onTap: onItemTapped),
                  NavItem(
                      icon: Images.categoryNavIcon,
                      selectedIcon: Images.categorySelectedNavIcon,
                      label: getTranslated('category', context) ?? 'Category',
                      index: 2,
                      selectedIndex: selectedIndex,
                      onTap: onItemTapped),
                  NavItem(
                      icon: Images.navCartIcon,
                      selectedIcon: Images.cartSelectedNavIcon,
                      label: getTranslated('cart', context) ?? 'Cart',
                      index: 3,
                      selectedIndex: selectedIndex,
                      onTap: onItemTapped,
                      badge: const CartCountBadgeWidget()),
                  NavItem(
                      icon: Images.orderNavIcon,
                      selectedIcon: Images.ordersSelectedNavIcon,
                      label: getTranslated('orders', context) ?? 'Orders',
                      index: 4,
                      selectedIndex: selectedIndex,
                      onTap: onItemTapped),
                ],
              )
            : currentMode == AppMode.auction
                ? Row(
                    key: const ValueKey('auction_menus'),
                    children: [
                      NavItem(
                          icon: Images.homeNavBarIcon,
                          selectedIcon: Images.homeSelectedNavIcon,
                          label: getTranslated('home', context) ?? 'Home',
                          index: 0,
                          selectedIndex: selectedIndex,
                          onTap: onItemTapped),
                      NavItem(
                          icon: Images.categoryNavIcon,
                          selectedIcon: Images.categorySelectedNavIcon,
                          label:
                              getTranslated('category', context) ?? 'Category',
                          index: 1,
                          selectedIndex: selectedIndex,
                          onTap: onItemTapped),
                      NavItem(
                          icon: Images.myBidsNavIcon,
                          selectedIcon: Images.myBidsNavBarIcon,
                          label: getTranslated('my_bid', context) ?? 'My Bid',
                          index: 2,
                          selectedIndex: selectedIndex,
                          onTap: onItemTapped),
                      NavItem(
                          icon: Images.myActivityNavIcon,
                          selectedIcon: Images.myActivitySelectedNavIcon,
                          label: getTranslated('my_activity', context) ??
                              'My Activity',
                          index: 3,
                          selectedIndex: selectedIndex,
                          onTap: onItemTapped),
                    ],
                  )
                : Row(
                    key: const ValueKey('wholesale_menus'),
                    children: [
                      NavItem(
                          icon: Images.navHomeIcon,
                          selectedIcon: Images.homeSelectedNavIcon,
                          label: getTranslated('home', context) ?? 'Home',
                          index: 0,
                          selectedIndex: selectedIndex,
                          onTap: onItemTapped),
                      NavItem(
                          icon: Images.offerNavIcon,
                          selectedIcon: Images.offersSelectedNavIcon,
                          label: getTranslated('offers', context) ?? 'Offer',
                          index: 1,
                          selectedIndex: selectedIndex,
                          onTap: onItemTapped),
                      NavItem(
                          icon: Images.categoryNavIcon,
                          selectedIcon: Images.categorySelectedNavIcon,
                          label:
                              getTranslated('category', context) ?? 'Category',
                          index: 2,
                          selectedIndex: selectedIndex,
                          onTap: onItemTapped),
                      NavItem(
                          icon: Images.navCartIcon,
                          selectedIcon: Images.cartSelectedNavIcon,
                          label: getTranslated('cart', context) ?? 'Cart',
                          index: 3,
                          selectedIndex: selectedIndex,
                          onTap: onItemTapped,
                          badge: const WholesaleCartCountBadgeWidget()),
                      NavItem(
                          icon: Images.orderNavIcon,
                          selectedIcon: Images.ordersSelectedNavIcon,
                          label: getTranslated('orders', context) ?? 'Orders',
                          index: 4,
                          selectedIndex: selectedIndex,
                          onTap: onItemTapped),
                    ],
                  ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String icon;
  final String? selectedIcon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  final Widget? badge;

  const NavItem({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return Expanded(
      flex: isSelected ? 4 : 2,
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedContainer(
            duration:
                isSelected ? const Duration(milliseconds: 250) : Duration.zero,
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: isSelected
                  ? Dimensions.paddingSizeTwelve
                  : Dimensions.paddingSizeEight,
              vertical: isSelected
                  ? Dimensions.paddingSizeEight
                  : Dimensions.paddingSizeExtraSmall,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(clipBehavior: Clip.none, children: [
                  CustomAssetImageWidget(
                    isSelected && selectedIcon != null ? selectedIcon! : icon,
                    height: isSelected
                        ? Dimensions.paddingSizeDefaultAddress
                        : Dimensions.paddingSizeLarge,
                    color: isSelected ? Colors.white : Colors.grey.shade500,
                  ),
                  if (badge != null && !isSelected)
                    Positioned(top: -6, right: -8, child: badge!),
                ]),
                if (isSelected)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: Dimensions.paddingSizeExtraSmall),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: Text(
                          label,
                          style: textBold.copyWith(
                            fontSize: Dimensions.paddingSizeSmall,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
