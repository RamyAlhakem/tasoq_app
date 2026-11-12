import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

enum WholesaleRefundStatus {
  pending('pending'),
  approved('approved'),
  refunded('refunded'),
  rejected('rejected'),
  success('success'),
  info('info'),
  danger('danger'),
  other('');

  final String label;

  const WholesaleRefundStatus(this.label);

  static WholesaleRefundStatus fromString(String? value) {
    if (value == null || value.isEmpty) return WholesaleRefundStatus.other;

    return WholesaleRefundStatus.values.firstWhere(
      (e) => e.label == value,
      orElse: () => WholesaleRefundStatus.other,
    );
  }
}

extension WholesaleRefundStatusColor on WholesaleRefundStatus {
  Color color(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    switch (this) {
      case WholesaleRefundStatus.success:
      case WholesaleRefundStatus.refunded:
        return isDark ? Theme.of(context).colorScheme.onTertiaryContainer : Colors.green;
      case WholesaleRefundStatus.info:
      case WholesaleRefundStatus.approved:
        return isDark ? Theme.of(context).colorScheme.outline : Colors.blue;
      case WholesaleRefundStatus.danger:
      case WholesaleRefundStatus.rejected:
        return isDark ? Theme.of(context).colorScheme.error : Colors.red;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  Color timelineColor(BuildContext context) {
    switch (this) {
      case WholesaleRefundStatus.pending:
        return Theme.of(context).primaryColor;
      case WholesaleRefundStatus.approved:
      case WholesaleRefundStatus.refunded:
        return Theme.of(context).colorScheme.onTertiaryContainer;
      case WholesaleRefundStatus.rejected:
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).hintColor;
    }
  }
}
