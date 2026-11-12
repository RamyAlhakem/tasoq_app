import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/domain/models/wholesale_coupon_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class WholesaleCouponItemWidget extends StatefulWidget {
  final WholesaleCoupon coupon;
  final bool fromCheckout;
  final Function(String?)? onCopy;
  const WholesaleCouponItemWidget({super.key, required this.coupon, this.fromCheckout = false, this.onCopy});

  @override
  State<WholesaleCouponItemWidget> createState() => _WholesaleCouponItemWidgetState();
}

class _WholesaleCouponItemWidgetState extends State<WholesaleCouponItemWidget> {
  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final DateTime? expiryDate = DateTime.tryParse(widget.coupon.expireDate ?? '');
    final Color highlightColor = isDark ? Theme.of(context).hintColor : Theme.of(context).primaryColor;

    return Padding(padding: widget.fromCheckout? const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeSmall, 0, 0):
      const EdgeInsets.fromLTRB(Dimensions.homePagePadding, Dimensions.paddingSizeSmall, Dimensions.homePagePadding, 0),
      child: Stack(clipBehavior: Clip.none, children: [
          ClipRRect(clipBehavior: Clip.none,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                  boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:.12),
                      spreadRadius: 1, blurRadius: 1, offset: const Offset(1,1))],
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeSmall),
                child: Row(children: [

                    Expanded(flex: 4, child: Padding(padding: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeSmall),
                        child: Column(children: [
                          SizedBox(width: 30, child: Image.asset(
                              color: widget.coupon.discountType == 'percentage'? (isDark ? Colors.white : Theme.of(context).primaryColor) : null,
                              widget.coupon.couponType == 'free_delivery'? Images.freeCoupon :
                              widget.coupon.discountType == 'percentage'? Images.offerIcon : Images.firstOrder)),

                          widget.coupon.couponType == 'free_delivery'?
                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text('${getTranslated('free_delivery', context)}',
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: highlightColor))):

                          widget.coupon.discountType == 'percentage'?
                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text('${widget.coupon.discount} ${'% ${getTranslated('off', context)}'}',
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: highlightColor))):

                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: CustomDirectionalityWidget(
                              child: Text(PriceConverter.convertPrice(context, widget.coupon.discount),
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: highlightColor)))),

                          Text(widget.coupon.seller != null? widget.coupon.seller?.shop?.name ?? '' :
                            widget.coupon.sellerId == 0? '${getTranslated('on_all_shop', context)}' :
                            Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name ?? AppConstants.appName,
                            style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)))]))),

                    Expanded(flex: 6,
                      child: Padding(padding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeSmall),
                        child: Column(children: [
                          DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              color: isDark? Theme.of(context).hintColor.withValues(alpha:.75) : Theme.of(context).primaryColor,
                              radius: const Radius.circular(5),
                            ),
                            child: Container(width: 120,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                decoration: BoxDecoration(color: isDark? Theme.of(context).hintColor.withValues(alpha:.15) :
                                    Theme.of(context).primaryColor.withValues(alpha:.1)),
                                child: Text(widget.coupon.code ?? '',
                                    style: titleRegular.copyWith(color: highlightColor, fontSize: Dimensions.fontSizeDefault)))),

                          if(expiryDate != null)
                            Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: Text('${getTranslated('valid_till', context)}'
                                  ' ${DateConverter.estimatedDateYear(expiryDate)}',
                                style: textRegular.copyWith())),

                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: Text('${getTranslated('available_from', context)} '
                                '${PriceConverter.convertPrice(context, widget.coupon.minPurchase)}',
                                textAlign: TextAlign.center,
                                style: titleRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)))),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),),
          ),

          PositionedDirectional(top: 0, end: 0, child: JustTheTooltip(
            backgroundColor: Colors.black87,
            controller: tooltipController,
            preferredDirection: AxisDirection.down,
            tailLength: 10,
            tailBaseWidth: 20,
            content: Container(width: 90,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Text(getTranslated('copied', context)!,
                    style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault))),
            child: InkWell(
              onTap: () async {
                tooltipController.showTooltip();
                if(widget.onCopy != null) {
                  widget.onCopy!(widget.coupon.code);
                }
                await Clipboard.setData(ClipboardData(text: widget.coupon.code ?? ''));
              },
              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Icon(Icons.copy_rounded,
                      color: isDark? Theme.of(context).hintColor : Theme.of(context).primaryColor.withValues(alpha:.65)))),
          )),

          PositionedDirectional(
            top: 0,
            start: MediaQuery.of(context).size.width / 2.68,
            bottom: 0,
            child: DottedLine(
              direction: Axis.vertical,
              alignment: WrapAlignment.center,
              lineLength: double.infinity,
              lineThickness: 2.0,
              dashLength: 4.0,
              dashColor: Theme.of(context).hintColor,
              dashRadius: 0.0,
              dashGapLength: 6.0,
              dashGapColor: Colors.transparent,
              dashGapRadius: 0.0,
            ),
          ),

          PositionedDirectional(
            top: -20,
            start: MediaQuery.of(context).size.width / 3,
            child: Container(width: 35, height: 35,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          PositionedDirectional(
            bottom: -20,
            start: MediaQuery.of(context).size.width / 3,
            child: Container(width: 35, height: 35,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ]),
    );
  }
}
