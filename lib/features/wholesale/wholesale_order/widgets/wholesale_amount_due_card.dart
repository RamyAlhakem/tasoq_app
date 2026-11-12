import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';

class WholesaleAmountDueCard extends StatelessWidget {
  final String price;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onTap;
  final bool showButton;
  final bool isLoading;

  const WholesaleAmountDueCard({
    super.key,
    required this.price,
    required this.title,
    required this.description,
    this.buttonText,
    this.onTap,
    this.showButton = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: robotoBold.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomDirectionalityWidget(
              child: Text(price, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(description, textAlign: TextAlign.center, style: titleRegular.copyWith(color: isDark ? Theme.of(context).hintColor : Theme.of(context).textTheme.headlineLarge?.color, fontSize: Dimensions.fontSizeDefault)),

            if (showButton) const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            if (showButton)
              InkWell(
                onTap: isLoading ? null : onTap,
                child: Container(
                  height: Dimensions.paddingSizeButton,
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(buttonText ?? '', style: titilliumBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
