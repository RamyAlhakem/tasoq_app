import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_pricing_model.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleCartVariationSelectorWidget extends StatelessWidget {
  final List<WholesaleVariationAttribute> attributes;
  final Map<String, int> selectedIndexByAttribute;
  final void Function(String attributeName, int optionIndex) onSelect;

  const WholesaleCartVariationSelectorWidget({
    super.key,
    required this.attributes,
    required this.selectedIndexByAttribute,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(attributes.length, (index) {
        final WholesaleVariationAttribute attribute = attributes[index];

        return Padding(
          padding: EdgeInsets.only(bottom: index == attributes.length - 1 ? 0 : Dimensions.paddingSizeDefault),
          child: _WholesaleCartVariationAttributeRow(
            attribute: attribute,
            selectedIndex: selectedIndexByAttribute[attribute.name] ?? 0,
            onSelect: (optionIndex) => onSelect(attribute.name, optionIndex),
          ),
        );
      }),
    );
  }
}

class _WholesaleCartVariationAttributeRow extends StatelessWidget {
  final WholesaleVariationAttribute attribute;
  final int selectedIndex;
  final void Function(int optionIndex) onSelect;

  const _WholesaleCartVariationAttributeRow({required this.attribute, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          attribute.name,
          style: titilliumBold.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Wrap(
          spacing: Dimensions.paddingSizeSmall,
          runSpacing: Dimensions.paddingSizeSmall,
          children: List.generate(attribute.options.length, (optionIndex) {
            final WholesaleVariationOptionValue option = attribute.options[optionIndex];
            return _WholesaleCartVariationOptionChip(
              option: option,
              isSelected: optionIndex == selectedIndex,
              onTap: () => onSelect(optionIndex),
            );
          }),
        ),
      ],
    );
  }
}

class _WholesaleCartVariationOptionChip extends StatelessWidget {
  final WholesaleVariationOptionValue option;
  final bool isSelected;
  final VoidCallback onTap;

  const _WholesaleCartVariationOptionChip({required this.option, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isSwatch = option.swatch != null;
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          isSwatch
              ? Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                    border: Border.all(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: option.swatch,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(
                        color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).hintColor.withAlpha(30),
                    border: Border.all(width: 1, color: isSelected ? Theme.of(context).primaryColor : Colors.transparent),
                  ),
                  child: Text(
                    option.value,
                    style: titleRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.titleMedium?.color,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
          if (option.hasDiscount)
            PositionedDirectional(
              top: -6,
              end: -6,
              child: Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: isDark ? Theme.of(context).colorScheme.error : Colors.red, shape: BoxShape.circle),
                child: const Text('%', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
