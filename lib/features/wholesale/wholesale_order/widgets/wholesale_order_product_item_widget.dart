import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_review_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';

class WholesaleOrderProductItemWidget extends StatelessWidget {
  final int orderId;
  final WholesaleOrderProductItemModel product;
  final bool showDivider;

  final bool isOrderDelivered;
  const WholesaleOrderProductItemWidget({super.key, required this.orderId, required this.product, this.showDivider = true, this.isOrderDelivered = false});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
            onTap: () {
              print(product.image);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: .125)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                child: CustomImageWidget(image: product.image, width: 50, height: 50, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              InkWell(
                onTap: (product.slug?.isNotEmpty ?? false) && Provider.of<SplashController>(context, listen: false).isWholesaleEnabled
                    ? () => RouterHelper.getWholesaleProductDetailsRoute(slug: product.slug ?? '', action: RouteAction.push) : null,
                child: Text(product.name, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: Dimensions.marginSizeExtraSmall),

              if (product.variation != null && product.variation!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Row(children: [
                    Text('${getTranslated('variations', context)}: ',
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    Flexible(child: Text(product.variation!,
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor))),
                  ]),
                ),
              const SizedBox(height: Dimensions.marginSizeExtraSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                CustomDirectionalityWidget(
                  child: Text(PriceConverter.convertPrice(context, product.price),
                    style: titilliumSemiBold.copyWith(color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyMedium?.color, fontSize: Dimensions.fontSizeDefault)),
                ),
                _WholesaleRefundButton(orderId: orderId, product: product),
              ]),
              const SizedBox(height: Dimensions.marginSizeExtraSmall),

              Text('${getTranslated('qty', context)}: ${product.qty}',
                style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color, fontSize: Dimensions.fontSizeSmall)),
            ]),
          ),
        ]),

        const SizedBox(height: Dimensions.paddingSizeSmall),

        if (isOrderDelivered ) ...[
          WholesaleReviewButtonWidget(orderId: orderId, product: product),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ],

        if (showDivider)
          SizedBox(height: 1, child: Divider(thickness: .300, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
      ]),
    );
  }
}

class _WholesaleRefundButton extends StatelessWidget {
  final int orderId;
  final WholesaleOrderProductItemModel product;

  const _WholesaleRefundButton({required this.orderId, required this.product});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Consumer<WholesaleRefundController>(
      builder: (context, refundController, _) {
        final bool hasRefund = product.refundStatusLabel != null;
        final bool isLoadingEligibility = refundController.isEligibilityLoadingFor(product.id);

        if (!hasRefund) {
          if (!product.isRefundable) return const SizedBox();

          return InkWell(
            onTap: isLoadingEligibility
                ? null
                : () {
                    refundController.removeRefundDetails();
                    refundController.getRefundEligibility(product.id).then((value) {
                      if (!context.mounted || value.response?.statusCode != 200) return;

                      final info = refundController.refundInfoModel;
                      if (info == null) return;

                      if (info.alreadyRequested) {
                        RouterHelper.getWholesaleRefundDetailsScreenRoute(action: RouteAction.push, orderId: orderId, orderDetailsId: product.id);
                      } else if (!info.isRefundable) {
                        showCustomSnackBarWidget(
                          info.expired ? 'The refund window for this item has closed' : 'This item is not eligible for a refund',
                          context,
                          snackBarType: SnackBarType.warning,
                        );
                      } else {
                        RouterHelper.getWholesaleRefundRequestScreenRoute(action: RouteAction.push, orderId: orderId, orderDetailsId: product.id);
                      }
                    });
                  },
            child: isLoadingEligibility
                ? SizedBox(height: Dimensions.paddingSizeExtraLarge, width: Dimensions.paddingSizeExtraLarge, child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)))
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeExtraLarge),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                    child: Text(getTranslated('req_refund', context) ?? 'Request Refund', style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: isDark ? Colors.white : Theme.of(context).cardColor)),
                  ),
          );
        }

        return InkWell(
          onTap: () {
            refundController.removeRefundDetails();
            RouterHelper.getWholesaleRefundDetailsScreenRoute(action: RouteAction.push, orderId: orderId, orderDetailsId: product.id);
          },
          child: Container(
            margin: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeSmall),
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),
            child: Text(getTranslated('view_refund', context) ?? 'View Refund', style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: isDark ? Colors.white : Theme.of(context).cardColor)),
          ),
        );
      },
    );
  }
}
