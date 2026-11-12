import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleRestockRequestFooterWidget extends StatelessWidget {
  final bool isLoggedIn;
  final bool isRequested;
  final bool isRequesting;
  final VoidCallback onRequestRestock;
  final VoidCallback onPromptLogin;

  const WholesaleRestockRequestFooterWidget({
    super.key,
    required this.isLoggedIn,
    required this.isRequested,
    required this.isRequesting,
    required this.onRequestRestock,
    required this.onPromptLogin,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    if (!isLoggedIn) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
        child: CustomButton(
          textColor: Colors.white,
          buttonText: getTranslated('request_restock', context),
          onTap: onPromptLogin,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
      child: CustomButton(
        isLoading: isRequesting,
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        textColor: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).primaryColor,
        isBorder: true,
        borderColor: Theme.of(context).primaryColor,
        loadingColor: Theme.of(context).primaryColor,
        radius: Dimensions.radiusDefault,
        buttonText: isRequested ? getTranslated('restock_requested', context) : getTranslated('request_restock', context),
        onTap: isRequested ? null : onRequestRestock,
      ),
    );
  }
}
