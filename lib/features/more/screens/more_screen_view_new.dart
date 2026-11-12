import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_dashboard_summary/controllers/auction_dashboard_summary_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_dashboard_summary/domain/models/auction_dashboard_summary_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/more/widgets/logout_confirm_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/domain/models/notification_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/business_pages_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wallet/controllers/wallet_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MoreScreenView extends StatefulWidget {
  const MoreScreenView({super.key});

  @override
  State<MoreScreenView> createState() => _MoreScreenViewState();
}

class _MoreScreenViewState extends State<MoreScreenView> with TickerProviderStateMixin {
  int _selectedRailIndex = 0;
  bool _wasLoggedIn = false;

  late final List<({IconData? icon, String? image, Widget? badge, String route})> _railItems;
  late AuthController _authController;
  late TabController _tabController;
  late final bool _isAuctionEnabled;


  int _tabCount({required bool showWholesale, required bool showAuction}) => 2 + (showWholesale ? 1 : 0) + (showAuction ? 1 : 0);

  void _syncTabController(int length) {
    if (_tabController.length == length) return;

    final TabController oldController = _tabController;
    _tabController = TabController(length: length, vsync: this, initialIndex: oldController.index.clamp(0, length - 1));
    WidgetsBinding.instance.addPostFrameCallback((_) => oldController.dispose());
  }

  @override
  void initState() {
    super.initState();
    final SplashController splashController = Provider.of<SplashController>(context, listen: false);
    _isAuctionEnabled = splashController.isAuctionEnabled;
    _tabController = TabController(length: _tabCount(showWholesale: splashController.isWholesaleEnabled, showAuction: _isAuctionEnabled), vsync: this);
    _railItems = [
      (icon: Icons.notifications_outlined, image: null, badge: const NotificationRailBadge(), route: RouterHelper.notificationScreen),
      (icon: null, image: Images.menuRailAddressIcon, badge: null, route: RouterHelper.addressScreen),
      // (icon: Icons.grid_view_rounded, image: null, badge: null, route: RouterHelper.categoryScreen),
      (icon: null, image: Images.menuRailMessageIcon, badge: null, route: RouterHelper.inboxScreen),
      (icon: null, image: Images.menuRailContactIcon, badge: null, route: RouterHelper.contactUsScreen),
      (icon: null, image: Images.menuRailSettingIcon, badge: null, route: RouterHelper.settingsScreen),
    ];

    _authController = Provider.of<AuthController>(context, listen: false);
    _wasLoggedIn = _authController.isLoggedIn();
    _authController.addListener(_onAuthStateChanged);
    final notificationController =
        Provider.of<NotificationController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {if (_authController.isLoggedIn()) {
      Provider.of<ProfileController>(context, listen: false).getUserInfo(context, isLoggedIn: true);
      Provider.of<WalletController>(context, listen: false).getTransactionList(1);
      if (_isAuctionEnabled) {
        Provider.of<AuctionDashboardSummaryController>(context, listen: false).getAuctionDashboardSummary(context);
      }
      notificationController.getNotificationList(1);
      notificationController.getAuctionNotificationList(1);
      }
    });
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthStateChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    final isNowLoggedIn = _authController.isLoggedIn();
    if (isNowLoggedIn && !_wasLoggedIn) {
      _wasLoggedIn = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _onLoginSuccess();
      });
    } else if (!isNowLoggedIn) {
      _wasLoggedIn = false;
    }
  }

  void _onLoginSuccess() {
    if (!mounted) return;
    setState(() {});
    Provider.of<ProfileController>(context, listen: false).getUserInfo(context, isLoggedIn: true);
    Provider.of<WalletController>(context, listen: false).getTransactionList(1);
    if (_isAuctionEnabled) {
      Provider.of<AuctionDashboardSummaryController>(context, listen: false).getAuctionDashboardSummary(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final summaryModel = Provider.of<AuctionDashboardSummaryController>(context).summaryModel;
    final isLoggedIn = authController.isLoggedIn();
    final SplashController splashController = Provider.of<SplashController>(context, listen: false);
    final bool isWholesaleOrdersOnly = splashController.isWholesaleOrdersOnlyMode && Provider.of<ProfileController>(context).hasWholesaleOrders;
    final bool showWholesale = splashController.isWholesaleEnabled || isWholesaleOrdersOnly;
    final bool isAuctionMenuOnly = !splashController.isAuctionEnabled && isLoggedIn && Provider.of<ProfileController>(context).showAuctionMenuForUser;
    final bool showAuction = splashController.isAuctionEnabled || isAuctionMenuOnly;
    _syncTabController(_tabCount(showWholesale: showWholesale, showAuction: showAuction));

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) context.pop();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Row(
              children: [
                Container(
                  width: 56,
                  color: Theme.of(context).hintColor.withValues(alpha: 0.10),
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back_sharp,
                          size: Dimensions.iconSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _railItems.length,
                            separatorBuilder: (_, __) => const SizedBox(height: Dimensions.paddingSizeSmall),
                            itemBuilder: (context, index) {
                              return RailItem(
                                icon: _railItems[index].icon,
                                image: _railItems[index].image,
                                badge: _railItems[index].badge,
                                isSelected: _selectedRailIndex == index,
                                onTap: () {
                                  final String route = _railItems[index].route;
                                  final bool requiresLogin = route == RouterHelper.notificationScreen || route == RouterHelper.inboxScreen;
                                  if (requiresLogin && !Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                                    _showLoginSheet(context, onLoginSuccess: _onLoginSuccess);
                                    return;
                                  }
                                  setState(() => _selectedRailIndex = index);
                                  context.push(_railItems[index].route);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                        child: GestureDetector(
                          onTap: () {
                            if (!authController.isLoggedIn()) {
                              RouterHelper.getLoginRoute(action: RouteAction.push, fromPage: '${RouterHelper.dashboardScreen}?page=more');
                            } else {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (_) => const LogoutCustomBottomSheetWidget(),
                              );
                            }
                          },
                          child: Icon(
                            Icons.logout_rounded,
                            size: Dimensions.iconSizeDefault,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(width: 1, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: .15)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<ProfileController>(
                        builder: (context, profileController, _) {
                          final user = profileController.userInfoModel;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                            child: GestureDetector(
                              onTap: () {
                                if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.moreScreen, onLoginSuccess: _onLoginSuccess),
                                  );
                                } else {
                                  context.push(RouterHelper.profileScreen1);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.07),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                ),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    isLoggedIn ?
                                    ClipOval(
                                      child: CustomImageWidget(image: user?.imageFullUrl?.path ?? Images.guestProfileIcons, width: 45, height: 45,
                                      )) :
                                      Container(
                                        width: 45, height: 45,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                        ),
                                        child: Center(
                                          child: CustomAssetImageWidget(
                                            height: 24, width: 24, Images.guestModeProfileIcon,
                                          ),
                                        )
                                      ),

                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                    isLoggedIn
                                        ? Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${user?.fName ?? ''} ${user?.lName ?? ''}',
                                                  style: titilliumBold.copyWith(
                                                    fontSize: Dimensions.fontSizeDefault,
                                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                                    fontWeight: FontWeight.w500)),

                                                Text(user?.phone ?? '',
                                                  style: titilliumRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeSmall,
                                                    color: Theme.of(context).textTheme.bodySmall?.color)),
                                              ],
                                            ),
                                          )
                                        : SizedBox(height: 36, width: 70,
                                            child: CustomButton(
                                              buttonHeight: 40, borderWidth: 70,
                                              buttonText: getTranslated('sign_in', context),
                                              fontSize: Dimensions.fontSizeSmall,
                                              onTap: () {
                                                RouterHelper.getLoginRoute(action: RouteAction.push, fromPage: RouterHelper.moreScreen, onLoginSuccess: _onLoginSuccess);
                                              },
                                            ),
                                          ),
                                    if (isLoggedIn)
                                      InkWell(
                                        onTap: () {
                                          if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.moreScreen, onLoginSuccess: _onLoginSuccess),
                                            );
                                          } else {
                                            RouterHelper.getProfileScreen1Route(action: RouteAction.push);
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                          child: CustomAssetImageWidget(Images.profileEditIcon, color: Theme.of(context).primaryColor),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Expanded(
                        child: Column(
                          children: [
                            TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              dividerColor: Colors.transparent,
                              indicatorColor: Colors.transparent,
                              indicator: const BoxDecoration(),
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: WidgetStateProperty.all(Colors.transparent),
                              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault - Dimensions.paddingSizeExtraSmall),
                              labelPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              tabs: [
                                _TabChip(
                                  controller: _tabController,
                                  index: 0,
                                  label: getTranslated('general', context)!),
                                _TabChip(
                                  controller: _tabController,
                                  index: 1,
                                  label: getTranslated('retail', context)!),
                                if (showWholesale)
                                  _TabChip(
                                    controller: _tabController,
                                    index: 2,
                                    label: getTranslated('wholesale', context)!),
                                if (showAuction)
                                  _TabChip(
                                    controller: _tabController,
                                    index: showWholesale ? 3 : 2,
                                    label: getTranslated('auction', context)!),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _GeneralTabView(onLoginSuccess: _onLoginSuccess),

                                  _RetailTabView(onLoginSuccess: _onLoginSuccess),

                                  if (showWholesale) _WholesaleTabView(ordersOnly: isWholesaleOrdersOnly),

                                  if (showAuction) _AuctionTabView(onLoginSuccess: _onLoginSuccess, isLoggedIn: isLoggedIn, summaryModel: summaryModel, menuOnly: isAuctionMenuOnly),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),


                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeSmall,
                        ),
                        child: Row(
                          children: [
                            Consumer<ThemeController>(
                              builder: (context, themeController, _) => Row(
                                children: [
                                  Icon(Icons.wb_sunny_outlined, size: Dimensions.iconSizeSmall, color: Theme.of(context).hintColor),

                                  Switch(
                                    value: themeController.darkTheme,
                                    onChanged: (_) => themeController.toggleTheme(),
                                    activeThumbColor: Theme.of(context).colorScheme.primary,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),

                                  Icon(Icons.nightlight_round, size: Dimensions.iconSizeSmall, color: Theme.of(context).hintColor),
                                ],
                              ),
                            ),

                            const Spacer(),
                            Consumer<SplashController>(
                              builder: (context, splashController, _) => Text(
                                '${getTranslated('version', context)!} ${splashController.configModel?.softwareVersion ?? ''}',
                                style: titilliumRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

void _showLoginSheet(BuildContext context, {VoidCallback? onLoginSuccess}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess),
  );
}

BusinessPageModel? _findBusinessPageBySlug(
    String slug, List<BusinessPageModel>? pagesList) {
  if (pagesList == null || pagesList.isEmpty) return null;
  for (final page in pagesList) {
    if (page.slug == slug) return page;
  }
  return null;
}

class _TabChip extends StatelessWidget {
  final TabController controller;
  final int index;
  final String label;

  const _TabChip(
      {required this.controller, required this.index, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final bool isSelected = controller.index == index;
        final bool isDark = Provider.of<ThemeController>(context).darkTheme;
        return Tab(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isDark ? Colors.white.withValues(alpha: 0.12) : Theme.of(context).primaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: titilliumBold.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: isSelected ? Theme.of(context).cardColor : (isDark ? Colors.white : Colors.black),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RetailTabView extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  const _RetailTabView({required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
           MenuItem(
            iconImage: Images.couponsIcon,
            label: getTranslated('coupons', context)!,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess));
              } else {
                RouterHelper.getCouponListScreenRoute();
              }
            },
          ),
          MenuItem(
            iconImage: Images.compareIconSvg,
            label: getTranslated('compare_products', context)!,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(
                      fromPage: RouterHelper.moreScreen,
                      onLoginSuccess: onLoginSuccess),
                );
              } else {
                RouterHelper.getCompareProductScreenRoute();
              }
            },
          ),
          MenuItem(
            iconImage: Images.orderHistoryIcon,
            label: getTranslated('order_history', context)!,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(
                      fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess),
                );
              } else {
                RouterHelper.getOrderScreenRoute(action: RouteAction.push);
              }
            },
          ),
          MenuItem(
            iconImage: Images.newTrackOrderIcon,
            label: getTranslated('track_order', context)!,
            onTap: () => RouterHelper.getGuestTrackOrderRoute(action: RouteAction.push),
          ),
          MenuItem(
            iconImage: Images.offerSvg,
            label: getTranslated('offers', context)!,
            onTap: () => RouterHelper.getOfferProductListScreenRoute(action: RouteAction.push),
          ),
          MenuItem(
            iconImage: Images.cartSvg,
            label: getTranslated('cart', context)!,
            onTap: () => RouterHelper.getCartScreenRoute(action: RouteAction.push),
          ),
          MenuItem(
            iconImage: Images.wishlistSvg,
            label: getTranslated('wishlist', context)!,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.auctionQueueListScreen),
                );
              } else {
                RouterHelper.getWishListRoute(action: RouteAction.push);
              }
            },
          ),
          if (authController.isLoggedIn())
            MenuItem(
              iconImage: Images.restockRequestSvg,
              label: getTranslated('restock_requests', context)!,
              onTap: () => RouterHelper.getRestockListRoute(action: RouteAction.push),
            ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ],
      ),
    );
  }
}

class _WholesaleTabView extends StatelessWidget {
  final bool ordersOnly;
  const _WholesaleTabView({this.ordersOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          if (!ordersOnly)
          MenuItem(
            iconImage: Images.couponsIcon,
            label: getTranslated('coupons', context)!,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(
                    fromPage: RouterHelper.moreScreen,
                    onLoginSuccess: () => RouterHelper.getCouponListScreenRoute(action: RouteAction.push, isWholesale: true),
                  ),
                );
              } else {
                RouterHelper.getCouponListScreenRoute(action: RouteAction.push, isWholesale: true);
              }
            },
          ),
          if (!ordersOnly)
          MenuItem(
            iconImage: Images.wishlistSvg,
            label: getTranslated('wishlist', context)!,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.wholesaleWishlistScreen),
                );
              } else {
                RouterHelper.getWholesaleWishlistScreenRoute(action: RouteAction.push);
              }
            },
          ),
          MenuItem(
            iconImage: Images.orderHistoryIcon,
            label: getTranslated('order_history', context)!,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(
                    fromPage: RouterHelper.moreScreen,
                    onLoginSuccess: () => RouterHelper.getWholesaleOrderScreenRoute(action: RouteAction.push),
                  ),
                );
              } else {
                RouterHelper.getWholesaleOrderScreenRoute(action: RouteAction.push);
              }
            },
          ),
          MenuItem(
            iconImage: Images.newTrackOrderIcon,
            label: getTranslated('track_order', context)!,
            onTap: () => RouterHelper.getWholesaleTrackOrderScreenRoute(action: RouteAction.push),
          ),
          if (!ordersOnly)
          MenuItem(
            iconImage: Images.offerSvg,
            label: getTranslated('offers', context)!,
            onTap: () => RouterHelper.getWholesaleOffersScreenRoute(action: RouteAction.push),
          ),
          if (!ordersOnly)
          MenuItem(
            iconImage: Images.cartSvg,
            label: getTranslated('cart', context)!,
            onTap: () => RouterHelper.getWholesaleCartScreenRoute(action: RouteAction.push),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ],
      ),
    );
  }
}

class _GeneralTabView extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  const _GeneralTabView({required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    final splashController =
        Provider.of<SplashController>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: getTranslated('quick_links', context)!),
          if (splashController.configModel?.refEarningStatus == '1')
            MenuItem(
              iconImage: Images.referEarnIcon,
              label: getTranslated('refer_and_earn', context)!,
              onTap: () {
                if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess));
                } else {
                  RouterHelper.getReferAndEarnRoute(action: RouteAction.push);
                }
              },
            ),
          MenuItem(
            iconImage: Images.walletIcon,
            label: getTranslated('wallet', context)!,
            trailing: Consumer2<AuthController, WalletController>(
              builder: (context, authController, walletController, _) {
                if (!authController.isLoggedIn()) return const SizedBox.shrink();
                final balance = walletController.walletTransactionModel?.totalWalletBalance ?? 0.0;
                return TrailingBadge(
                  label: PriceConverter.convertPrice(context, balance),
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  textColor: Theme.of(context).colorScheme.primary,
                );
              },
            ),
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.auctionQueueListScreen));
              } else {
                RouterHelper.getWalletRoute(action: RouteAction.push);
              }
            },
          ),
          MenuItem(
            iconImage: Images.loyaltyPointsIcon,
            label: getTranslated('loyalty_points', context)!,
            trailing: Consumer2<AuthController, ProfileController>(
              builder: (context, authController, profileController, _) {
                if (!authController.isLoggedIn()) return const SizedBox.shrink();
                final points = profileController.userInfoModel?.loyaltyPoint ?? 0;

                return TrailingBadge(
                  label: '$points ${getTranslated('points', context)!}',
                  color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.35),
                  textColor: Theme.of(context).colorScheme.tertiary,
                );
              },
            ),
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.auctionQueueListScreen),
                );
              } else {
                RouterHelper.getLoyaltyPointScreenRoute(action: RouteAction.push);
              }
            },
          ),
          if (splashController.configModel?.blogUrl?.isNotEmpty ?? false)
            MenuItem(
              iconImage: Images.blogSvg,
              label: getTranslated('blog', context)!,
              onTap: () => RouterHelper.getBlogScreenRoute(
                action: RouteAction.push, url: splashController.configModel?.blogUrl ?? ''),
            ),

          SectionHeader(title: getTranslated('help_and_support', context)!),

          MenuItem(
            iconImage: Images.supportTicketSvg,
            label: getTranslated('support_ticket', context)!,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                _showLoginSheet(context, onLoginSuccess: onLoginSuccess);
              } else {
                RouterHelper.getSupportTicketRoute(action: RouteAction.push);
              }
            },
          ),

          if (splashController.defaultBusinessPages != null && splashController.defaultBusinessPages!.isNotEmpty) ...[
            if (_findBusinessPageBySlug('terms-and-conditions', splashController.defaultBusinessPages) != null)
              MenuItem(
                iconImage: Images.tremsConditionSvg,
                label: getTranslated('terms_condition', context)!,
                onTap: () => RouterHelper.getHtmlViewRoute(
                  page: _findBusinessPageBySlug('terms-and-conditions', splashController.defaultBusinessPages)!,
                ),
              ),

            if (_findBusinessPageBySlug('privacy-policy', splashController.defaultBusinessPages) != null)
              MenuItem(
                iconImage: Images.policySvg,
                label: getTranslated('privacy_policy', context)!,
                onTap: () => RouterHelper.getHtmlViewRoute(
                  page: _findBusinessPageBySlug('privacy-policy', splashController.defaultBusinessPages)!),
              ),

            if (_findBusinessPageBySlug('refund-policy', splashController.defaultBusinessPages) != null)
              MenuItem(
                iconImage: Images.policySvg,
                label: getTranslated('refund_policy', context)!,
                onTap: () => RouterHelper.getHtmlViewRoute(
                  page: _findBusinessPageBySlug('refund-policy', splashController.defaultBusinessPages)!),
              ),

            if (_findBusinessPageBySlug('return-policy', splashController.defaultBusinessPages) != null)
              MenuItem(
                iconImage: Images.policySvg,
                label: getTranslated('return_policy', context)!,
                onTap: () => RouterHelper.getHtmlViewRoute(
                  page: _findBusinessPageBySlug('return-policy', splashController.defaultBusinessPages)!),
              ),

            if (_findBusinessPageBySlug('cancellation-policy', splashController.defaultBusinessPages) != null)
              MenuItem(
                iconImage: Images.policySvg,
                label: getTranslated('cancellation_policy', context)!,
                onTap: () => RouterHelper.getHtmlViewRoute(
                  page: _findBusinessPageBySlug('cancellation-policy', splashController.defaultBusinessPages)!),
              ),

            if (_findBusinessPageBySlug('shipping-policy', splashController.defaultBusinessPages) != null)
              MenuItem(
                iconImage: Images.policySvg,
                label: getTranslated('shipping_policy', context)!,
                onTap: () => RouterHelper.getHtmlViewRoute(
                  page: _findBusinessPageBySlug('shipping-policy', splashController.defaultBusinessPages)!),
              ),
          ],

          MenuItem(
            iconImage: Images.faqSvg,
            label: getTranslated('faq', context)!,
            onTap: () => RouterHelper.getFaqRoute(action: RouteAction.push),
          ),
          if (_findBusinessPageBySlug('about-us', splashController.defaultBusinessPages) != null)
            MenuItem(
              iconImage: Images.aboutUsSvg,
              label: getTranslated('about_us', context)!,
              onTap: () => RouterHelper.getHtmlViewRoute(
                page: _findBusinessPageBySlug('about-us', splashController.defaultBusinessPages)!),
            ),
        ],
      ),
    );
  }
}

class _AuctionTabView extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  final bool isLoggedIn;
  final AuctionDashboardSummaryModel? summaryModel;
  final bool menuOnly;

  const _AuctionTabView({required this.onLoginSuccess, required this.isLoggedIn, required this.summaryModel, this.menuOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          SectionHeader(title: getTranslated('bidding_activity', context)!),
          MenuItem(
            iconImage: Images.navBidIcon,
            label: getTranslated('my_bids', context)!,
            badgeCount: isLoggedIn ? summaryModel?.totalMyBids : null,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(
                      fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess));
              } else {
                RouterHelper.getMyBidsScreen(action: RouteAction.push);
              }
            },
          ),
          if (!menuOnly)
          MenuItem(
            iconImage: Images.saveIcon,
            label: getTranslated('saved_auction', context)!,
            badgeCount: isLoggedIn ? summaryModel?.totalMySavedAuctions : null,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(
                      fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess));
              } else {
                RouterHelper.getSavedAuctionListScreen(action: RouteAction.push);
              }
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          SectionHeader(title: getTranslated('my_auctions', context)!),
          if (!menuOnly && Provider.of<SplashController>(context, listen: false).canCustomerCreateAuction)
            MenuItem(
              iconImage: Images.navAuctionIcon,
              label: getTranslated('create_auction', context)!,
              onTap: () {
                if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess));
                } else {
                  RouterHelper.getAddEditAuctionProductRoute(
                      action: RouteAction.push, fromDetails: false);
                }
              },
            ),
          MenuItem(
            iconImage: Images.allAuctionIcon,
            label: getTranslated('all_auctions', context)!,
            badgeCount: isLoggedIn ? summaryModel?.totalMyAuctions : null,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess));
              } else {
                RouterHelper.getUserCreatedAuctionListScreenRoute(action: RouteAction.push);
              }
            },
          ),
          MenuItem(
            iconImage: Images.navActivityIcon,
            label: getTranslated('auction_request_list', context)!,
            badgeCount: isLoggedIn ? summaryModel?.totalMyAuctionPending : null,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess));
              } else {
                RouterHelper.getAuctionQueueListRoute(action: RouteAction.push);
              }
            },
          ),
          MenuItem(
            iconImage: Images.auctionReportIcon,
            label: getTranslated('auction_sales_report', context)!,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess));
              } else {
                RouterHelper.getAuctionSalesReportRoute(action: RouteAction.push);
              }
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          MenuItem(
            iconImage: Images.transactionSvg,
            label: getTranslated('auction_transaction_history', context)!,
            onTap: () {
              if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.moreScreen, onLoginSuccess: onLoginSuccess));
              } else {
                RouterHelper.getAuctionTransactionListScreenRoute(action: RouteAction.push);
              }
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ],
      ),
    );
  }
}

class NotificationRailBadge extends StatelessWidget {
  const NotificationRailBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthController, NotificationController>(
      builder: (context, authController, notificationController, _) {
        if (!authController.isLoggedIn()) return const SizedBox.shrink();
        final count = totalNewNotification(
          notificationController.notificationModel,
          notificationController.auctionNotificationModel,
          isAuctionEnabled: Provider.of<SplashController>(context, listen: false).isAuctionEnabled,
          wholesale: notificationController.wholesaleNotificationModel,
        );
        if (count == 0) return const SizedBox.shrink();
        return RailBadge(count.toString());
      },
    );
  }
}

class RailBadge extends StatelessWidget {
  final String count;
  const RailBadge(this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        count,
        style: titilliumBold.copyWith(fontSize: 8, color: Colors.white),
      ),
    );
  }
}

class RailItem extends StatelessWidget {
  final IconData? icon;
  final String? image;
  final Widget? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const RailItem({
    super.key,
    this.icon,
    this.image,
    this.badge,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.paddingSizeEight),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (image != null)
              CustomAssetImageWidget(
                image!,
                width: Dimensions.iconSizeDefault,
                height: Dimensions.iconSizeDefault,
                color: Theme.of(context).colorScheme.primary,
              )
            else
              Icon(
                icon,
                size: Dimensions.iconSizeDefault,
                color: Theme.of(context).colorScheme.primary,
              ),
            if (badge != null) Positioned(top: -8, right: -6, child: badge!),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.paddingSizeDefault,
        right: Dimensions.paddingSizeDefault,
        top: Dimensions.paddingSizeSmall,
        bottom: Dimensions.paddingSizeExtraExtraSmall,
      ),
      child: Text(
        title,
        style: titilliumRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String iconImage;
  final String label;
  final int? badgeCount;
  final Widget? trailing;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.iconImage,
    required this.label,
    this.badgeCount,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        child: Row(
          children: [
            CustomAssetImageWidget(
              iconImage,
              width: Dimensions.iconSizeDefault,
              height: Dimensions.iconSizeDefault,
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Expanded(
              child: Text(
                label,
                style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            if (badgeCount != null)
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$badgeCount',
                    style: titilliumBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else if (trailing != null)
              trailing!,
          ],
        ),
      ),
    );
  }
}

class TrailingBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const TrailingBadge(
      {super.key,
      required this.label,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      child: Text(
        label,
        style: titilliumBold.copyWith(
          fontSize: Dimensions.fontSizeExtraSmall,
          color: textColor,
        ),
      ),
    );
  }
}
