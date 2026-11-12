import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleHomeSearchBarWidget extends StatelessWidget {
  final String? hintText;

  const WholesaleHomeSearchBarWidget({super.key, this.hintText});

  static const double fieldHeight = 50;
  static const double verticalPadding = Dimensions.homePagePadding;
  static const double height = fieldHeight + (verticalPadding * 2);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: verticalPadding),
      child: IgnorePointer(
        child: SizedBox(
          height: fieldHeight,
          child: TextFormField(
            style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeLarge),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall), borderSide: BorderSide(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .3) : Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall), borderSide: BorderSide(color: isDark ? Theme.of(context).primaryColor : Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall), borderSide: BorderSide(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .3) : Colors.grey[300]!)),
              hintText: hintText ?? getTranslated('search_hint', context),
              hintStyle: textRegular.copyWith(color: isDark ? Theme.of(context).hintColor : Theme.of(context).colorScheme.shadow.withValues(alpha: 0.9)),
              suffixIcon: SizedBox(
                width: 50,
                child: Row(children: [
                  Container(
                    margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                    child: Image.asset(Images.search, color: Colors.white, height: Dimensions.iconSizeSmall, width: Dimensions.iconSizeSmall, fit: BoxFit.contain),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
