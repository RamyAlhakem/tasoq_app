import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/domain/models/wholesale_shop_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/widgets/wholesale_shop_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/widgets/wholesale_shop_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class WholesaleShopHeaderWidget extends StatelessWidget {
  final WholesaleShopDetails? shop;
  final bool isLoading;

  const WholesaleShopHeaderWidget({super.key, required this.shop, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.paddingOf(context).top;
    final double bannerHeight = WholesaleShopAppBarWidget.bannerHeight(context);
    final double toolbarHeight = kToolbarHeight + topPadding;

    return Column(children: [
      SizedBox(
        height: bannerHeight - kToolbarHeight,
        child: Stack(clipBehavior: Clip.none, children: [
          PositionedDirectional(
            top: -toolbarHeight,
            start: 0,
            end: 0,
            height: bannerHeight + topPadding,
            child: _Banner(shop: shop, isLoading: isLoading, height: bannerHeight + topPadding),
          ),
        ]),
      ),

      if (isLoading && shop == null)
        const WholesaleShopInfoShimmerWidget()
      else if (shop != null)
        WholesaleShopInfoWidget(shop: shop!)
      else
        const SizedBox(height: Dimensions.paddingSizeSmall),
    ]);
  }
}

class _Banner extends StatelessWidget {
  final WholesaleShopDetails? shop;
  final bool isLoading;
  final double height;

  const _Banner({required this.shop, required this.isLoading, required this.height});

  @override
  Widget build(BuildContext context) {
    if (isLoading && shop == null) {
      return WholesaleShimmerBoxWidget(width: double.infinity, height: height, borderRadius: 0);
    }

    return CustomImageWidget(
      image: shop?.bannerFullUrl?.path ?? '',
      placeholder: Images.placeholder_3x1,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
