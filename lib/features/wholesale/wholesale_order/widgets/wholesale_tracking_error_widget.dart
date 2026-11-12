import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleTrackingErrorWidget extends StatelessWidget {
  final int orderId;
  final String? phoneNumber;
  const WholesaleTrackingErrorWidget({super.key, required this.orderId, this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            getTranslated('no_order_found', context) ?? '',
            style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          CustomButton(
            buttonText: getTranslated('track_order', context),
            onTap: () => Provider.of<WholesaleOrderController>(context, listen: false)
                .loadTrackingHistory(orderId, reload: true, phoneNumber: phoneNumber),
          ),
        ]),
      ),
    );
  }
}
