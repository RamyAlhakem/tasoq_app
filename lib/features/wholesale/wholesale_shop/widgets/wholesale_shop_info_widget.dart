import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_shop/domain/models/wholesale_shop_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleShopInfoWidget extends StatelessWidget {
  final WholesaleShopDetails shop;

  const WholesaleShopInfoWidget({super.key, required this.shop});

  static const double _logoSize = 80;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Container(
        transform: Matrix4.translationValues(0, -20, 0),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: isDark
              ? null : [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildLogo(context),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(child: _buildDetails(context)),
        ]),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
      child: Stack(children: [
        CustomImageWidget(image: shop.imageFullUrl?.path ?? '', width: _logoSize, height: _logoSize, fit: BoxFit.cover),
        if (shop.isClosed)
          Container(
            width: _logoSize,
            height: _logoSize,
            color: Colors.black.withValues(alpha: 0.5),
            alignment: Alignment.center,
            child: Text(
              shop.isTemporarilyClosed
                  ? (getTranslated('temporary_closed', context) ?? '').replaceAll(' ', '\n')
                  : getTranslated('close_for_now', context) ?? '',
              textAlign: TextAlign.center,
              style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall),
            ),
          ),
      ]),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Flexible(
          child: Text(
            shop.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
          ),
        ),
        if (shop.isVerified) ...[
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Icon(Icons.verified, size: 16, color: isDark ? Colors.white : Theme.of(context).primaryColor),
        ],
      ]),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      _buildStatsRow(context),
      if ((shop.address ?? '').isNotEmpty)
        _buildIconRow(context, Icons.location_on_outlined, shop.address!),
      if ((shop.contact ?? '').isNotEmpty)
        _buildIconRow(context, Icons.call_outlined, shop.contact!),
    ]);
  }

  Widget _buildStatsRow(BuildContext context) {
    final TextStyle style = textRegular.copyWith(
      fontSize: Dimensions.fontSizeSmall,
      color: Theme.of(context).textTheme.titleMedium?.color,
    );

    return Row(children: [
      Icon(Icons.star_rate_rounded, color: Colors.orange, size: 16),
      Text((shop.averageRating ?? 0).toStringAsFixed(1), style: style),
      Text('  |  ', style: style),
      Text('${shop.reviewCount ?? 0} ${getTranslated('reviews', context) ?? ''}', style: style),
      Text('  |  ', style: style),
      Text('${shop.totalProduct ?? 0} ${getTranslated('products', context) ?? ''}', style: style),
    ]);
  }

  Widget _buildIconRow(BuildContext context, IconData icon, String value) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 14, color: isDark ? Colors.white : Theme.of(context).hintColor),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
          ),
        ),
      ]),
    );
  }
}

class WholesaleShopInfoShimmerWidget extends StatelessWidget {
  const WholesaleShopInfoShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Container(
        transform: Matrix4.translationValues(0, -20, 0),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const WholesaleShimmerBoxWidget(width: 80, height: 80),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const WholesaleShimmerBoxWidget(width: double.infinity, height: 16),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              const WholesaleShimmerBoxWidget(width: 140, height: 12),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              const WholesaleShimmerBoxWidget(width: 90, height: 12),
            ]),
          ),
        ]),
      ),
    );
  }
}
