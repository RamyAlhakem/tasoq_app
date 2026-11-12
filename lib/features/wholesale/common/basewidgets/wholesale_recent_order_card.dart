import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_recent_order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/helper/wholesale_cart_action_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleRecentOrderCard extends StatelessWidget {
  final WholesaleRecentOrder order;

  const WholesaleRecentOrderCard({super.key, required this.order});

  static const double _imageSize = 32;
  static const double _overlap = 14;
  static const int _maxVisible = 3;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopSection(context),
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return InkWell(
      onTap: order.shopSlug == null ? null : () => RouterHelper.getWholesaleShopRoute(
        action: RouteAction.push,
        slug: order.shopSlug!,
        shopId: order.shopId,
        shopName: order.shopName,
      ),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeSmall,
        ),
        child: Row(
          children: [
            ClipOval(
              child: CustomImageWidget(
                width: 38,
                height: 38,
                image: order.shopLogoUrl?.path ?? '',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.shopName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: titilliumBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
                  Text(
                    order.orderDate != null ? DateConverter.estimatedDate(order.orderDate!.toLocal()) : '',
                    textDirection: TextDirection.ltr,
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeEight, vertical: Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusThirty)),
      ),
      child: Row(
        children: [
          _buildOverlappingImages(context),
          const Spacer(),
          CustomDirectionalityWidget(
            child: Text(
              PriceConverter.convertPrice(context, order.orderTotal),
              style: titilliumBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          _WholesaleReorderButton(orderId: order.id),
        ],
      ),
    );
  }

  Widget _buildOverlappingImages(BuildContext context) {
    final List<WholesaleOrderItemPreview> previews = order.itemPreviews;
    if (previews.isEmpty) return const SizedBox.shrink();

    final int visibleCount = previews.length.clamp(0, _maxVisible);
    final int remaining = previews.length - visibleCount;
    final double stackWidth = _imageSize + (visibleCount - 1) * (_imageSize - _overlap);

    return SizedBox(
      width: stackWidth,
      height: _imageSize,
      child: Stack(
        children: List.generate(visibleCount, (index) {
          final bool isLast = index == visibleCount - 1;
          final bool showOverlay = isLast && remaining > 0;

          return PositionedDirectional(
            start: index * (_imageSize - _overlap),
            child: Container(
              width: _imageSize,
              height: _imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
              ),
              child: ClipOval(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomImageWidget(
                      image: previews[index].thumbnail?.path ?? '',
                      fit: BoxFit.cover,
                    ),
                    if (showOverlay)
                      ColoredBox(
                        color: Colors.black54,
                        child: Center(
                          child: Text('+$remaining',
                            style: titilliumBold.copyWith(
                              color: Colors.white,
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _WholesaleReorderButton extends StatefulWidget {
  final int? orderId;
  const _WholesaleReorderButton({required this.orderId});

  @override
  State<_WholesaleReorderButton> createState() => _WholesaleReorderButtonState();
}

class _WholesaleReorderButtonState extends State<_WholesaleReorderButton> {
  bool _isBusy = false;

  Future<void> _onTap() async {
    setState(() => _isBusy = true);
    try {
      await wholesaleReorderToCart(context, orderId: widget.orderId!);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.orderId == null || _isBusy ? null : _onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CustomAssetImageWidget(Images.cartSvg, width: 18, height: 18, color: Colors.white),
        ),
      ),
    );
  }
}
