import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/widget/auction_notification_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/widget/notification_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/widget/notification_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/widget/wholesale_notification_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  final bool fromNotification;
  final String? initialBusinessModule;
  const NotificationScreen({super.key, this.fromNotification = false, this.initialBusinessModule});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  bool _isAuctionEnabled = false;
  bool _isWholesaleEnabled = false;
  bool get _hasTabs => _isAuctionEnabled || _isWholesaleEnabled;
  TabController? _tabController;
  final ScrollController _retailScrollController = ScrollController();
  final ScrollController _auctionScrollController = ScrollController();
  final ScrollController _wholesaleScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _isAuctionEnabled = Provider.of<SplashController>(context, listen: false).isAuctionEnabled;
    _isWholesaleEnabled = Provider.of<SplashController>(context, listen: false).isWholesaleEnabled;
    if (_hasTabs) {
      final tabCount = 1 + (_isAuctionEnabled ? 1 : 0) + (_isWholesaleEnabled ? 1 : 0);
      final initialIndex = (widget.initialBusinessModule == 'wholesale' && _isWholesaleEnabled) ? tabCount - 1 : 0;
      _tabController = TabController(length: tabCount, vsync: this, initialIndex: initialIndex);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authController = Provider.of<AuthController>(context, listen: false);
      final notificationController = Provider.of<NotificationController>(context, listen: false);

      if (widget.fromNotification) {
        await Provider.of<SplashController>(context, listen: false).initConfig(context, null, null);
      }

      if (authController.isLoggedIn()) {
        notificationController.getNotificationList(1);
        if (_isAuctionEnabled) {
          notificationController.getAuctionNotificationList(1);
        }
        if (_isWholesaleEnabled) {
          notificationController.getWholesaleNotificationList(1);
        }

        final profileController = Provider.of<ProfileController>(context, listen: false);
        if (profileController.userInfoModel == null) {
          profileController.getUserInfo(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _retailScrollController.dispose();
    _auctionScrollController.dispose();
    _wholesaleScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('notification', context),
        onBackPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement);
          }
        },
      ),
      body: Provider.of<AuthController>(context, listen: false).isLoggedIn()
          ? _hasTabs
              ? Column(children: [
                  TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: getTranslated('retail', context)),
                      if (_isAuctionEnabled) Tab(text: getTranslated('auction', context)),
                      if (_isWholesaleEnabled) Tab(text: getTranslated('wholesale', context)),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController!,
                      children: [
                        RetailNotificationTab(scrollController: _retailScrollController),
                        if (_isAuctionEnabled) AuctionNotificationTab(scrollController: _auctionScrollController),
                        if (_isWholesaleEnabled) WholesaleNotificationTab(scrollController: _wholesaleScrollController),
                      ],
                    ),
                  ),
                ])
              : RetailNotificationTab(scrollController: _retailScrollController)
          : NotLoggedInWidget(
              fromPage: RouterHelper.notificationScreen,
              onLoginSuccess: () {
                RouterHelper.getNotificationRoute(action: RouteAction.pushReplacement);
              },
            ),
    );
  }
}

class RetailNotificationTab extends StatelessWidget {
  final ScrollController scrollController;

  const RetailNotificationTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationController>(
      builder: (context, notificationController, child) {
        return notificationController.notificationModel != null
            ? (notificationController.notificationModel!.notification != null && notificationController.notificationModel!.notification!.isNotEmpty)
                ? RefreshIndicator(
                    onRefresh: () async => await notificationController.getNotificationList(1),
                    child: PaginatedListView(
                      scrollController: scrollController,
                      onPaginate: (int? offset) => notificationController.getNotificationList(offset ?? 1),
                      totalSize: notificationController.notificationModel?.totalSize,
                      offset: notificationController.notificationModel?.offset,
                      itemView: Flexible(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: notificationController.notificationModel!.notification!.length,
                          itemBuilder: (context, index) => NotificationItemWidget(
                            notificationItem: notificationController.notificationModel!.notification![index],
                            index: index,
                          ),
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        ),
                      ),
                    ),
                  )
                : const NoInternetOrDataScreenWidget(isNoInternet: false, message: 'no_notification', icon: Images.noNotification)
            : const NotificationShimmerWidget();
      },
    );
  }
}

class WholesaleNotificationTab extends StatelessWidget {
  final ScrollController scrollController;

  const WholesaleNotificationTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationController>(
      builder: (context, notificationController, child) {
        return notificationController.wholesaleNotificationModel != null
            ? (notificationController.wholesaleNotificationModel!.notifications != null && notificationController.wholesaleNotificationModel!.notifications!.isNotEmpty)
                ? RefreshIndicator(
                    onRefresh: () async => await notificationController.getWholesaleNotificationList(1),
                    child: PaginatedListView(
                      scrollController: scrollController,
                      onPaginate: (int? offset) => notificationController.getWholesaleNotificationList(offset ?? 1),
                      totalSize: notificationController.wholesaleNotificationModel?.totalSize,
                      offset: notificationController.wholesaleNotificationModel?.offset,
                      itemView: Flexible(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: notificationController.wholesaleNotificationModel!.notifications!.length,
                          itemBuilder: (context, index) => WholesaleNotificationItemWidget(
                            item: notificationController.wholesaleNotificationModel!.notifications![index],
                            index: index,
                          ),
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        ),
                      ),
                    ),
                  )
                : const NoInternetOrDataScreenWidget(isNoInternet: false, message: 'no_notification', icon: Images.noNotification)
            : const NotificationShimmerWidget();
      },
    );
  }
}

class AuctionNotificationTab extends StatelessWidget {
  final ScrollController scrollController;

  const AuctionNotificationTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationController>(
      builder: (context, notificationController, child) {
        return notificationController.auctionNotificationModel != null
            ? (notificationController.auctionNotificationModel!.notifications != null && notificationController.auctionNotificationModel!.notifications!.isNotEmpty)
                ? RefreshIndicator(
                    onRefresh: () async => await notificationController.getAuctionNotificationList(1),
                    child: PaginatedListView(
                      scrollController: scrollController,
                      onPaginate: (int? offset) => notificationController.getAuctionNotificationList(offset ?? 1),
                      totalSize: notificationController.auctionNotificationModel?.totalSize,
                      offset: notificationController.auctionNotificationModel?.offset,
                      itemView: Flexible(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: notificationController.auctionNotificationModel!.notifications!.length,
                          itemBuilder: (context, index) => AuctionNotificationItemWidget(
                            item: notificationController.auctionNotificationModel!.notifications![index],
                            index: index,
                          ),
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        ),
                      ),
                    ),
                  )
                : const NoInternetOrDataScreenWidget(isNoInternet: false, message: 'no_notification', icon: Images.noNotification)
            : const NotificationShimmerWidget();
      },
    );
  }
}
