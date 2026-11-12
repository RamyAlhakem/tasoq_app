import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/offline_payment/domain/models/offline_payment_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/controllers/wholesale_checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleOfflineCardWidget extends StatelessWidget {
  final int index;
  final OfflineMethods offlinePaymentModel;
  final int? selectedIndex;
  const WholesaleOfflineCardWidget({super.key, required this.offlinePaymentModel, required this.index, this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Consumer<WholesaleCheckoutController>(
      builder: (context, orderProvider, _) {
        return Stack(children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
            child: Container(
              width: MediaQuery.of(context).size.width * .75,
              height: 180,
              decoration: BoxDecoration(
                color: index == (selectedIndex ?? orderProvider.offlineMethodSelectedIndex) ? Theme.of(context).cardColor : (isDark ? Theme.of(context).hintColor.withValues(alpha: .125) : Theme.of(context).primaryColor.withValues(alpha: .125)),
                border: index == (selectedIndex ?? orderProvider.offlineMethodSelectedIndex) ? Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .5) : Theme.of(context).primaryColor.withValues(alpha: .5), width: .5) : null,
                borderRadius: BorderRadius.circular((Dimensions.paddingSizeExtraSmall)),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeExtraSmall),
                    child: Text(offlinePaymentModel.methodName ?? '', style: textBold.copyWith(color: isDark ? Theme.of(context).hintColor : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: offlinePaymentModel.methodFields?.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
                          child: Column(children: [
                            Text('${offlinePaymentModel.methodFields?[index].inputName ?? ''} : '.replaceAll("_", " ").wholesaleCapitalize(), style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null)),
                            Text((offlinePaymentModel.methodFields?[index].inputData ?? '').replaceAll('_', " ").wholesaleCapitalize(), style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null)),
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (index == (selectedIndex ?? orderProvider.offlineMethodSelectedIndex))
            PositionedDirectional(
              top: 30,
              end: 20,
              child: Row(children: [
                Text('${getTranslated('pay_on_this_account', context)}', style: textRegular.copyWith(color: isDark ? Theme.of(context).hintColor : Theme.of(context).primaryColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: isDark ? Theme.of(context).colorScheme.onTertiaryContainer : Colors.green, size: 18),
                ),
              ]),
            ),
        ]);
      },
    );
  }
}

extension WholesaleOfflineCardStringExtension on String {
  String wholesaleCapitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}
