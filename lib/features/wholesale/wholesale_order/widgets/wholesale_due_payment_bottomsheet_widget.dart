import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleDuePaymentBottomSheetWidget extends StatefulWidget {
  final int orderId;
  const WholesaleDuePaymentBottomSheetWidget({super.key, required this.orderId});

  @override
  State<WholesaleDuePaymentBottomSheetWidget> createState() => _WholesaleDuePaymentBottomSheetWidgetState();
}

class _WholesaleDuePaymentBottomSheetWidgetState extends State<WholesaleDuePaymentBottomSheetWidget> {
  String _selectedMethod = 'cash_on_delivery';

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleOrderController>(
      builder: (context, controller, _) {
        final bool isLoading = controller.dueSettlementOrderId == widget.orderId;

        return Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 35,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault), color: Theme.of(context).hintColor.withValues(alpha: .5)),
                ),
              ),

              Text(getTranslated('choose_payment_method', context) ?? '', style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              _WholesalePaymentMethodTile(
                icon: Images.cod,
                title: getTranslated('cash_on_delivery', context) ?? '',
                isSelected: _selectedMethod == 'cash_on_delivery',
                onTap: () => setState(() => _selectedMethod = 'cash_on_delivery'),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              _WholesalePaymentMethodTile(
                icon: Images.payWallet,
                title: getTranslated('pay_via_wallet', context) ?? '',
                isSelected: _selectedMethod == 'wallet',
                onTap: () => setState(() => _selectedMethod = 'wallet'),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              CustomButton(
                isLoading: isLoading,
                buttonText: getTranslated('proceed_text', context) ?? '',
                onTap: () async {
                  await controller.settleEditOrderDueAmount(orderId: widget.orderId, paymentMethod: _selectedMethod);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    showCustomSnackBarWidget(getTranslated('due_amount_paid_successfully', context) ?? '', context, snackBarType: SnackBarType.success);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WholesalePaymentMethodTile extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const _WholesalePaymentMethodTile({required this.icon, required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: .1) : Theme.of(context).cardColor,
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: .125)),
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
        child: Row(children: [
          Image.asset(icon, height: 24, width: 24),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(child: Text(title, style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color))),
          RadioGroup<bool>(
            groupValue: isSelected ? true : null,
            onChanged: (_) => onTap(),
            child: Radio<bool>(value: true, activeColor: Theme.of(context).primaryColor),
          ),
        ]),
      ),
    );
  }
}
