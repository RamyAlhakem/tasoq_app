import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/helper/wholesale_cart_action_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_cart_footer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_cart_group_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_cart_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_pricing_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleCartScreen extends StatefulWidget {
  final bool showBackButton;

  const WholesaleCartScreen({super.key, this.showBackButton = true});

  @override
  State<WholesaleCartScreen> createState() => _WholesaleCartScreenState();
}

class _WholesaleCartScreenState extends State<WholesaleCartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadCart();
    });
  }

  Future<void> _loadCart() {
    return Provider.of<WholesaleCartController>(context, listen: false).getCart(guestId: wholesaleGuestId(context));
  }

  void _onCheckout(WholesaleCartListModel cart, List<WholesaleCartGroup> cartWideShippingGroups) {
    final bool isShippingMissing = cartWideShippingGroups.any((group) => group.selectedShippingMethodId == null);
    if (isShippingMissing) {
      wholesaleChooseShippingMethod(
        context,
        cartGroupIds: cartWideShippingGroups.map((group) => group.cartGroupId!).toList(),
        methods: cartWideShippingGroups.first.shippingMethods,
      );
      return;
    }
    if (!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) => NotLoggedInBottomSheetWidget(
          fromPage: widget.showBackButton ? RouterHelper.wholesaleCartScreen : '${RouterHelper.dashboardScreen}?page=cart',
          onLoginSuccess: _onLoginSuccess,
        ),
      );
      return;
    }
    RouterHelper.getWholesaleCheckoutScreenRoute(cartItems: wholesaleCheckoutItems(cart), action: RouteAction.push);
  }

  Future<void> _onLoginSuccess() async {
    final BuildContext? globalContext = Get.context;
    if (globalContext == null) return;
    await Provider.of<CartController>(globalContext, listen: false).mergeGuestCart();
    if (!globalContext.mounted) return;
    await Provider.of<WholesaleCartController>(globalContext, listen: false).getCart(reload: true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleCartController>(builder: (context, cartController, _) {
      final WholesaleCartListModel? cart = cartController.cart;
      final bool hasItems = cart != null && !cart.isEmpty;

      final List<WholesaleCartGroup> cartWideShippingGroups = hasItems && wholesaleNeedsCartWideShipping(context)
          ? cart.cartGroups.where((group) => group.isOrderWiseShipping && group.cartGroupId != null).toList()
          : const [];

      final bool isShippingMissing = cartWideShippingGroups.any((group) => group.selectedShippingMethodId == null);

      return Scaffold(
        appBar: CustomAppBar(title: getTranslated('my_cart', context), isBackButtonExist: widget.showBackButton),
        bottomNavigationBar: hasItems
            ? WholesaleCartFooterWidget(
                total: cart.summary.total,
                shippingPicker: cartWideShippingGroups.isNotEmpty ? WholesaleCartWideShippingPicker(groups: cartWideShippingGroups) : null,
                isUpdatingPrices: cartController.isUpdatingAnyQuantity,
                onCheckout: cart.canCheckout || isShippingMissing ? () => _onCheckout(cart, cartWideShippingGroups) : null,
              )
            : null,
        body: cart == null && cartController.isLoading
            ? const WholesaleCartShimmer()
            : RefreshIndicator(
                onRefresh: _loadCart,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    if (hasItems)
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                        sliver: SliverList.builder(
                          itemCount: cart.cartGroups.length,
                          itemBuilder: (context, index) => WholesaleCartGroupWidget(group: cart.cartGroups[index]),
                        ),
                      )
                    else
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: NoInternetOrDataScreenWidget(
                          icon: Images.emptyCart,
                          icCart: true,
                          isNoInternet: false,
                          message: 'no_product_in_cart',
                        ),
                      ),
                  ],
                ),
              ),
      );
    });
  }
}

List<WholesaleCartItemModel> wholesaleCheckoutItems(WholesaleCartListModel cart) {
  return cart.checkoutRows
      .map((row) => WholesaleCartItemModel(
            id: row.id ?? 0,
            productId: row.productId ?? 0,
            name: row.name ?? '',
            thumbnail: row.thumbnailUrl ?? '',
            pricingType: WholesalePricingType.none,
            variantKey: row.variant,
            attributeSummary: row.selectionSummary,
            quantity: row.quantity,
            minimumOrderQuantity: row.minimumQuantity,
            unitPrice: row.discountedUnitPrice,
            originalUnitPrice: row.hasDiscount ? row.unitPrice : null,
            tierLabel: row.tierLabel,
          ))
      .toList();
}
