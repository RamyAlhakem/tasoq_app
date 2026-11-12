import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleVariationOption {
  final String value;
  final Color? color;

  const WholesaleVariationOption({required this.value, this.color});
}

class WholesaleProductVariation {
  final String name;
  final List<WholesaleVariationOption> options;

  const WholesaleProductVariation({required this.name, required this.options});
}

const double _kChipSize = 35;
const double _kChipSpacing = Dimensions.paddingSizeSmall;
const int _kLabelMaxLength = 100;

class WholesaleProductVariationWidget extends StatelessWidget {
  final List<WholesaleProductVariation> variations;
  final VoidCallback? onSelectVariation;

  const WholesaleProductVariationWidget({
    super.key,
    required this.variations,
    this.onSelectVariation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.homePagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WholesaleVariationHeader(onSelectVariation: onSelectVariation),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            ...variations.map((variation) => WholesaleVariationAxisRow(
                  variation: variation,
                  onSelectVariation: onSelectVariation,
                )),
          ],
        ),
      ),
    );
  }
}

class WholesaleVariationHeader extends StatelessWidget {
  final VoidCallback? onSelectVariation;

  const WholesaleVariationHeader({super.key, this.onSelectVariation});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          getTranslated('variations', context) ?? 'Variations',
          style: titilliumSemiBold.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        InkWell(
          onTap: onSelectVariation,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
              vertical: Dimensions.paddingSizeExtraSmall,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            child: Text(
              getTranslated('select_variation', context) ?? 'Select Variation',
              style: titilliumRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
                decorationColor: isDark ? Colors.white : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WholesaleVariationAxisRow extends StatelessWidget {
  final WholesaleProductVariation variation;
  final VoidCallback? onSelectVariation;

  const WholesaleVariationAxisRow({super.key, required this.variation, this.onSelectVariation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(variation.name,
            style: titilliumBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Wrap(spacing: _kChipSpacing, runSpacing: _kChipSpacing,
            children: [
              for (final WholesaleVariationOption option in variation.options)
                WholesaleVariationOptionChip(option: option, onTap: onSelectVariation),
            ],
          ),
        ],
      ),
    );
  }
}

class WholesaleVariationOptionChip extends StatelessWidget {
  final WholesaleVariationOption option;
  final VoidCallback? onTap;

  const WholesaleVariationOptionChip({super.key, required this.option, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isColor = option.color != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isColor ? _kChipSize : null,
        height: _kChipSize,
        constraints: const BoxConstraints(minWidth: _kChipSize),
        padding: isColor ? null : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: isColor ? option.color : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).hintColor.withValues(alpha: 0.3),
          ),
        ),
        child: isColor ? null
            : Center(
                widthFactor: 1,
                child: Text(
                  option.value.length > _kLabelMaxLength ? '${option.value.substring(0, _kLabelMaxLength)}...' : option.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
      ),
    );
  }
}
