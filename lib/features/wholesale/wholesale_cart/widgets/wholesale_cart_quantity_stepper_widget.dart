import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class WholesaleCartQuantityStepperWidget extends StatelessWidget {
  final int quantity;
  final int minimumOrderQuantity;

  final int? maximumQuantity;

  final bool enabled;
  final ValueChanged<int> onChanged;
  final VoidCallback onRemove;

  const WholesaleCartQuantityStepperWidget({
    super.key,
    required this.quantity,
    required this.minimumOrderQuantity,
    this.maximumQuantity,
    this.enabled = true,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bool atMinimum = quantity <= minimumOrderQuantity;
    final bool atMaximum = maximumQuantity != null && quantity >= maximumQuantity!;

    return Row(mainAxisSize: MainAxisSize.min, children: [
      _WholesaleCartStepperButton(
        enabled: enabled,
        onTap: atMinimum ? onRemove : () => onChanged(quantity - 1),
        child: atMinimum
            ? CustomAssetImageWidget(Images.cartDeleteIcon, height: 18, width: 18)
            : Icon(CupertinoIcons.minus, color: Theme.of(context).primaryColor, size: 17),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: Text(quantity.toString(), style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
      ),

      _WholesaleCartStepperButton(
        enabled: enabled,
        onTap: atMaximum
            ? () => showCustomSnackBarWidget(getTranslated('out_of_stock', context), context, snackBarType: SnackBarType.warning)
            : () => onChanged(quantity + 1),
        child: Icon(CupertinoIcons.add, color: atMaximum ? Theme.of(context).disabledColor : Theme.of(context).primaryColor, size: 17),
      ),
    ]);
  }
}

class _WholesaleCartStepperButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;
  final Widget child;

  const _WholesaleCartStepperButton({required this.enabled, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall), child: child),
    );
  }
}
