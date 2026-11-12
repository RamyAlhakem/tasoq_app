import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/enum/wholesale_order_status.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleOrderDetailsAppBarTitle extends StatelessWidget {
  final int orderId;
  final WholesaleOrderStatus status;
  const WholesaleOrderDetailsAppBarTitle({super.key, required this.orderId, required this.status});

  static const double _sideWidth = 2 * (30 + 2 * Dimensions.paddingSizeSmall);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Row(children: [
        SizedBox(
          width: _sideWidth,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: 0),
                child: Icon(CupertinoIcons.back),
              ),
            ),
          ),
        ),

        Expanded(
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${getTranslated('order', context)}# ',
                      style: textRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                      children: [
                        TextSpan(
                          text: orderId.toString(),
                          style: textBold.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  RichText(
                    text: TextSpan(
                      text: getTranslated('your_order_is', context),
                      style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).hintColor,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${getTranslated(status.label, context) ?? status.label}',
                          style: textBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: status.color(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(
          width: _sideWidth,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Consumer<WholesaleOrderController>(
              builder: (context, controller, _) {
                return InkWell(
                  onTap: controller.isInvoiceLoading ? null : () => controller.getOrderInvoice(orderId, context),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: controller.isInvoiceLoading
                        ? const SizedBox(height: 30, width: 30, child: Center(child: CircularProgressIndicator(strokeWidth: 1)))
                        : const CustomAssetImageWidget(Images.downloadInvoice, height: 30, width: 30),
                  ),
                );
              },
            ),

            InkWell(
              onTap: () => RouterHelper.getWholesaleTrackingResultScreenRoute(action: RouteAction.push, orderId: orderId),
              child: const Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomAssetImageWidget(Images.newTrackOrderIcon, height: 30, width: 30),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
