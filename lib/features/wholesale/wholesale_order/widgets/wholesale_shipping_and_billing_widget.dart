import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/icon_with_text_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleShippingAndBillingWidget extends StatelessWidget {
  final WholesaleOrderDetailsModel orderDetails;
  const WholesaleShippingAndBillingWidget({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return _WholesaleCollapsibleAddressSection(
      addressContent: Container(
        color: Theme.of(context).cardColor,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(getTranslated('shipping_address', context)!,
            style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(height: Dimensions.marginSizeSmall),
          _WholesaleAddressDetails(address: orderDetails.shippingAddress),

          Divider(thickness: .25, color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.45) : Theme.of(context).primaryColor.withValues(alpha: 0.50)),

          Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(getTranslated('billing_address', context)!,
                style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
              const SizedBox(height: Dimensions.marginSizeSmall),

              if (orderDetails.billingSameAsShipping)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text(getTranslated('same_as_shipping_address', context)!,
                      style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                  ]),
                )
              else
                _WholesaleAddressDetails(address: orderDetails.billingAddress),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _WholesaleAddressDetails extends StatelessWidget {
  final WholesaleOrderAddressModel address;
  const _WholesaleAddressDetails({required this.address});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: IconWithTextRowWidget(isBold: true, icon: Icons.person, text: address.contactPersonName)),
        Expanded(child: IconWithTextRowWidget(icon: Icons.call, text: '\u200E${address.phone}')),
      ]),
      const SizedBox(height: Dimensions.marginSizeSmall),

      Row(children: [
        Expanded(child: IconWithTextRowWidget(imageIcon: Images.homeIconAddress, text: address.addressType, icon: null)),
        Expanded(child: IconWithTextRowWidget(imageIcon: Images.countryIconAddress, text: address.country, icon: null)),
      ]),
      const SizedBox(height: Dimensions.marginSizeSmall),

      Row(children: [
        Expanded(child: IconWithTextRowWidget(imageIcon: Images.cityIconAddress, icon: Icons.location_city, text: address.city)),
        Expanded(child: IconWithTextRowWidget(imageIcon: Images.zipIconAddress, icon: Icons.location_city, text: address.zip)),
      ]),
      const SizedBox(height: Dimensions.marginSizeSmall),

      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.location_on,
          color: isDark ? Colors.white : Theme.of(context).hintColor.withValues(alpha: 0.5), size: 25),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Text(address.address, maxLines: 3, overflow: TextOverflow.ellipsis,
            style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
        )),
      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),
    ]);
  }
}

class _WholesaleCollapsibleAddressSection extends StatefulWidget {
  final Widget addressContent;
  const _WholesaleCollapsibleAddressSection({required this.addressContent});

  @override
  State<_WholesaleCollapsibleAddressSection> createState() => _WholesaleCollapsibleAddressSectionState();
}

class _WholesaleCollapsibleAddressSectionState extends State<_WholesaleCollapsibleAddressSection> {
  bool isExpand = true;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      decoration: BoxDecoration(
        boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), spreadRadius: 1.5, blurRadius: 3)],
        color: Theme.of(context).cardColor,
      ),
      child: Column(children: [
        Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(getTranslated('address', context)!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color)),
            InkWell(
              onTap: () => setState(() => isExpand = !isExpand),
              child: AnimatedRotation(
                turns: isExpand ? 0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
          ]),
        ),

        Divider(thickness: 0.2, height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.45)),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isExpand
            ? Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: widget.addressContent,
            )
            : const SizedBox(),
        ),
      ]),
    );
  }
}
