import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/controllers/wholesale_coupon_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/widgets/wholesale_coupon_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/widgets/wholesale_coupon_list_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleShopCouponScreen extends StatefulWidget {
  final String slug;
  final String? shopName;
  const WholesaleShopCouponScreen({super.key, required this.slug, this.shopName});

  @override
  State<WholesaleShopCouponScreen> createState() => _WholesaleShopCouponScreenState();
}

class _WholesaleShopCouponScreenState extends State<WholesaleShopCouponScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleCouponController>(context, listen: false)
          .getShopCouponList(widget.slug, offset: 1, reload: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.shopName ?? getTranslated('coupons', context)),
      body: Consumer<WholesaleCouponController>(
        builder: (context, couponProvider, _) {
          if (couponProvider.shopCouponList == null) {
            return const WholesaleCouponListShimmer();
          }

          if (couponProvider.shopNotFound) {
            return const Center(
              child: NoInternetOrDataScreenWidget(
                isNoInternet: false,
                icon: Images.noCoupon,
                message: 'shop_not_found',
              ),
            );
          }

          if (couponProvider.shopCouponList!.isEmpty) {
            return const Center(
              child: NoInternetOrDataScreenWidget(
                isNoInternet: false,
                icon: Images.noCoupon,
                message: 'no_coupon_available',
              ),
            );
          }

          return PaginatedListView(
            scrollController: _scrollController,
            totalSize: couponProvider.shopCouponResponseModel?.totalSize,
            offset: couponProvider.shopCouponResponseModel?.offset,
            limit: couponProvider.shopCouponResponseModel?.limit ?? 25,
            onPaginate: (offset) async =>
                await couponProvider.getShopCouponList(widget.slug, offset: offset ?? 1),
            itemView: Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => WholesaleCouponItemWidget(
                          coupon: couponProvider.shopCouponList![index],
                        ),
                        childCount: couponProvider.shopCouponList!.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
