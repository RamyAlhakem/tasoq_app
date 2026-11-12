import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/controllers/wholesale_home_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:provider/provider.dart';

void refreshWholesaleDataAfterOrder(BuildContext context) {
  final bool isLoggedIn = Provider.of<AuthController>(context, listen: false).isLoggedIn();

  Provider.of<WholesaleCartController>(context, listen: false).getCart(guestId: wholesaleGuestId(context), reload: true);

  if (isLoggedIn) {
    Provider.of<WholesaleOrderController>(context, listen: false).getOrderList(reload: true);
    Provider.of<WholesaleHomeController>(context, listen: false).getRecentOrders(isLoggedIn: true);
  }
}
