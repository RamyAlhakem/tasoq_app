import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_pricing_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class WholesaleCartDiscountBannerWidget extends StatefulWidget {
  final String unitLabel;
  final List<WholesaleCombinationDiscountOffer> offers;
  final void Function(WholesaleCombinationDiscountOffer offer) onSelectOffer;

  const WholesaleCartDiscountBannerWidget({
    super.key,
    required this.unitLabel,
    required this.offers,
    required this.onSelectOffer,
  });

  @override
  State<WholesaleCartDiscountBannerWidget> createState() => _WholesaleCartDiscountBannerWidgetState();
}

class _WholesaleCartDiscountBannerWidgetState extends State<WholesaleCartDiscountBannerWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final bool canExpand = widget.offers.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),

      child: Column(
        children: [
          InkWell(
            onTap: canExpand ? () => setState(() => _expanded = !_expanded) : null,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
              child: Row(children: [
                CustomAssetImageWidget(Images.wholesaleDiscountIcon, width: 20, height: 20),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        getTranslated('available_discount_for', context)!,
                        style: titleRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),

                      Text(
                        " ${widget.offers.length} ",
                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),

                      Text(
                        widget.unitLabel,
                        style: titleRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                      )

                    ],
                  )
                ),

                if (canExpand)
                  Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Theme.of(context).hintColor),

              ]),
            ),
          ),

          if (_expanded && canExpand)
            Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall, 0, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall),
              child: Wrap(
                spacing: Dimensions.paddingSizeSmall,
                runSpacing: Dimensions.paddingSizeSmall,
                children: widget.offers.map((offer) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    onTap: () => widget.onSelectOffer(offer),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Text(
                        offer.label,
                        style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
