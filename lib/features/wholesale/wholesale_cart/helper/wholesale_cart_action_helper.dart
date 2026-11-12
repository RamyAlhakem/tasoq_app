import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_loader_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_color_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_add_to_cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_shipping_method_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:provider/provider.dart';

bool wholesaleIsSellerWiseShipping(BuildContext context) {
  return Provider.of<SplashController>(context, listen: false).configModel?.wholesaleConfig?.shipping?.method == 'sellerwise_shipping';
}

bool wholesaleNeedsCartWideShipping(BuildContext context) {
  final shipping = Provider.of<SplashController>(context, listen: false).configModel?.wholesaleConfig?.shipping;
  return shipping?.method != 'sellerwise_shipping' && shipping?.inHouseShippingType == 'order_wise';
}

Future<void> wholesaleToggleCartSelection(BuildContext context, {int? cartId, String? cartGroupId, required bool isChecked}) {
  final WholesaleCartController cartController = Provider.of<WholesaleCartController>(context, listen: false);
  final int? guestId = wholesaleGuestId(context);

  return _runWithLoader(context, () => cartController.updateSelection(
        cartId: cartId,
        cartGroupId: cartGroupId,
        isChecked: isChecked,
        guestId: guestId,
      ));
}

Future<void> wholesaleRemoveCartItem(BuildContext context, {required int cartId}) {
  return Provider.of<WholesaleCartController>(context, listen: false).removeItem(cartId: cartId, guestId: wholesaleGuestId(context));
}

Future<void> wholesaleChooseShippingMethod(
  BuildContext context, {
  required List<String> cartGroupIds,
  required List<WholesaleCartShippingMethod> methods,
  int? selectedMethodId,
}) async {
  final int? methodId = await WholesaleShippingMethodBottomSheetWidget.show(context, methods: methods, selectedMethodId: selectedMethodId);
  if (methodId == null || !context.mounted) return;

  final WholesaleCartController cartController = Provider.of<WholesaleCartController>(context, listen: false);
  final int? guestId = wholesaleGuestId(context);

  final bool isSuccess = await _runWithLoader(context, () => cartController.setShippingMethod(
        cartGroupIds: cartGroupIds,
        shippingMethodId: methodId,
        guestId: guestId,
      ));

  if (isSuccess) {
    showCustomSnackBarWidget(getTranslated('shipping_method_added_successfully', Get.context!), Get.context!, snackBarType: SnackBarType.success);
  }
}

Future<void> wholesaleReorderToCart(BuildContext context, {required int orderId}) async {
  final WholesaleOrderController orderController = Provider.of<WholesaleOrderController>(context, listen: false);
  final WholesaleCartController cartController = Provider.of<WholesaleCartController>(context, listen: false);
  final int? guestId = wholesaleGuestId(context);
  final List<ColorsModel>? colorCatalogue = Provider.of<SplashController>(context, listen: false).configModel?.colors;

  showDialog(context: context, barrierDismissible: false, builder: (_) => const CustomLoaderWidget());
  try {
    await orderController.loadOrderDetails(orderId, reload: true);
    final List<WholesaleOrderProductItemModel> items = (orderController.orderDetailsFor(orderId)?.products ?? const [])
        .where((p) => p.isAvailable && p.productId != null)
        .toList();

    if (items.isEmpty) {
      showCustomSnackBarWidget(getTranslated('no_items_available_to_reorder', Get.context!), Get.context!, snackBarType: SnackBarType.error);
      return;
    }

    int addedCount = 0;
    String? errorMessage;
    int? shippingMethodId;

    for (final WholesaleOrderProductItemModel item in items) {
      final Map<String, String> variation = _wholesaleReorderVariation(item, colorCatalogue);
      WholesaleAddToCartResult result = await cartController.addToCart(
        productId: item.productId!,
        quantity: item.qty,
        variation: variation,
        shippingMethodId: shippingMethodId,
        guestId: guestId,
      );

      if (result.requiresShippingMethod && Get.context!.mounted) {
        shippingMethodId = await WholesaleShippingMethodBottomSheetWidget.show(Get.context!, methods: result.shippingMethods);
        if (shippingMethodId == null) {
          errorMessage ??= getTranslated('something_went_wrong', Get.context!);
          break;
        }
        result = await cartController.addToCart(
          productId: item.productId!,
          quantity: item.qty,
          variation: variation,
          shippingMethodId: shippingMethodId,
          guestId: guestId,
        );
      }

      if (result.isSuccess) {
        addedCount++;
      } else {
        errorMessage ??= result.message ?? getTranslated('something_went_wrong', Get.context!);
      }
    }

    if (addedCount > 0) cartController.getCart(guestId: guestId, reload: true);

    if (errorMessage == null) {
      showCustomSnackBarWidget(getTranslated('added_to_cart_successfully', Get.context!), Get.context!, snackBarType: SnackBarType.success);
    } else {
      showCustomSnackBarWidget(errorMessage, Get.context!, snackBarType: SnackBarType.error);
    }
  } finally {
    Navigator.of(Get.context!, rootNavigator: true).pop();
  }
}

Map<String, String> _wholesaleReorderVariation(WholesaleOrderProductItemModel item, List<ColorsModel>? colorCatalogue) {
  final Map<String, String> variation = {};

  item.variationSelection.forEach((title, value) {
    final String? choiceKey = item.choiceOptionKeyFor(title);
    if (choiceKey != null) {
      variation[choiceKey] = value;
    } else if (title.trim().toLowerCase() == 'color') {
      variation['color'] = _wholesaleReorderColorCode(item, colorCatalogue, value);
    } else {
      variation[title] = value;
    }
  });

  return variation;
}

String _wholesaleReorderColorCode(WholesaleOrderProductItemModel item, List<ColorsModel>? colorCatalogue, String name) {
  final String? code = WholesaleColorHelper.codeForName(colorCatalogue, name);
  if (code == null) return item.colorCodes.length == 1 ? item.colorCodes.first : name;

  for (final String productCode in item.colorCodes) {
    if (productCode.toLowerCase() == code.toLowerCase()) return productCode;
  }
  return code;
}

Future<T> _runWithLoader<T>(BuildContext context, Future<T> Function() action) async {
  showDialog(context: context, barrierDismissible: false, builder: (_) => const CustomLoaderWidget());
  try {
    return await action();
  } finally {
    Navigator.of(Get.context!, rootNavigator: true).pop();
  }
}
