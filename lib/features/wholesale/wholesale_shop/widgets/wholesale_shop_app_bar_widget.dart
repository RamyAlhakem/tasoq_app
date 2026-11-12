import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleShopAppBarWidget extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final ScrollController scrollController;

  const WholesaleShopAppBarWidget({super.key, required this.title, required this.onBack, required this.scrollController});

  static double bannerHeight(BuildContext context) => ResponsiveHelper.isTab(context) ? 250 : 120;

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.paddingOf(context).top;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _ToolbarDelegate(
        height: kToolbarHeight + topPadding,
        topPadding: topPadding,
        collapseExtent: bannerHeight(context) - kToolbarHeight,
        title: title,
        onBack: onBack,
        scrollController: scrollController,
      ),
    );
  }
}

class _ToolbarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final double topPadding;
  final double collapseExtent;
  final String title;
  final VoidCallback onBack;
  final ScrollController scrollController;

  const _ToolbarDelegate({
    required this.height,
    required this.topPadding,
    required this.collapseExtent,
    required this.title,
    required this.onBack,
    required this.scrollController,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(covariant _ToolbarDelegate oldDelegate) {
    return height != oldDelegate.height ||
        collapseExtent != oldDelegate.collapseExtent ||
        title != oldDelegate.title ||
        scrollController != oldDelegate.scrollController;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final double offset = scrollController.hasClients ? scrollController.position.pixels : 0;
        final double collapsed = collapseExtent <= 0 ? 1 : (offset / collapseExtent).clamp(0.0, 1.0);

        return Stack(children: [
          Positioned.fill(
            child: Opacity(opacity: collapsed, child: ColoredBox(color: Theme.of(context).cardColor)),
          ),
          Positioned(
            top: topPadding,
            left: 0,
            right: 0,
            height: kToolbarHeight,
            child: Row(children: [
              _BackButton(onTap: onBack),
              Expanded(
                child: Opacity(
                  opacity: collapsed,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeSmall, end: Dimensions.paddingSizeDefault),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ]);
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 15),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
          child: const Padding(
            padding: EdgeInsetsDirectional.only(start: Dimensions.paddingSizeSmall),
            child: Icon(Icons.arrow_back_ios, size: 18),
          ),
        ),
      ),
    );
  }
}
