import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_tracking_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_tracking_summary_model.dart' show WholesaleCourierShipmentModel;
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_courier_shipment_info_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_status_stepper_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_track_with_delivery_partner_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_tracking_error_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_tracking_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleTrackingResultScreen extends StatefulWidget {
  final int orderId;
  final String? phoneNumber;
  const WholesaleTrackingResultScreen({super.key, required this.orderId, this.phoneNumber});

  @override
  State<WholesaleTrackingResultScreen> createState() => _WholesaleTrackingResultScreenState();
}

class _WholesaleTrackingResultScreenState extends State<WholesaleTrackingResultScreen> {
  @override
  void initState() {
    super.initState();
    final WholesaleOrderController controller = Provider.of<WholesaleOrderController>(context, listen: false);
    controller.loadTrackingHistory(widget.orderId, phoneNumber: widget.phoneNumber);
    controller.loadOrderTracking(widget.orderId, phoneNumber: widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('TRACK_ORDER', context)),
      body: Consumer<WholesaleOrderController>(
        builder: (context, controller, _) {
          final WholesaleOrderTrackingHistory? history = controller.trackingHistoryFor(widget.orderId);
          if (history == null) {
            if (controller.didTrackingFail(widget.orderId)) {
              return WholesaleTrackingErrorWidget(orderId: widget.orderId, phoneNumber: widget.phoneNumber);
            }
            return const WholesaleTrackingShimmer();
          }

          final WholesaleCourierShipmentModel? courierShipment = controller.trackingSummaryFor(widget.orderId)?.courierShipment;

          return ListView(children: [
            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Center(child: RichText(
                text: TextSpan(children: [
                  TextSpan(text: getTranslated('your_order', context),
                    style: textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                  TextSpan(text: '  #${widget.orderId}',
                    style: textBold.copyWith(color: Theme.of(context).primaryColor)),
                ]),
              )),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(children: [
                WholesaleStatusStepperWidget(
                  title: getTranslated('order_placed', context) ?? '',
                  icon: Images.orderPlacedIconTimeline,
                  checked: true,
                  dateTimeLabel: history.orderPlaced.dateTimeLabel,
                  isCanceled: history.orderCanceled.status,
                  isNextTrue: history.orderConfirmed.status,
                ),

                if (history.orderPlaced.status && history.orderCanceled.status && !history.orderConfirmed.status)
                  _WholesaleCanceledStepWidget(history: history),

                WholesaleStatusStepperWidget(
                  title: getTranslated('order_confirmed', context) ?? '',
                  icon: Images.orderConfirmedIconTimeline,
                  checked: history.orderConfirmed.status,
                  dateTimeLabel: history.orderConfirmed.dateTimeLabel,
                  isCanceled: history.orderCanceled.status,
                  isNextTrue: history.preparingForShipment.status,
                ),

                if (history.orderConfirmed.status && history.orderCanceled.status && !history.preparingForShipment.status)
                  _WholesaleCanceledStepWidget(history: history),

                WholesaleStatusStepperWidget(
                  title: getTranslated('preparing_for_shipment', context) ?? '',
                  icon: Images.prepareingForShippingIconTimeline,
                  checked: history.preparingForShipment.status,
                  dateTimeLabel: history.preparingForShipment.dateTimeLabel,
                  isCanceled: history.orderCanceled.status,
                  isNextTrue: history.orderIsOnTheWay.status,
                ),

                if (history.preparingForShipment.status && history.orderCanceled.status && !history.orderIsOnTheWay.status)
                  _WholesaleCanceledStepWidget(history: history),

                WholesaleStatusStepperWidget(
                  title: getTranslated('order_is_on_the_way', context) ?? '',
                  icon: Images.onTheWayIconTimeline,
                  checked: history.orderIsOnTheWay.status,
                  dateTimeLabel: history.orderIsOnTheWay.dateTimeLabel,
                  isCanceled: history.orderCanceled.status,
                  isNextTrue: history.orderDelivered.status,
                ),

                if (history.orderIsOnTheWay.status && history.orderCanceled.status && !history.orderDelivered.status)
                  _WholesaleCanceledStepWidget(history: history),

                WholesaleStatusStepperWidget(
                  title: getTranslated('order_delivered', context) ?? '',
                  icon: Images.deliverdIconTimeline,
                  checked: history.orderDelivered.status,
                  dateTimeLabel: history.orderDelivered.dateTimeLabel,
                  isLastItem: true,
                ),
              ]),
            ),

            if (courierShipment != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                child: WholesaleCourierShipmentInfoCardWidget(shipment: courierShipment),
              ),

            if ((courierShipment?.trackingUrl ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                child: WholesaleTrackWithDeliveryPartnerButtonWidget(trackingUrl: courierShipment!.trackingUrl!),
              ),
          ]);
        },
      ),
    );
  }
}

class _WholesaleCanceledStepWidget extends StatelessWidget {
  final WholesaleOrderTrackingHistory history;
  const _WholesaleCanceledStepWidget({required this.history});

  @override
  Widget build(BuildContext context) {
    return WholesaleStatusStepperWidget(
      title: getTranslated(history.canceledLabelKey, context) ?? '',
      icon: Images.cancel,
      checked: true,
      isStatusCanceled: true,
      dateTimeLabel: history.orderCanceled.dateTimeLabel,
    );
  }
}
