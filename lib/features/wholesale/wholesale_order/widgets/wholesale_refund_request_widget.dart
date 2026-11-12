import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_refund_image_selection_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';

class WholesaleRefundRequestWidget extends StatefulWidget {
  final int orderDetailsId;
  final int orderId;

  const WholesaleRefundRequestWidget({super.key, required this.orderDetailsId, required this.orderId});

  @override
  State<WholesaleRefundRequestWidget> createState() => _WholesaleRefundRequestWidgetState();
}

class _WholesaleRefundRequestWidgetState extends State<WholesaleRefundRequestWidget> {
  final TextEditingController _refundReasonController = TextEditingController();

  @override
  void dispose() {
    _refundReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('refund_request', context)),
      body: SingleChildScrollView(
        child: Consumer<WholesaleRefundController>(
          builder: (context, refundController, _) {
            final breakdown = refundController.refundInfoModel?.refund;

            return Column(children: [
              breakdown != null
                  ? Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: isDark
                                ? null
                                : [BoxShadow(color: Colors.grey.withValues(alpha: .2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                          child: Column(children: [
                            _TitleWithAmountRow(
                              title: getTranslated('total_price', context)!,
                              amount: PriceConverter.convertPrice(context, breakdown.productPrice * breakdown.quantity),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: _TitleWithAmountRow(
                                title: getTranslated('product_discount', context)!,
                                amount: '-${PriceConverter.convertPrice(context, breakdown.productDiscount)}',
                              ),
                            ),
                            _TitleWithAmountRow(title: getTranslated('tax', context)!, amount: PriceConverter.convertPrice(context, breakdown.tax)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: _TitleWithAmountRow(title: getTranslated('sub_total', context)!, amount: PriceConverter.convertPrice(context, breakdown.subtotal)),
                            ),
                            _TitleWithAmountRow(title: getTranslated('coupon_discount', context)!, amount: PriceConverter.convertPrice(context, breakdown.couponDiscount)),
                            if (breakdown.referralDiscount > 0) ...[
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              _TitleWithAmountRow(
                                title: getTranslated('referral_discount', context)!,
                                amount: '-${PriceConverter.convertPrice(context, breakdown.referralDiscount)}',
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: Divider(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.15) : Theme.of(context).primaryColor.withValues(alpha: 0.125), height: 2),
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(getTranslated('total_refund_amount', context)!, style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                              CustomDirectionalityWidget(
                child: Text(PriceConverter.convertPrice(context, breakdown.refundAmount), style: robotoBold.copyWith(color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null)),
              ),
                            ]),
                          ]),
                        ),
                      ]),
                    )
                  : const SizedBox(),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Text(getTranslated('refund_reason', context)!, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                  Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor, size: 30),
                ]),
              ),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomTextFieldWidget(maxLines: 4, controller: _refundReasonController, inputAction: TextInputAction.done),
              ),

              const WholesaleRefundImageSelectionWidget(),

              refundController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: CustomButton(
                        buttonText: getTranslated('send_request', context),
                        onTap: () {
                          final String reason = _refundReasonController.text.trim();
                          if (reason.isEmpty) {
                            showCustomSnackBarWidget(getTranslated('reason_required', context) ?? '', context, snackBarType: SnackBarType.warning);
                          } else {
                            refundController.submitRefundRequest(orderId: widget.orderId, orderDetailsId: widget.orderDetailsId, refundReason: reason);
                          }
                        },
                      ),
                    ),
            ]);
          },
        ),
      ),
    );
  }
}

class _TitleWithAmountRow extends StatelessWidget {
  final String title;
  final String amount;
  const _TitleWithAmountRow({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: textRegular.copyWith(color: Theme.of(context).hintColor)),
      CustomDirectionalityWidget(child: Text(amount, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color))),
    ]);
  }
}
