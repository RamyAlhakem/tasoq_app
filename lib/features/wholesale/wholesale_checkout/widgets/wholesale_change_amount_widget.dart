import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/controllers/wholesale_checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleChangeAmountWidget extends StatefulWidget {
  final TextEditingController changeAmountTextController;
  const WholesaleChangeAmountWidget({super.key, required this.changeAmountTextController});

  @override
  State<WholesaleChangeAmountWidget> createState() => _WholesaleChangeAmountWidgetState();
}

class _WholesaleChangeAmountWidgetState extends State<WholesaleChangeAmountWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final SplashController splashController = Provider.of<SplashController>(context, listen: false);

    return Selector<WholesaleCheckoutController, bool>(
      selector: (context, checkoutController) => checkoutController.isCODChecked,
      builder: (context, isCodChecked, _) {
        if (!isCodChecked) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: _isExpanded
                      ? Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha: .05),
                            border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: .125)),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(getTranslated('change_amount', context) ?? '', style: textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                Text(' (${splashController.myCurrency?.symbol ?? ''})', style: titilliumSemiBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                              ]),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Text(getTranslated('insert_amount_if_you_need', context) ?? '',
                                  style: textRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              SizedBox(
                                height: 40,
                                child: Center(
                                  child: TextField(
                                    controller: widget.changeAmountTextController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,' + (splashController.configModel?.decimalPointSettings ?? 0).toString() + r'}$'),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Theme.of(context).highlightColor,
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: .5), width: 1)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: .5), width: 1)),
                                      hintText: getTranslated('amount', context) ?? '',
                                      hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor),
                                      contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isExpanded ? getTranslated('see_less', context) ?? 'See Less' : getTranslated('see_more', context) ?? 'See More',
                      style: textMedium.copyWith(color: isDark ? Colors.white : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
