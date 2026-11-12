import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleCheckoutOrderNoteWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const WholesaleCheckoutOrderNoteWidget({super.key, required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 3, blurRadius: 3)],
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated('order_note', context) ?? '',
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomTextFieldWidget(
            hintText: getTranslated('enter_note', context),
            inputType: TextInputType.multiline,
            inputAction: TextInputAction.done,
            maxLines: 3,
            focusNode: focusNode,
            controller: controller,
          ),
        ],
      ),
    );
  }
}
