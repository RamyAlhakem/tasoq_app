import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/controllers/wholesale_search_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleSearchDefaultViewWidget extends StatelessWidget {
  final ValueChanged<String> onTermSelected;

  const WholesaleSearchDefaultViewWidget({super.key, required this.onTermSelected});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final List<String> history = context.select<WholesaleSearchController, List<String>>((c) => c.history);

    if (history.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getTranslated('search_history', context) ?? 'Search History',
                style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              InkWell(
                onTap: () => Provider.of<WholesaleSearchController>(context, listen: false).clearHistory(),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Text(
                    getTranslated('clear_all', context) ?? 'Clear All',
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: isDark ? Colors.white : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Wrap(
            spacing: Dimensions.paddingSizeSmall,
            runSpacing: Dimensions.paddingSizeSmall,
            children: List.generate(history.length, (index) {
              final String term = history[index];
              return InkWell(
                onTap: () => onTermSelected(term),
                borderRadius: BorderRadius.circular(Dimensions.radiusThirty),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusThirty),
                    border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(term, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    InkWell(
                      onTap: () => Provider.of<WholesaleSearchController>(context, listen: false).removeSearchName(index),
                      child: Icon(Icons.close, size: 16, color: Theme.of(context).hintColor),
                    ),
                  ]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
