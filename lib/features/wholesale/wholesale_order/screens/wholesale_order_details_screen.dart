import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/enum/wholesale_order_status.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_amount_due_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_cancel_and_support_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_delivery_man_section_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_due_payment_bottomsheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_amount_calculation_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_details_app_bar_title.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_details_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_note_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_payment_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_payment_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_product_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_seller_section_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_shipping_and_billing_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleOrderDetailsScreen extends StatefulWidget {
  final int orderId;
  final bool isNotification;
  const WholesaleOrderDetailsScreen({super.key, required this.orderId, this.isNotification = false});

  @override
  State<WholesaleOrderDetailsScreen> createState() => _WholesaleOrderDetailsScreenState();
}

class _WholesaleOrderDetailsScreenState extends State<WholesaleOrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleOrderController>(context, listen: false).loadOrderDetails(widget.orderId, reload: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isNotification && Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page: 'home');
      },
      child: Consumer<WholesaleOrderController>(
        builder: (context, controller, _) {
          final WholesaleOrderDetailsModel? orderDetails = controller.orderDetailsFor(widget.orderId);
          if (orderDetails == null) {
            return const WholesaleOrderDetailsShimmer();
          }
          return _WholesaleOrderDetailsBody(orderDetails: orderDetails);
        },
      ),
    );
  }
}

class _WholesaleOrderDetailsBody extends StatelessWidget {
  final WholesaleOrderDetailsModel orderDetails;
  const _WholesaleOrderDetailsBody({required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    final List<Widget> sections = [
      WholesaleOrderPaymentInfoWidget(orderDetails: orderDetails),

      WholesaleOrderPaymentWidget(paymentStatus: orderDetails.paymentStatus, paymentMethod: orderDetails.paymentMethod),

      if (orderDetails.orderNote != null && orderDetails.orderNote!.isNotEmpty)
        WholesaleOrderNoteWidget(note: orderDetails.orderNote ?? ''),

      WholesaleShippingAndBillingWidget(orderDetails: orderDetails),

      Column(children: [
        WholesaleSellerSectionWidget(sellerName: orderDetails.sellerName, orderDetails: orderDetails),
        WholesaleOrderProductListWidget(
          orderId: orderDetails.id,
          products: orderDetails.products,
          isOrderDelivered: orderDetails.status == WholesaleOrderStatus.delivered,
        ),
      ]),

      WholesaleOrderAmountCalculationWidget(orderDetails: orderDetails),

      if (orderDetails.editedStatus == 1 && (orderDetails.latestEditHistory?.orderDueAmount ?? 0) > 0 && orderDetails.latestEditHistory?.orderDuePaymentStatus != 'paid')
        WholesaleAmountDueCard(
          showButton: true,
          title: getTranslated('pay_due_bill', context) ?? '',
          price: PriceConverter.convertPrice(context, orderDetails.latestEditHistory!.orderDueAmount!),
          description: getTranslated('after_editing_your_product_list', context) ?? '',
          buttonText: getTranslated('pay_now', context) ?? '',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => WholesaleDuePaymentBottomSheetWidget(orderId: orderDetails.id),
            );
          },
        ),

      if (orderDetails.editedStatus == 1 && (orderDetails.latestEditHistory?.orderReturnAmount ?? 0) > 0 && orderDetails.latestEditHistory?.orderReturnPaymentStatus != 'returned')
        WholesaleAmountDueCard(
          title: getTranslated('amount_to_be_returned', context) ?? '',
          price: PriceConverter.convertPrice(context, orderDetails.latestEditHistory!.orderReturnAmount!),
          description: getTranslated('after_editing_your_product_list_you_will_receive_this', context) ?? '',
        ),

      if (orderDetails.deliveryMan != null)
        WholesaleDeliveryManSectionWidget(deliveryMan: orderDetails.deliveryMan!),

      const WholesaleSupportContactWidget(),
    ];

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Material(
          color: Theme.of(context).cardColor,
          elevation: 3.0,
          shadowColor: Theme.of(context).cardColor,
          child: Container(),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).highlightColor,
        toolbarHeight: 80,
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        title: WholesaleOrderDetailsAppBarTitle(
          orderId: orderDetails.id,
          status: orderDetails.status,
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            itemCount: sections.length,
            separatorBuilder: (_, __) => const SizedBox(height: Dimensions.paddingSizeDefault),
            itemBuilder: (_, index) => sections[index],
          ),
        ),
        Container(
          color: Theme.of(context).cardColor,
          child: WholesaleOrderActionButtonWidget(orderId: orderDetails.id, status: orderDetails.status),
        ),
      ]),
    );
  }
}
