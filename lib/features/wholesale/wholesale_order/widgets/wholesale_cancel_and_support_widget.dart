import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/enum/wholesale_order_status.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_cancel_order_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleSupportContactWidget extends StatelessWidget {
  const WholesaleSupportContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return InkWell(
      onTap: () => RouterHelper.getSupportTicketRoute(action: RouteAction.push),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
        ),
        child: Row(children: [
          const CustomAssetImageWidget(Images.supportIcon, width: 35, height: 35),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: RichText(
              textAlign: TextAlign.start,
              maxLines: 2,
              text: TextSpan(children: [
                TextSpan(text: getTranslated('having_trouble_or_can', context),
                  style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color, fontSize: Dimensions.fontSizeDefault)),
                TextSpan(text: getTranslated('contact_support', context),
                  style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault)),
              ]),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),
          const CustomAssetImageWidget(Images.supportMessageIcon, width: 35, height: 35),
        ]),
      ),
    );
  }
}

class WholesaleOrderActionButtonWidget extends StatelessWidget {
  final int orderId;
  final WholesaleOrderStatus status;
  const WholesaleOrderActionButtonWidget({super.key, required this.orderId, required this.status});

  @override
  Widget build(BuildContext context) {
    final String? label = switch (status) {
      WholesaleOrderStatus.pending => getTranslated('cancel_order', context),
      WholesaleOrderStatus.delivered || WholesaleOrderStatus.canceled || WholesaleOrderStatus.returned => null,
      _ => getTranslated('TRACK_ORDER', context),
    };

    if (label == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
      child: CustomButton(
        buttonText: label,
        textColor: status == WholesaleOrderStatus.pending ? Theme.of(context).colorScheme.error : null,
        backgroundColor: status == WholesaleOrderStatus.pending ? Theme.of(context).colorScheme.error.withValues(alpha: 0.15) : null,
        onTap: switch (status) {
          WholesaleOrderStatus.pending => () => _showCancelDialog(context),
          _ => () => RouterHelper.getWholesaleTrackingResultScreenRoute(action: RouteAction.push, orderId: orderId),
        },
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: WholesaleCancelOrderDialogWidget(orderId: orderId),
      ),
    );
  }

}
