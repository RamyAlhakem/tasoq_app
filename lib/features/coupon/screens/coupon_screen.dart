import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/controllers/wholesale_coupon_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/widgets/wholesale_coupon_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/controllers/coupon_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/widgets/coupon_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/widgets/order_shimmer_widget.dart';
import 'package:provider/provider.dart';

class CouponList extends StatefulWidget {
  final bool isWholesale;
  const CouponList({super.key, this.isWholesale = false});

  @override
  State<CouponList> createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if(Provider.of<AuthController>(context, listen: false).isLoggedIn()){
        if(widget.isWholesale) {
          Provider.of<WholesaleCouponController>(context, listen: false).getCouponList(offset: 1, reload: true);
        } else {
          Provider.of<CouponController>(context, listen: false).getCouponList(context, 1);
        }
        if(Provider.of<ProfileController>(context, listen: false).userInfoModel == null) {
          Provider.of<ProfileController>(context, listen: false).getUserInfo(context);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('coupons', context)),
      body: Provider.of<AuthController>(context, listen: false).isLoggedIn()?
      Column(
        children: [
          Expanded(child: _CouponListContent(isWholesale: widget.isWholesale)),
        ],
      ): NotLoggedInWidget(
        fromPage: RouterHelper.couponListScreen,
        onLoginSuccess: (){
          RouterHelper.getCouponListScreenRoute(action: RouteAction.pushReplacement, isWholesale: widget.isWholesale);
        }
      ),
    );
  }
}

class _CouponListContent extends StatefulWidget {
  final bool isWholesale;
  const _CouponListContent({required this.isWholesale});

  @override
  State<_CouponListContent> createState() => _CouponListContentState();
}

class _CouponListContentState extends State<_CouponListContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isWholesale) {
      return Consumer<WholesaleCouponController>(
        builder: (context, couponProvider,_) => _buildList(
          isLoaded: couponProvider.couponList != null,
          itemCount: couponProvider.couponList?.length ?? 0,
          totalSize: couponProvider.couponResponseModel?.totalSize,
          offset: couponProvider.couponResponseModel?.offset,
          limit: couponProvider.couponResponseModel?.limit ?? 25,
          onPaginate: (offset) async => await couponProvider.getCouponList(offset: offset ?? 1),
          itemBuilder: (context, index)=> WholesaleCouponItemWidget(coupon: couponProvider.couponList![index]),
        ),
      );
    }

    return Consumer<CouponController>(
      builder: (context, couponProvider,_) => _buildList(
        isLoaded: couponProvider.couponList != null,
        itemCount: couponProvider.couponList?.length ?? 0,
        totalSize: couponProvider.couponItemModel?.totalSize,
        offset: couponProvider.couponItemModel?.offset,
        limit: couponProvider.couponItemModel?.limit ?? 25,
        onPaginate: (offset) async => await couponProvider.getCouponList(context, offset ?? 1),
        itemBuilder: (context, index)=> CouponItemWidget(coupons: couponProvider.couponList![index]),
      ),
    );
  }

  Widget _buildList({
    required bool isLoaded,
    required int itemCount,
    required int? totalSize,
    required int? offset,
    required int limit,
    required Future<void> Function(int? offset) onPaginate,
    required Widget Function(BuildContext context, int index) itemBuilder,
  }) {
    return isLoaded ? itemCount > 0 ?
    PaginatedListView(
      scrollController: _scrollController,
      totalSize: totalSize,
      offset: offset,
      limit: limit,
      onPaginate: onPaginate,
      itemView: Expanded(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  itemBuilder,
                  childCount: itemCount,
                ),
              ),
            ),
          ],
        ),
      ),
    ) :
    const NoInternetOrDataScreenWidget(isNoInternet: false,
      icon: Images.noCoupon, message: 'no_coupon_available') : const OrderShimmerWidget();
  }
}