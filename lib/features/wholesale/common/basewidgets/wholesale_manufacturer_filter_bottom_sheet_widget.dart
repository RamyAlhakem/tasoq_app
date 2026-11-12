import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleManufacturerFilterType {
  static const String all = 'all';
  static const String topWholesaler = 'top-wholesaler';
  static const String verifiedSeller = 'verified-seller';
  static const String topDiscounted = 'top-discounted';

  static const List<String> values = [all, topWholesaler, verifiedSeller, topDiscounted];

  static String labelKey(String value) => switch (value) {
        topWholesaler => 'top_wholesalers',
        verifiedSeller => 'verified_seller',
        topDiscounted => 'top_discounted_manufacturer',
        _ => 'all',
      };

  static String labelFallback(String value) => switch (value) {
        topWholesaler => 'Top Wholesalers',
        verifiedSeller => 'Verified Seller',
        topDiscounted => 'Top Discounted Manufacturer',
        _ => 'All',
      };
}

class WholesaleManufacturerFilterBottomSheet extends StatefulWidget {
  final String selectedType;

  const WholesaleManufacturerFilterBottomSheet({super.key, required this.selectedType});

  static Future<String?> show(BuildContext context, {required String selectedType}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WholesaleManufacturerFilterBottomSheet(selectedType: selectedType),
    );
  }

  @override
  State<WholesaleManufacturerFilterBottomSheet> createState() => _WholesaleManufacturerFilterBottomSheetState();
}

class _WholesaleManufacturerFilterBottomSheetState extends State<WholesaleManufacturerFilterBottomSheet> {
  late String _selected = widget.selectedType;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
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
              getTranslated('filter', context) ?? 'Filter',
              style: titilliumBold.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: WholesaleManufacturerFilterType.values
                  .map((type) => _TypeOptionTile(
                        label: getTranslated(WholesaleManufacturerFilterType.labelKey(type), context) ??
                            WholesaleManufacturerFilterType.labelFallback(type),
                        isSelected: _selected == type,
                        onTap: () => setState(() => _selected = type),
                      ))
                  .toList(),
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
                  textColor: isDark
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  radius: 8,
                  buttonText: getTranslated('clear', context),
                  onTap: () => Navigator.pop(context, WholesaleManufacturerFilterType.all),
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

class _TypeOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeOptionTile({required this.label, required this.isSelected, required this.onTap});

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
          Text(label, style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null,
          )),
        ]),
      ),
    );
  }
}
