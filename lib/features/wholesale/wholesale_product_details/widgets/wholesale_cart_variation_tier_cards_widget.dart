import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_pricing_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCartVariationTierCardsWidget extends StatelessWidget {
  final List<WholesaleQuantityTier> tiers;
  final List<double?> tierPrices;
  final int selectedTierIndex;
  final double bleed;
  final ValueChanged<int>? onTapTierIndex;

  const WholesaleCartVariationTierCardsWidget({
    super.key,
    required this.tiers,
    required this.tierPrices,
    required this.selectedTierIndex,
    this.bleed = Dimensions.homePagePadding,
    this.onTapTierIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double fullWidth = constraints.maxWidth + bleed * 2;

      return OverflowBox(
        minWidth: fullWidth,
        maxWidth: fullWidth,
        fit: OverflowBoxFit.deferToChild,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: bleed),
          child: Row(
            children: List.generate(tiers.length, (index) {
              final WholesaleQuantityTier tier = tiers[index];
              final double? price = index < tierPrices.length ? tierPrices[index] : null;
              final String pcs = getTranslated('pcs', context) ?? 'pcs';

              return Padding(
                padding: EdgeInsetsDirectional.only(end: index == tiers.length - 1 ? 0 : Dimensions.paddingSizeSmall),
                child: _WholesaleCartVariationTierCard(
                  rangeLabel: tier.maxQty != null ? '${tier.minQty} - ${tier.maxQty} $pcs' : '${tier.minQty}+ $pcs',
                  priceLabel: price != null ? PriceConverter.convertPrice(context, price) : '',
                  isSelected: index == selectedTierIndex,
                  onTap: onTapTierIndex == null ? null : () => onTapTierIndex!(index),
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}

class _WholesaleCartVariationTierCard extends StatelessWidget {
  final String rangeLabel;
  final String priceLabel;
  final bool isSelected;
  final VoidCallback? onTap;

  const _WholesaleCartVariationTierCard({required this.rangeLabel, required this.priceLabel, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.paddingSizeEight),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.homePagePadding - (isSelected ? 4 : 3),
          vertical: Dimensions.paddingSizeEight - (isSelected ? 2 : 1),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeEight),
          border: Border.all(
            color: isSelected ? primary : Theme.of(context).hintColor.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              rangeLabel,
              style: titilliumRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: isSelected ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            CustomDirectionalityWidget(
              child: Text(
                priceLabel,
                style: (isSelected ? titilliumBold : titilliumSemiBold).copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: isSelected ? primary : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
