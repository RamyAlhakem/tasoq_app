import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WholesaleFeatureHighlightsWidget extends StatelessWidget {
  final List<WholesaleTrustPolicy> highlights;

  const WholesaleFeatureHighlightsWidget({
    super.key,
    required this.highlights,
  });

  static const double _iconSize = 22;

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
        itemCount: highlights.length,
        separatorBuilder: (_, __) => const SizedBox(width: Dimensions.paddingSizeEight),
        itemBuilder: (context, index) => _buildChip(context, highlights[index]),
      ),
    );
  }

  Widget _buildChip(BuildContext context, WholesaleTrustPolicy highlight) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeEight),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIcon(highlight.iconFullUrl?.path ?? ''),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          SizedBox(
            width: 88,
            child: Text(
              highlight.title ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: titilliumSemiBold.copyWith(
                height: 1.0,
                fontSize: Dimensions.fontSizeSmall,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String url) {
    final bool isSvg = (Uri.tryParse(url)?.path ?? url).toLowerCase().endsWith('.svg');

    if (!isSvg) {
      return CustomImageWidget(image: url, width: _iconSize, height: _iconSize, fit: BoxFit.contain);
    }

    return SvgPicture.network(
      url, width: _iconSize, height: _iconSize, fit: BoxFit.contain,
      placeholderBuilder: (_) => const SizedBox(width: _iconSize, height: _iconSize),
      errorBuilder: (_, __, ___) => const SizedBox(width: _iconSize, height: _iconSize),
    );
  }
}
