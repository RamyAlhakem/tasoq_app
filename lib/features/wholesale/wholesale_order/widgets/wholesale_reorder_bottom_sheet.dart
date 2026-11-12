import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';

class WholesaleReorderBottomSheet extends StatelessWidget {
  final List<WholesaleOrderProductItemModel> products;

  const WholesaleReorderBottomSheet({super.key, required this.products});

  List<WholesaleOrderProductItemModel> get _availableProducts => products.where((p) => p.isAvailable).toList();

  void _addAvailableToCart(BuildContext context) {
    if (_availableProducts.isEmpty) return;

    Navigator.pop(context);
    RouterHelper.getWholesaleCartScreenRoute(action: RouteAction.push);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasUnavailableItems = products.any((p) => !p.isAvailable);
    final int availableCount = _availableProducts.length;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Center(
              child: Container(
                width: 35,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                  color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(Dimensions.homePagePadding, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, 0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(getTranslated('reorder_items', context)!,
                  style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.cancel, color: Theme.of(context).hintColor, size: 30),
                ),
              ]),
            ),

            if (hasUnavailableItems)
              Padding(
                padding: const EdgeInsets.fromLTRB(Dimensions.homePagePadding, Dimensions.paddingSizeSmall, Dimensions.homePagePadding, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  ),
                  child: Text(getTranslated('some_items_no_longer_available', context)!,
                    style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error)),
                ),
              ),

            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeSmall),
                itemCount: products.length,
                itemBuilder: (context, index) => _WholesaleReorderItemRow(product: products[index]),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(Dimensions.homePagePadding, 0, Dimensions.homePagePadding,
                  Dimensions.paddingSizeDefault + MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom),
              child: CustomButton(
                buttonText: availableCount > 0
                    ? '${getTranslated('add_to_cart', context)} ($availableCount)'
                    : getTranslated('no_items_available_to_reorder', context),
                onTap: availableCount > 0 ? () => _addAvailableToCart(context) : null,
              ),
            ),
          ]),
        );
      },
    );
  }
}

class _WholesaleReorderItemRow extends StatelessWidget {
  final WholesaleOrderProductItemModel product;
  const _WholesaleReorderItemRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Opacity(
      opacity: product.isAvailable ? 1 : 0.5,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: .125)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              child: CustomImageWidget(image: product.image, width: 50, height: 50, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),

              if (product.variation != null && product.variation!.isNotEmpty) ...[
                const SizedBox(height: Dimensions.marginSizeExtraSmall),
                Text(product.variation!,
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
              ],

              const SizedBox(height: Dimensions.marginSizeExtraSmall),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${getTranslated('qty', context)}: ${product.qty}',
                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleMedium?.color)),
                CustomDirectionalityWidget(
                  child: Text(PriceConverter.convertPrice(context, product.price),
                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyMedium?.color)),
                ),
              ]),

              if (!product.isAvailable) ...[
                const SizedBox(height: Dimensions.marginSizeExtraSmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(getTranslated('unavailable', context)!,
                    style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error)),
                ),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}
