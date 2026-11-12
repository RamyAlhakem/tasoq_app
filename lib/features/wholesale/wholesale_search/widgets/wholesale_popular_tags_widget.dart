import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/controllers/wholesale_search_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/domain/models/wholesale_popular_tag_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WholesalePopularTagsWidget extends StatelessWidget {
  final ValueChanged<String> onTagSelected;

  const WholesalePopularTagsWidget({super.key, required this.onTagSelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleSearchController>(
      builder: (context, controller, _) {
        if (controller.isPopularTagsLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
            child: WholesalePopularTagsShimmer(),
          );
        }

        final List<WholesalePopularTag> tags = controller.popularTagModel?.popularTags ?? [];
        if (tags.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslated('popular_tag', context) ?? 'Popular Tag',
                style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Wrap(
                spacing: Dimensions.paddingSizeSmall,
                runSpacing: Dimensions.paddingSizeSmall,
                children: [
                  for (final WholesalePopularTag tag in tags)
                    WholesalePopularTagChip(label: tag.tag, onTap: () => onTagSelected(tag.tag)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class WholesalePopularTagChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const WholesalePopularTagChip({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusThirty),
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusThirty),
          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
        ),
        child: Text(
          label,
          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class WholesalePopularTagsShimmer extends StatelessWidget {
  const WholesalePopularTagsShimmer({super.key});

  static const List<double> _tagWidths = [60, 90, 70, 110, 50, 80, 100, 65];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context).darkTheme;
    final Color shimmerColor = isDark ? Theme.of(context).primaryColor.withValues(alpha: .05) : Theme.of(context).cardColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).cardColor,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        child: Wrap(
          spacing: Dimensions.paddingSizeSmall,
          runSpacing: Dimensions.paddingSizeSmall,
          children: _tagWidths.map((width) {
            return Container(
              width: width,
              height: 30,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusThirty),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
