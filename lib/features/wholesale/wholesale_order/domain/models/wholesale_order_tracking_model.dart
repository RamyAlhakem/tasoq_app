class WholesaleTrackingStep {
  final bool status;

  final String? dateTimeLabel;

  const WholesaleTrackingStep({this.status = false, this.dateTimeLabel});
}

class WholesaleOrderTrackingHistory {
  final WholesaleTrackingStep orderPlaced;
  final WholesaleTrackingStep orderConfirmed;
  final WholesaleTrackingStep preparingForShipment;
  final WholesaleTrackingStep orderIsOnTheWay;
  final WholesaleTrackingStep orderDelivered;

  final WholesaleTrackingStep orderCanceled;
  final String? canceledLabelKey;

  const WholesaleOrderTrackingHistory({
    this.orderPlaced = const WholesaleTrackingStep(),
    this.orderConfirmed = const WholesaleTrackingStep(),
    this.preparingForShipment = const WholesaleTrackingStep(),
    this.orderIsOnTheWay = const WholesaleTrackingStep(),
    this.orderDelivered = const WholesaleTrackingStep(),
    this.orderCanceled = const WholesaleTrackingStep(),
    this.canceledLabelKey,
  });

  factory WholesaleOrderTrackingHistory.fromJson(List<dynamic> steps) {
    Map<String, dynamic>? byKey(String key) {
      for (final dynamic step in steps) {
        if (step is Map && step['key'] == key) return Map<String, dynamic>.from(step);
      }
      return null;
    }

    WholesaleTrackingStep stepFor(String key) {
      final Map<String, dynamic>? json = byKey(key);
      if (json == null) return const WholesaleTrackingStep();
      return WholesaleTrackingStep(status: json['is_completed'] == true, dateTimeLabel: json['date_time']?.toString());
    }

    const List<String> terminalKeys = ['order_canceled', 'order_returned', 'order_failed'];
    String? terminalKey;
    for (final String key in terminalKeys) {
      if (byKey(key) != null) {
        terminalKey = key;
        break;
      }
    }

    return WholesaleOrderTrackingHistory(
      orderPlaced: stepFor('order_placed'),
      orderConfirmed: stepFor('order_confirmed'),
      preparingForShipment: stepFor('preparing_for_shipment'),
      orderIsOnTheWay: stepFor('order_is_on_the_way'),
      orderDelivered: stepFor('order_delivered'),
      orderCanceled: terminalKey != null ? stepFor(terminalKey) : const WholesaleTrackingStep(),
      canceledLabelKey: terminalKey,
    );
  }
}
