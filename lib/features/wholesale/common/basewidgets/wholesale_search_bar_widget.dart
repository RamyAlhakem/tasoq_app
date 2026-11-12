import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onClearPressed;
  final VoidCallback? onChanged;

  const WholesaleSearchBarWidget({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.onSubmitted,
    this.onSearchPressed,
    this.onClearPressed,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      onChanged: (value) => onChanged?.call(),
      onFieldSubmitted: onSubmitted,
      style: textMedium.copyWith(
        fontSize: Dimensions.fontSizeLarge,
        color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeLarge),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall), borderSide: BorderSide(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .3) : Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall), borderSide: BorderSide(color: isDark ? Theme.of(context).primaryColor : Colors.grey[300]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall), borderSide: BorderSide(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .3) : Colors.grey[300]!)),
        hintText: hintText ?? getTranslated('search_products', context),
        hintStyle: textRegular.copyWith(color: isDark ? Theme.of(context).hintColor : Theme.of(context).colorScheme.shadow.withValues(alpha: 0.9)),
        suffixIcon: SizedBox(
          width: controller.text.isNotEmpty ? 70 : 50,
          child: Row(children: [
            if (controller.text.isNotEmpty)
              InkWell(onTap: onClearPressed, child: const Icon(Icons.clear, size: 20)),
            InkWell(
              onTap: onSearchPressed,
              child: Container(
                margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                child: Image.asset(Images.search, color: Colors.white, height: Dimensions.iconSizeSmall, width: Dimensions.iconSizeSmall, fit: BoxFit.contain),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
