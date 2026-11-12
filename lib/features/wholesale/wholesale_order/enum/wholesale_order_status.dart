import 'package:flutter/material.dart';

enum WholesaleOrderStatus {
  all('all'),
  pending('pending'),
  confirmed('confirmed'),
  processing('processing'),
  processed('processed'),
  outForDelivery('out_for_delivery'),
  delivered('delivered'),
  failed('failed'),
  returned('returned'),
  canceled('canceled');

  final String label;

  const WholesaleOrderStatus(this.label);

  static WholesaleOrderStatus fromString(String? value) {
    if (value == null || value.isEmpty) return WholesaleOrderStatus.all;

    return WholesaleOrderStatus.values.firstWhere((e) =>
      e.label.toLowerCase() == value.toLowerCase() ||
          e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => WholesaleOrderStatus.all,
    );
  }

  String toJson() => label;
}

extension WholesaleOrderStatusColor on WholesaleOrderStatus {
  Color color(BuildContext context) {
    switch (this) {
      case WholesaleOrderStatus.delivered:
      case WholesaleOrderStatus.confirmed:
        return Theme.of(context).colorScheme.onTertiaryContainer;
      case WholesaleOrderStatus.pending:
        return Theme.of(context).primaryColor;
      case WholesaleOrderStatus.processing:
      case WholesaleOrderStatus.processed:
      case WholesaleOrderStatus.outForDelivery:
        return Theme.of(context).colorScheme.outline;
      case WholesaleOrderStatus.canceled:
      case WholesaleOrderStatus.failed:
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }
}
