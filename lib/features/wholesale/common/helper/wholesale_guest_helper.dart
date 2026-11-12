import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:provider/provider.dart';

int? wholesaleGuestId(BuildContext context) {
  final AuthController authController = Provider.of<AuthController>(context, listen: false);
  if (authController.isLoggedIn()) return null;
  return int.tryParse(authController.getGuestToken() ?? '');
}

void openWholesaleChat(
  BuildContext context, {
  required int? id,
  required String? name,
  String? image,
  bool isShopOnVacation = false,
  bool isShopTemporaryClosed = false,
  bool isDelivery = false,
}) {
  void openChat() {
    if (isDelivery) Provider.of<ChatController>(context, listen: false).setUserTypeIndex(context, 1);
    RouterHelper.getChatScreenRoute(
      action: RouteAction.push,
      id: id,
      name: name,
      image: image,
      isShopOnVacation: isShopOnVacation,
      isShopTemporaryClosed: isShopTemporaryClosed,
      isDelivery: false,
      userType: isDelivery ? 0 : 1,
    );
  }

  if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
    openChat();
    return;
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.chatScreen, onLoginSuccess: openChat),
  );
}

void openWholesaleSellerChat(BuildContext context, WholesaleSeller seller) {
  openWholesaleChat(
    context,
    id: seller.sellerId,
    name: seller.shopName,
    image: seller.shopLogoUrl?.path,
    isShopOnVacation: seller.isShopOnVacation ?? false,
    isShopTemporaryClosed: seller.isShopTemporaryClosed ?? false,
  );
}
