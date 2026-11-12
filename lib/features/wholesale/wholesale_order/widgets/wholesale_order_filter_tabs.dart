import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';

class WholesaleOrderFilterTabs extends StatelessWidget {
  const WholesaleOrderFilterTabs({super.key});

  static const List<String> _labelKeys = ['running', 'delivered', 'cancel'];

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleOrderController>(
      builder: (context, orderController, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
          child: Row(children: List.generate(_labelKeys.length, (index) {
            return Padding(
              padding: EdgeInsetsDirectional.only(end: index != _labelKeys.length - 1 ? Dimensions.paddingSizeSmall : 0),
              child: _WholesaleOrderFilterTabButton(
                label: getTranslated(_labelKeys[index], context) ?? '',
                isSelected: orderController.tabIndex == index,
                onTap: () => orderController.setTabIndex(index),
              ),
            );
          })),
        );
      },
    );
  }
}

class _WholesaleOrderFilterTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _WholesaleOrderFilterTabButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(label, style: titleRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: isSelected ? (isDark ? Colors.white : Theme.of(context).cardColor) : Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        )),
      ),
    );
  }
}
