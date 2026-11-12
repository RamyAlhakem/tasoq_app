import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_price_breakdown_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_total_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_restock_request_footer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleCartTotalFooterWidget extends StatefulWidget {
  final double total;
  final double? originalTotal;

  final double discountAmount;
  final double taxAmount;

  final VoidCallback onBuyNow;
  final VoidCallback onAddToCart;

  final bool isEnabled;

  final String? blockedMessage;

  final bool isBuyingNow;
  final bool isAddingToCart;

  final bool isOutOfStock;
  final bool isLoggedIn;
  final bool isRestockRequested;
  final bool isRequestingRestock;
  final VoidCallback? onRequestRestock;
  final VoidCallback? onPromptRestockLogin;

  const WholesaleCartTotalFooterWidget({
    super.key,
    required this.total,
    this.originalTotal,
    this.discountAmount = 0,
    this.taxAmount = 0,
    required this.onBuyNow,
    required this.onAddToCart,
    this.isEnabled = true,
    this.blockedMessage,
    this.isBuyingNow = false,
    this.isAddingToCart = false,
    this.isOutOfStock = false,
    this.isLoggedIn = false,
    this.isRestockRequested = false,
    this.isRequestingRestock = false,
    this.onRequestRestock,
    this.onPromptRestockLogin,
  });

  @override
  State<WholesaleCartTotalFooterWidget> createState() => _WholesaleCartTotalFooterWidgetState();
}

class _WholesaleCartTotalFooterWidgetState extends State<WholesaleCartTotalFooterWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final bool hasBreakdown = widget.discountAmount > 0 || widget.taxAmount > 0;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        boxShadow: isDark ? null : [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.12), offset: const Offset(0, -4), blurRadius: 12, spreadRadius: -2)],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
      AnimatedSize(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.bottomCenter,
        child: hasBreakdown && _isExpanded
            ? WholesaleCartPriceBreakdownWidget(discountAmount: widget.discountAmount, taxAmount: widget.taxAmount)
            : const SizedBox(width: double.infinity),
      ),

      WholesaleCartTotalRowWidget(
        total: widget.total,
        originalTotal: widget.originalTotal,
        isExpandable: hasBreakdown,
        isExpanded: hasBreakdown && _isExpanded,
        onToggle: () => setState(() => _isExpanded = !_isExpanded),
      ),

      if (!widget.isOutOfStock && !widget.isEnabled && (widget.blockedMessage?.isNotEmpty ?? false))
        Padding(
          padding: const EdgeInsets.only(left: Dimensions.homePagePadding, right: Dimensions.homePagePadding, bottom: Dimensions.paddingSizeSmall),
          child: Text(
            widget.blockedMessage!,
            textAlign: TextAlign.center,
            style: titilliumRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),

      widget.isOutOfStock
          ? WholesaleRestockRequestFooterWidget(
              isLoggedIn: widget.isLoggedIn,
              isRequested: widget.isRestockRequested,
              isRequesting: widget.isRequestingRestock,
              onRequestRestock: widget.onRequestRestock ?? () {},
              onPromptLogin: widget.onPromptRestockLogin ?? () {},
            )
          : Padding(
              padding: const EdgeInsets.only(left: Dimensions.homePagePadding, right: Dimensions.homePagePadding, bottom: Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(child: CustomButton(isBuy: true, radius: 6, buttonText: getTranslated('buy_now', context), isLoading: widget.isBuyingNow, onTap: widget.isEnabled && !widget.isAddingToCart ? widget.onBuyNow : null)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Expanded(child: CustomButton(radius: 6, buttonText: getTranslated('add_to_cart', context), isLoading: widget.isAddingToCart, onTap: widget.isEnabled && !widget.isBuyingNow ? widget.onAddToCart : null)),
              ]),
            ),
      ]),
    );
  }
}
