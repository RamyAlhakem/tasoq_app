import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleOrderPlaceBottomSheetWidget extends StatelessWidget {
  final String? orderID;
  final String title;
  final String description;

  const WholesaleOrderPlaceBottomSheetWidget({super.key, this.orderID, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = Provider.of<AuthController>(context, listen: false).isLoggedIn();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.homePagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
                child: Icon(Icons.close, size: 20, color: Theme.of(context).textTheme.titleMedium!.color),
              ),
            ),
          ),
          CustomAssetImageWidget(Images.orderSuccessIcon, height: 60, width: 60),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Text(title, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color), maxLines: 2, textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text(description, textAlign: TextAlign.center, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium?.color)),
          if (orderID != null) ...[
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text('${getTranslated('order_id', context)}#$orderID', style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
          ],
          if (isLoggedIn) ...[
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            SizedBox(
              height: 45,
              width: 200,
              child: CustomButton(
                radius: 5,
                buttonText: getTranslated('explore_more_items', context),
                onTap: () => RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page: 'home'),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ],
        ],
      ),
    );
  }
}
