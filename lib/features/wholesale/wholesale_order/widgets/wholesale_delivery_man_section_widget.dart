import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleDeliveryManSectionWidget extends StatelessWidget {
  final WholesaleDeliveryManModel deliveryMan;
  const WholesaleDeliveryManSectionWidget({super.key, required this.deliveryMan});



  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 2, blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('shipping_info', context) ?? '', style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
          if (deliveryMan.id != null)
            InkWell(
              onTap: () => openWholesaleChat(
                context,
                id: deliveryMan.id,
                name: deliveryMan.name,
                image: deliveryMan.image,
                isDelivery: true,
              ),
              child: const SizedBox(width: Dimensions.iconSizeDefault, child: CustomAssetImageWidget(Images.storeChatIcon, height: 20, width: 20)),
            ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeLarge),
            child: CustomImageWidget(image: deliveryMan.image, fit: BoxFit.cover, width: Dimensions.paddingSizeButton, height: Dimensions.paddingSizeButton),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(deliveryMan.name, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),

            if (deliveryMan.assignedAt != null)
              Text.rich(TextSpan(children: [
                TextSpan(text: '${getTranslated('assign', context)!} : ', style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                TextSpan(text: DateConverter.localDateToIsoStringAMPMOrder(deliveryMan.assignedAt!),
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
              ])),
          ]),
        ]),
      ]),
    );
  }
}
