import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleOrderNoteWidget extends StatelessWidget {
  final String note;
  const WholesaleOrderNoteWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      color: Theme.of(context).cardColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Text(getTranslated('order_note', context) ?? '',
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).shadowColor)),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Divider(thickness: .25, color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.3) : Theme.of(context).primaryColor.withValues(alpha: 0.50)),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Text(note,
            style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
            textAlign: TextAlign.justify),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ]),
    );
  }
}
