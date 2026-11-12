import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/domain/models/wholesale_coupon_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class WholesaleShopCouponItemWidget extends StatefulWidget {
  final WholesaleCoupon coupon;

  const WholesaleShopCouponItemWidget({super.key, required this.coupon});

  @override
  State<WholesaleShopCouponItemWidget> createState() => _WholesaleShopCouponItemWidgetState();
}

class _WholesaleShopCouponItemWidgetState extends State<WholesaleShopCouponItemWidget> {
  final JustTheController _tooltipController = JustTheController();

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color? textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeEight),
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            border: Border.all(color: primaryColor.withValues(alpha: .125)),
            boxShadow: isDark ? null : [
              BoxShadow(color: primaryColor.withValues(alpha: .12), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 1)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Padding(
                padding: EdgeInsets.only(right: isLtr ? Dimensions.paddingSizeSmall : 0, left: isLtr ? 0 : Dimensions.paddingSizeSmall),
                child: _buildDiscountInfo(context, textColor),
              )),
              Expanded(child: Padding(
                padding: EdgeInsets.only(left: isLtr ? Dimensions.paddingSizeSmall : 0, right: isLtr ? 0 : Dimensions.paddingSizeSmall),
                child: _buildCodeInfo(context, textColor),
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),
            ]),
          ),
        ),

        Positioned.fill(child: Align(
          alignment: isLtr ? Alignment.topRight : Alignment.topLeft,
          child: JustTheTooltip(
            backgroundColor: Colors.black87.withValues(alpha: .75),
            controller: _tooltipController,
            preferredDirection: AxisDirection.up,
            tailLength: 10,
            tailBaseWidth: 20,
            borderRadius: BorderRadius.circular(10),
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
              child: Text(getTranslated('copied', context) ?? 'Copied',
                style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault)),
            ),
            child: InkWell(
              onTap: () async {
                _tooltipController.showTooltip();
                await Clipboard.setData(ClipboardData(text: widget.coupon.code ?? ''));
              },
              child: Padding(
                padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault, right: isLtr ? Dimensions.paddingSizeEight : 0, left: isLtr ? 0 : Dimensions.paddingSizeEight),
                child: Icon(Icons.copy_rounded, color: isDark ? Colors.white : primaryColor, size: 20),
              ),
            ),
          ),
        )),
      ]),
    );
  }

  Widget _buildDiscountInfo(BuildContext context, Color? textColor) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final WholesaleCoupon coupon = widget.coupon;
    final bool isFreeDelivery = coupon.couponType == 'free_delivery';
    final bool isPercentage = coupon.discountType == 'percentage';

    final String discountText = isFreeDelivery ? getTranslated('free_delivery', context) ?? 'Free Delivery'
        : isPercentage
            ? '${_formatNumber(coupon.discount)} % ${getTranslated('off', context) ?? 'off'}'
            : '${PriceConverter.convertPrice(context, coupon.discount)} ${getTranslated('OFF', context) ?? 'OFF'}';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 20, child: Image.asset(
        isFreeDelivery ? Images.freeCoupon : isPercentage ? Images.offerIcon : Images.firstOrder,
        color: isPercentage ? (isDark ? Colors.white : Theme.of(context).primaryColor) : null,
      )),

      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
        child: Text(discountText, style: textBold.copyWith(
          fontSize: isFreeDelivery ? Dimensions.fontSizeLarge : Dimensions.fontSizeExtraLarge,
          color: textColor,
        )),
      ),

      Text('${getTranslated('on', context) ?? 'On'} ${getTranslated(coupon.couponType, context) ?? ''}',
        style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),

      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
        child: CustomDirectionalityWidget(
          child: Text(
            '${getTranslated('minimum_purchase_amount', context) ?? 'Minimum purchase amount'} ${PriceConverter.convertPrice(context, coupon.minPurchase)}',
            textAlign: TextAlign.left,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: textColor),
          ),
        ),
      ),
    ]);
  }

  Widget _buildCodeInfo(BuildContext context, Color? textColor) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final Color primaryColor = Theme.of(context).primaryColor;
    final DateTime? expiryDate = DateTime.tryParse(widget.coupon.expireDate ?? '');

    return Column(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(height: Dimensions.paddingSizeButton),

      Center(child: Stack(children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeEight, horizontal: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeEight),
            border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .75) : primaryColor),
          ),
          child: Text(widget.coupon.code ?? '',
            overflow: TextOverflow.ellipsis,
            style: titilliumSemiBold.copyWith(color: isDark ? Theme.of(context).hintColor : primaryColor, fontSize: Dimensions.fontSizeLarge)),
        ),

        Positioned.fill(child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            transform: Matrix4.translationValues(0, -15, 0),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              color: primaryColor,
            ),
            child: Text(getTranslated('coupon_code', context) ?? 'Coupon Code',
              style: titilliumSemiBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall)),
          ),
        )),
      ])),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      if (expiryDate != null) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
          child: Text(
            '${getTranslated('available_till', context) ?? 'Available till'} ${DateConverter.estimatedDate(expiryDate)}',
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: textColor),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      ],
    ]);
  }

  String _formatNumber(double? value) {
    if (value == null) return '0';
    return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
  }
}
