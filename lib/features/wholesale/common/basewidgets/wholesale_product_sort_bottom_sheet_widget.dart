import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/domain/models/wholesale_product_filter_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleProductSortBottomSheet extends StatefulWidget {
  final WholesaleSortOption selected;

  const WholesaleProductSortBottomSheet({super.key, required this.selected});

  static Future<WholesaleSortOption?> show(BuildContext context, {required WholesaleSortOption selected}) {
    return showModalBottomSheet<WholesaleSortOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WholesaleProductSortBottomSheet(selected: selected),
    );
  }

  @override
  State<WholesaleProductSortBottomSheet> createState() => _WholesaleProductSortBottomSheetState();
}

class _WholesaleProductSortBottomSheetState extends State<WholesaleProductSortBottomSheet> {
  late WholesaleSortOption _selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + Dimensions.paddingSizeDefault),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Center(
            child: Container(
              width: 35,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.homePagePadding),
            child: Text(
              getTranslated('sort_by', context) ?? 'Sort By',
              style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: WholesaleSortOption.values
                  .map((option) => _SortOptionTile(
                        label: getTranslated(option.titleKey, context) ?? option.titleFallback,
                        isSelected: _selected == option,
                        onTap: () => setState(() => _selected = option))).toList(),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
            child: Row(children: [
              SizedBox(
                width: 120,
                child: CustomButton(
                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: .5),
                  textColor: Provider.of<ThemeController>(context, listen: false).darkTheme
                      ? Colors.white : Theme.of(context).primaryColor,
                  radius: 8,
                  buttonText: getTranslated('clear', context),
                  onTap: () => Navigator.pop(context, WholesaleSortOption.latest),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: CustomButton(
                  radius: 8,
                  buttonText: getTranslated('apply', context),
                  onTap: () => Navigator.pop(context, _selected),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOptionTile({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected
                ? (isDark ? Colors.white : Theme.of(context).primaryColor)
                : (isDark ? Theme.of(context).hintColor.withValues(alpha: .5) : Theme.of(context).hintColor),
            size: Dimensions.iconSizeSmall,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(label, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
        ]),
      ),
    );
  }
}
