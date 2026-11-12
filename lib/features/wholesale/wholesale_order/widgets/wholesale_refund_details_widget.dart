import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/image_diaglog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_refund_change_log_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/enum/wholesale_refund_status.dart';

class WholesaleRefundDetailsWidget extends StatefulWidget {
  final int orderId;
  final int orderDetailsId;

  const WholesaleRefundDetailsWidget({super.key, required this.orderId, required this.orderDetailsId});

  @override
  State<WholesaleRefundDetailsWidget> createState() => _WholesaleRefundDetailsWidgetState();
}

class _WholesaleRefundDetailsWidgetState extends State<WholesaleRefundDetailsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleRefundController>(context, listen: false).getRefundResult(widget.orderDetailsId).then((value) {
        if (value.response?.statusCode != 200 && mounted) {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('refund_request_details', context),
        showActionButton: true,
        showResetIcon: true,
        reset: Consumer<WholesaleRefundController>(
          builder: (context, refundController, _) {
            final refund = refundController.refundResultModel;
            if (refund == null) return const SizedBox();

            final Color color = WholesaleRefundStatus.fromString(refund.statusTone ?? refund.status).color(context);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeEight), border: Border.all(color: color, width: 1)),
                child: Text(refund.statusLabel ?? refund.status, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: color)),
              ),
            );
          },
        ),
      ),
      body: Consumer<WholesaleRefundController>(
        builder: (context, refundController, _) {
          final refund = refundController.refundResultModel;
          if (refund == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.2))),
                  child: Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusSmall), topLeft: Radius.circular(Dimensions.radiusSmall)),
                        color: Theme.of(context).hintColor.withValues(alpha: .1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          RichText(text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: [
                            TextSpan(text: '${getTranslated('order_id_refund_details', context)}', style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                            TextSpan(text: '#${refund.orderId ?? widget.orderId}', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          ])),
                          if (refund.createdAt != null)
                            Text(DateConverter.refundDateTime(refund.createdAt!), textDirection: TextDirection.ltr, style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color), overflow: TextOverflow.ellipsis),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('${getTranslated('refundable_amount', context)}', style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                            CustomDirectionalityWidget(
                              child: Text(PriceConverter.convertPrice(context, refund.amount), style: textMedium.copyWith(color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraLarge)),
                            ),
                          ]),
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.start, children: [
                          Text('${getTranslated('request_date', context)}', style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                          if (refund.createdAt != null)
                            Text(DateConverter.refundDateTime(refund.createdAt!), textDirection: TextDirection.ltr, style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color), overflow: TextOverflow.ellipsis),
                        ]),
                      ]),
                    ),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeEight),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.2))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall),
                        child: Row(children: [
                          SizedBox(width: 20, child: Image.asset(Images.refundReason)),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeSmall),
                            child: Text('${getTranslated('request_reason_refund_details', context)}', style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null), overflow: TextOverflow.ellipsis),
                          ),
                        ]),
                      ),
                      Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.125)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                        child: Text('${refund.refundReason ?? ''}', style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                      ),
                      if (refund.imagesFullUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                          child: SizedBox(
                            height: 90,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              padding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeDefault),
                              itemCount: refund.imagesFullUrl.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeDefault),
                                  child: InkWell(
                                    onTap: () => showDialog(context: context, builder: (_) => ImageDialog(imageUrl: refund.imagesFullUrl[index].path ?? '')),
                                    child: Container(
                                      width: 85,
                                      height: 85,
                                      decoration: BoxDecoration(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.1) : Colors.white, borderRadius: const BorderRadius.all(Radius.circular(20))),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                                        child: CustomImageWidget(placeholder: Images.placeholder, image: refund.imagesFullUrl[index].path ?? '', width: 85, height: 85, fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ]),
                  ),
                ),

                if (refund.statusHistory.isNotEmpty) ...[
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  const WholesaleRefundChangeLogWidget(),
                ],
              ]),
            ),
          );
        },
      ),
    );
  }
}
