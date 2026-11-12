import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleShippingMethodBottomSheetWidget extends StatefulWidget {
  final List<WholesaleCartShippingMethod> methods;
  final int? selectedMethodId;

  const WholesaleShippingMethodBottomSheetWidget({super.key, required this.methods, this.selectedMethodId});

  static Future<int?> show(BuildContext context, {required List<WholesaleCartShippingMethod> methods, int? selectedMethodId}) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WholesaleShippingMethodBottomSheetWidget(methods: methods, selectedMethodId: selectedMethodId),
    );
  }

  @override
  State<WholesaleShippingMethodBottomSheetWidget> createState() => _WholesaleShippingMethodBottomSheetWidgetState();
}

class _WholesaleShippingMethodBottomSheetWidgetState extends State<WholesaleShippingMethodBottomSheetWidget> {
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedMethodId ?? (widget.methods.isNotEmpty ? widget.methods.first.id : null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeDefault)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const WholesaleShippingSheetHandle(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Text(getTranslated('select_shipping_method', context)!,
                        style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                      child: Text('${getTranslated('choose_a_method_for_your_delivery', context)}', style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: widget.methods.isEmpty
                    ? Center(child: Text('${getTranslated('no_shipping_method_available', context)}'))
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...widget.methods.map((method) => WholesaleShippingMethodTile(
                                method: method,
                                isSelected: method.id == _selectedId,
                                onTap: () => setState(() => _selectedId = method.id),
                              )),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          CustomButton(
                            buttonText: '${getTranslated('select', context)}',
                            onTap: _selectedId == null ? null : () => Navigator.of(context).pop(_selectedId),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WholesaleShippingSheetHandle extends StatelessWidget {
  const WholesaleShippingSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 5,
          width: 40,
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), color: Theme.of(context).hintColor),
        ),
      ),
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraExtraSmall),
              child: Icon(Icons.close, size: 20, color: Theme.of(context).hintColor),
            ),
          ),
        ),
      ),
    ]);
  }
}

class WholesaleShippingMethodTile extends StatelessWidget {
  final WholesaleCartShippingMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const WholesaleShippingMethodTile({super.key, required this.method, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final Color primary = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          border: isSelected
              ? Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.50) : primary.withValues(alpha: 0.50), width: 1)
              : Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .25) : primary.withValues(alpha: .25), width: .5),
          color: isSelected ? primary.withValues(alpha: 0.05) : Theme.of(context).cardColor,
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              isSelected
                  ? Icon(Icons.radio_button_checked, color: isDark ? Colors.white : primary)
                  : Icon(Icons.circle_outlined, color: Theme.of(context).colorScheme.tertiaryContainer),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Text(
                  '${method.title ?? ''}${(method.duration ?? '').isNotEmpty ? ' (${getTranslated('duration', context) ?? 'Duration'} ${method.duration})' : ''}',
                  style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              CustomDirectionalityWidget(
                child: Text(
                  PriceConverter.convertPrice(context, method.cost),
                  style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
