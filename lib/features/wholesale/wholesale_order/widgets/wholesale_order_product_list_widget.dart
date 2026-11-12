import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_product_item_widget.dart';

class WholesaleOrderProductListWidget extends StatelessWidget {
  final int orderId;
  final List<WholesaleOrderProductItemModel> products;
  final bool isOrderDelivered;
  const WholesaleOrderProductListWidget({super.key, required this.orderId, required this.products, this.isOrderDelivered = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) => WholesaleOrderProductItemWidget(
        orderId: orderId,
        product: products[index],
        showDivider: index != products.length - 1,
        isOrderDelivered: isOrderDelivered,
      ),
    );
  }
}
