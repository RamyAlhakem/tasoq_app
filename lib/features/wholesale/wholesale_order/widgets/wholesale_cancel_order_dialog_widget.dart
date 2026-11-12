import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleCancelOrderDialogWidget extends StatelessWidget {
  final int orderId;
  const WholesaleCancelOrderDialogWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Align(alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor.withValues(alpha: 0.5)),
              padding: const EdgeInsets.all(3),
              child: const Icon(Icons.clear),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall), color: Theme.of(context).cardColor),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(Dimensions.homePagePadding),
          child: Column(children: [
            Image.asset(Images.cancelOrder, height: 60),
            const SizedBox(height: Dimensions.homePagePadding),

            Text(getTranslated('are_you_sure_you_want_to_cancel_your_order', context)!,
              textAlign: TextAlign.center,
              style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
            const SizedBox(height: Dimensions.homePagePadding),
            const SizedBox(height: Dimensions.homePagePadding),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(child: CustomButton(
                textColor: Theme.of(context).textTheme.bodyLarge?.color,
                backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.50),
                buttonText: getTranslated('NO', context)!,
                onTap: () {
                  if (Provider.of<WholesaleOrderController>(context, listen: false).isCancelling) return;
                  Navigator.pop(context);
                },
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(child: Consumer<WholesaleOrderController>(
                builder: (context, orderController, _) {
                  return CustomButton(
                    buttonText: getTranslated('YES', context)!,
                    isLoading: orderController.isCancelling,
                    onTap: () {
                      if (orderController.isCancelling) return;
                      orderController.cancelOrder(orderId).then((value) {
                        if (!context.mounted) return;
                        if (value.response?.statusCode == 200) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showCustomSnackBarWidget(getTranslated('order_cancelled_successfully', context)!, context, snackBarType: SnackBarType.success);
                        }
                      });
                    },
                  );
                },
              )),
            ]),
          ]),
        ),
      ]),
    );
  }
}
