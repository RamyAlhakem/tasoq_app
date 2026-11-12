class WholesaleCourierShipmentModel {
  final String? deliveryPartner;
  final String? trackingNumber;
  final String? shipmentStatus;
  final String? shipmentStatusLabel;
  final String? trackingUrl;
  final String? instruction;

  const WholesaleCourierShipmentModel({
    this.deliveryPartner,
    this.trackingNumber,
    this.shipmentStatus,
    this.shipmentStatusLabel,
    this.trackingUrl,
    this.instruction,
  });

  factory WholesaleCourierShipmentModel.fromJson(Map<String, dynamic> json) {
    return WholesaleCourierShipmentModel(
      deliveryPartner: json['delivery_partner']?.toString(),
      trackingNumber: json['tracking_number']?.toString(),
      shipmentStatus: json['shipment_status']?.toString(),
      shipmentStatusLabel: json['shipment_status_label']?.toString(),
      trackingUrl: json['tracking_url']?.toString(),
      instruction: json['instruction']?.toString(),
    );
  }
}

class WholesaleOrderTrackingSummaryModel {
  final String orderStatus;
  final String? statusLabel;
  final String? statusTone;
  final WholesaleCourierShipmentModel? courierShipment;
  final bool hasDeliveryMan;

  const WholesaleOrderTrackingSummaryModel({
    this.orderStatus = '',
    this.statusLabel,
    this.statusTone,
    this.courierShipment,
    this.hasDeliveryMan = false,
  });

  factory WholesaleOrderTrackingSummaryModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> wholesale = json['wholesale'] is Map ? Map<String, dynamic>.from(json['wholesale']) : {};
    final dynamic courier = wholesale['courier_shipment'];

    return WholesaleOrderTrackingSummaryModel(
      orderStatus: json['order_status']?.toString() ?? '',
      statusLabel: wholesale['status_label']?.toString(),
      statusTone: wholesale['status_tone']?.toString(),
      courierShipment: courier is Map ? WholesaleCourierShipmentModel.fromJson(Map<String, dynamic>.from(courier)) : null,
      hasDeliveryMan: json['delivery_man'] != null,
    );
  }
}
