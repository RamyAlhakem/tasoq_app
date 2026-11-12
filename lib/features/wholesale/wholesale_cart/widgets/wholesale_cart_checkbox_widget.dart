import 'package:flutter/material.dart';

class WholesaleCartCheckboxWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const WholesaleCartCheckboxWidget({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 30,
      child: Checkbox(
        visualDensity: VisualDensity.compact,
        activeColor: Theme.of(context).primaryColor,
        checkColor: Colors.white,
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            width: 2,
            color: states.contains(WidgetState.selected) ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.50),
          ),
        ),
        value: value,
        onChanged: onChanged == null ? null : (checked) => onChanged!(checked ?? false),
      ),
    );
  }
}
