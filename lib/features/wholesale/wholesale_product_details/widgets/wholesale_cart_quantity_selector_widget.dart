import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

typedef WholesaleQuantityChanged = void Function(int quantity, {bool immediate});

class WholesaleCartQuantitySelectorWidget extends StatefulWidget {
  final int quantity;
  final int minimumOrderQuantity;

  final int? maximumQuantity;

  final WholesaleQuantityChanged onChanged;

  const WholesaleCartQuantitySelectorWidget({
    super.key,
    required this.quantity,
    required this.minimumOrderQuantity,
    this.maximumQuantity,
    required this.onChanged,
  });

  @override
  State<WholesaleCartQuantitySelectorWidget> createState() => _WholesaleCartQuantitySelectorWidgetState();
}

class _WholesaleCartQuantitySelectorWidgetState extends State<WholesaleCartQuantitySelectorWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant WholesaleCartQuantitySelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final String qtyText = widget.quantity.toString();
    if (_controller.text != qtyText) {
      _controller.text = qtyText;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: qtyText.length));
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) return;

    _commit(int.tryParse(_controller.text) ?? widget.quantity);
  }

  int _clamp(int qty) {
    final int min = widget.minimumOrderQuantity;
    final int? max = widget.maximumQuantity;
    if (qty < min) return min;
    if (max != null && qty > max) return max;
    return qty;
  }

  void _commit(int qty) {
    final int clamped = _clamp(qty);
    final String text = clamped.toString();
    _controller.text = text;
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: text.length));
    widget.onChanged(clamped, immediate: true);
  }

  @override
  Widget build(BuildContext context) {
    final bool atMaximum = widget.maximumQuantity != null && widget.quantity >= widget.maximumQuantity!;

    return Row(children: [
      Expanded(
        child: Text(
          getTranslated('quantity', context) ?? 'Quantity',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      _WholesaleCartQuantityButton(
        isIncrement: false,
        enabled: widget.quantity > widget.minimumOrderQuantity,
        onTap: () => _commit(widget.quantity - 1),
      ),
      const SizedBox(width: Dimensions.paddingSizeDefault),

      SizedBox(
        width: 70,
        height: 40,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.done,
          style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          onChanged: (value) {
            final int? typed = int.tryParse(value);

            if (typed == null || typed < 1) return;
            widget.onChanged(typed, immediate: false);
          },
          onSubmitted: (_) => _focusNode.unfocus(),
        ),
      ),
      const SizedBox(width: Dimensions.paddingSizeDefault),

      _WholesaleCartQuantityButton(
        isIncrement: true,
        enabled: !atMaximum,
        onTap: () => _commit(widget.quantity + 1),
      ),
    ]);
  }
}

class _WholesaleCartQuantityButton extends StatelessWidget {
  final bool isIncrement;
  final bool enabled;
  final VoidCallback onTap;

  const _WholesaleCartQuantityButton({required this.isIncrement, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    final Color backgroundColor = isIncrement
        ? (enabled ? primaryColor : Theme.of(context).disabledColor)
        : primaryColor.withValues(alpha: 0.1);
    final Color iconColor = isIncrement
        ? (isDark ? Colors.white : Theme.of(context).cardColor)
        : (enabled ? primaryColor : Theme.of(context).hintColor);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).hintColor.withValues(alpha: 0.3),
        highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
        onTap: enabled ? onTap : null,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
          child: Icon(isIncrement ? Icons.add : Icons.remove, color: iconColor, size: 26),
        ),
      ),
    );
  }
}
