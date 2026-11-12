import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_status_badge.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';

class WholesaleOrderListItemCard extends StatelessWidget {
  final WholesaleOrderModel orderModel;
  const WholesaleOrderListItemCard({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return InkWell(
      onTap: () => RouterHelper.getWholesaleOrderDetailsScreenRoute(action: RouteAction.push, orderId: orderModel.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: isDark ? null : [
            BoxShadow(color: Colors.grey.withValues(alpha: .12), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _WholesaleOrderShopLogo(image: orderModel.shopLogo.trim() == '' ? null : orderModel.shopLogo),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Row(children: [
                    Flexible(
                      child: Text(
                        '${getTranslated('order', context)} #${orderModel.id}',
                        style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),

                    if (orderModel.editedStatus == 1) ...[
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text('(${getTranslated('edited', context)})',
                        style: textMedium.copyWith(color: isDark ? Theme.of(context).hintColor : Theme.of(context).textTheme.headlineMedium?.color, fontSize: Dimensions.fontSizeSmall)),
                    ],

                    if (orderModel.editedStatus == 1 && ((orderModel.editDueAmount ?? 0) > 0 || (orderModel.editReturnAmount ?? 0) > 0)) ...[
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      InkWell(
                        onTap: () => showCustomSnackBarWidget(
                          (orderModel.editDueAmount ?? 0) > 0
                            ? getTranslated('you_will_pay_due_the_amount', context) ?? ''
                            : getTranslated('admin_return_the_excess_amount_to_you', context) ?? '',
                          context,
                          snackBarType: SnackBarType.warning,
                        ),
                        child: CustomAssetImageWidget(
                          (orderModel.editDueAmount ?? 0) > 0 ? Images.orderDueAmountIcon : Images.orderReturnAmountIcon,
                          height: 16,
                          width: 16,
                        ),
                      ),
                    ],
                  ]),
                ),
                WholesaleOrderStatusBadge(status: orderModel.status),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                DateConverter.localDateToIsoStringAMPMOrder(orderModel.orderDate),
                textDirection: TextDirection.ltr,
                style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleMedium?.color),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                CustomDirectionalityWidget(
                  child: Text(
                    PriceConverter.convertPrice(context, orderModel.amount),
                    style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).primaryColor),
                  ),
                ),
                Row(children: [
                  Text('${orderModel.productCount} ', style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                  Text(getTranslated('products', context) ?? '', style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text('${orderModel.unitCount} ', style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                  Text(getTranslated('units', context) ?? '', style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                ]),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _WholesaleOrderShopLogo extends StatelessWidget {
  final String? image;
  const _WholesaleOrderShopLogo({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: CustomImageWidget(image: image ?? '', fit: BoxFit.contain),
      ),
    );
  }
}
