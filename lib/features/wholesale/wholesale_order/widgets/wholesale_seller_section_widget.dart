import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:provider/provider.dart';

class WholesaleSellerSectionWidget extends StatelessWidget {
  final WholesaleOrderDetailsModel orderDetails;
  const WholesaleSellerSectionWidget({super.key, required this.orderDetails, required String sellerName});



  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      decoration: BoxDecoration(
        boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
        color: Theme.of(context).cardColor,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Row(children: [
            CustomAssetImageWidget(Images.vendorIcon, color: isDark ? Colors.white : Theme.of(context).primaryColor, height: 20),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Expanded(
              child: Text(orderDetails.sellerName, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            if (orderDetails.sellerId != null && Provider.of<SplashController>(context, listen: false).isWholesaleEnabled)
              InkWell(
                onTap: () => openWholesaleChat(
                  context,
                  id: orderDetails.sellerId,
                  name: orderDetails.sellerName,
                  image: orderDetails.sellerImage,
                  isShopOnVacation: orderDetails.isShopOnVacation,
                  isShopTemporaryClosed: orderDetails.isShopTemporaryClosed,
                ),
                child: const SizedBox(width: Dimensions.iconSizeDefault, child: CustomAssetImageWidget(Images.storeChatIcon, height: 20, width: 20)),
              ),
          ]),
        ),
        Divider(thickness: .25, color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.3) : Theme.of(context).primaryColor.withValues(alpha: 0.50)),
      ]),
    );
  }
}
