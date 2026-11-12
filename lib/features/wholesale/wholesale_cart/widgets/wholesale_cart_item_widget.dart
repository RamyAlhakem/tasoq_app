import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/helper/wholesale_cart_action_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_cart_checkbox_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_cart_quantity_stepper_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class WholesaleCartItemWidget extends StatelessWidget {
  final WholesaleCartRow row;

  const WholesaleCartItemWidget({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final bool isRemoving = context.select<WholesaleCartController, bool>((controller) => controller.isRemoving(row.id));

    final bool isUpdatingPrice = context.select<WholesaleCartController, bool>((controller) => controller.isUpdatingQuantity(row.id));

    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.homePagePadding, Dimensions.paddingSizeSmall, Dimensions.homePagePadding, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
        ),
        child: Slidable(
          key: ValueKey(row.id),
          enabled: row.id != null && !isRemoving,
          endActionPane: ActionPane(
            extentRatio: .25,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => wholesaleRemoveCartItem(context, cartId: row.id!),
                backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.03),
                foregroundColor: Theme.of(context).colorScheme.error,
                icon: CupertinoIcons.delete_solid,
                label: getTranslated('delete', context),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isRemoving
                    ? const SizedBox(
                        height: 24,
                        width: 30,
                        child: Center(child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))),
                      )
                    : WholesaleCartCheckboxWidget(
                        value: row.isChecked,
                        onChanged: row.id == null ? null : (_) => wholesaleToggleCartSelection(context, cartId: row.id, isChecked: !row.isChecked),
                      ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Expanded(child: _WholesaleCartItemBodyWidget(row: row, isRemoving: isRemoving, isUpdatingPrice: isUpdatingPrice)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WholesaleCartItemBodyWidget extends StatelessWidget {
  final WholesaleCartRow row;
  final bool isRemoving;
  final bool isUpdatingPrice;
  const _WholesaleCartItemBodyWidget({required this.row, required this.isRemoving, required this.isUpdatingPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: row.isAvailable ? 1 : 0.5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WholesaleCartItemThumbnailWidget(thumbnail: row.thumbnailUrl ?? ''),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(child: _WholesaleCartItemInfoWidget(row: row, isUpdatingPrice: isUpdatingPrice)),
            ],
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeSmall),
        _WholesaleCartItemQuantityRowWidget(row: row, isRemoving: isRemoving, isUpdatingPrice: isUpdatingPrice),
      ],
    );
  }
}

class _WholesaleCartItemThumbnailWidget extends StatelessWidget {
  final String thumbnail;
  const _WholesaleCartItemThumbnailWidget({required this.thumbnail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.10), width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        child: CustomImageWidget(image: thumbnail, height: 60, width: 60),
      ),
    );
  }
}

class _WholesaleCartItemInfoWidget extends StatelessWidget {
  final WholesaleCartRow row;
  final bool isUpdatingPrice;
  const _WholesaleCartItemInfoWidget({required this.row, required this.isUpdatingPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          row.name ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium?.color),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        WholesaleCartInfoLine(
          label: getTranslated('unit_price', context) ?? 'Unit Price',
          value: PriceConverter.convertPrice(context, row.unitPrice),
          isPrice: true,
          stale: isUpdatingPrice,
        ),

        for (final WholesaleCartSelectionLabel selection in row.selectionLabels)
          WholesaleCartInfoLine(label: selection.title, value: selection.value),

        if (row.tierLabel != null && row.tierLabel!.isNotEmpty)
          WholesaleCartInfoLine(label: getTranslated('tier_price', context) ?? 'Tier Price', value: row.tierLabel!),

        if (row.hasDiscount)
          WholesaleCartInfoLine(
            label: getTranslated('discount', context) ?? 'Discount',
            value: '-${PriceConverter.convertPrice(context, row.discountPerUnit * row.quantity)}',
            valueColor: Theme.of(context).colorScheme.error,
            isPrice: true,
            stale: isUpdatingPrice,
          ),
      ],
    );
  }
}

class WholesaleCartInfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isPrice;
  final bool stale;

  const WholesaleCartInfoLine({super.key, required this.label, required this.value, this.valueColor, this.isPrice = false, this.stale = false});

  @override
  Widget build(BuildContext context) {
    final Widget line = Text.rich(
      TextSpan(children: [
        TextSpan(text: '$label : ', style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
        TextSpan(
          text: value,
          style: textMedium.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: stale ? Theme.of(context).hintColor : valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: isPrice ? CustomDirectionalityWidget(child: line) : line,
    );
  }
}

class _WholesaleCartItemQuantityRowWidget extends StatelessWidget {
  final WholesaleCartRow row;
  final bool isRemoving;
  final bool isUpdatingPrice;
  const _WholesaleCartItemQuantityRowWidget({required this.row, required this.isRemoving, required this.isUpdatingPrice});

  @override
  Widget build(BuildContext context) {
    final WholesaleCartController cartController = Provider.of<WholesaleCartController>(context, listen: false);
    final int quantity = context.select<WholesaleCartController, int>((controller) => controller.quantityFor(row));
    final String? quantityError = context.select<WholesaleCartController, String?>((controller) => controller.quantityErrorFor(row.id));
    final String? message = quantityError ?? (row.message != null && row.message!.isNotEmpty ? row.message : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WholesaleCartQuantityStepperWidget(
              quantity: quantity,
              minimumOrderQuantity: row.minimumQuantity,
              maximumQuantity: row.maximumQuantity,
              enabled: row.id != null && row.isAvailable && !isRemoving,
              onChanged: (value) => cartController.setItemQuantity(row, value, immediate: true, guestId: wholesaleGuestId(context)),
              onRemove: () => wholesaleRemoveCartItem(context, cartId: row.id!),
            ),
            CustomDirectionalityWidget(
              child: Text(
                PriceConverter.convertPrice(context, row.lineTotal),
                style: titilliumBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: isUpdatingPrice ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),

        if (message != null) ...[
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(message, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error)),
        ],
      ],
    );
  }
}
