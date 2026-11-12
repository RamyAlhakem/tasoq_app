import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_checkout/controllers/wholesale_checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

class WholesaleCustomCheckBoxWidget extends StatelessWidget {
  final int index;
  final String? icon;
  final String name;
  final String title;
  final double? padding;
  const WholesaleCustomCheckBoxWidget({super.key, required this.index, this.icon, required this.name, required this.title, this.padding});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Consumer<WholesaleCheckoutController>(
      builder: (context, checkoutController, _) {
        return InkWell(
          onTap: () => checkoutController.setDigitalPaymentMethodName(index, name),
          child: Padding(
            padding: EdgeInsets.all(padding ?? Dimensions.paddingSizeDefault),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: 40,
                  child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall), child: CustomImageWidget(image: icon!)),
                ),
                Expanded(child: Text(title, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color))),
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: isDark
                        ? Theme.of(context).hintColor.withValues(alpha: .5)
                        : Theme.of(context).primaryColor.withValues(alpha: .25),
                  ),
                  child: Checkbox(
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge)),
                    value: checkoutController.paymentMethodIndex == index,
                    activeColor: Colors.green,
                    checkColor: isDark ? Colors.white : Theme.of(context).cardColor,
                    onChanged: (bool? isChecked) => checkoutController.setDigitalPaymentMethodName(index, name),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
