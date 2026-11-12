import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_add_to_cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/domain/models/wholesale_cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/widgets/wholesale_shipping_method_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/controllers/wholesale_product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_price_quote_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_pricing_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_purchase_options_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_discount_banner_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_image_gallery_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_quantity_selector_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_sheet_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_total_footer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_variant_price_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_variation_tier_cards_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_variation_selector_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_color_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleCartBottomSheetWidget extends StatelessWidget {
  final VoidCallback? callback;

  const WholesaleCartBottomSheetWidget({super.key, this.callback});

  static Future<void> show(BuildContext context, {required WholesaleProductDetailsModel? product}) {
    if (product?.isShopClosed ?? false) {
      showCustomSnackBarWidget(getTranslated('this_shop_is_close_now', context), context, snackBarType: SnackBarType.error);
      return Future<void>.value();
    }

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0),
      builder: (_) => WholesaleCartBottomSheetWidget(
        callback: () => showCustomSnackBarWidget(
          getTranslated('added_to_cart', context), context, snackBarType: SnackBarType.success),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Consumer<WholesaleProductDetailsController>(
            builder: (context, controller, _) {
              final WholesaleProductDetailsModel? product = controller.product;
              if (product == null) {
                return const Column(mainAxisSize: MainAxisSize.min, children: [
                  WholesaleCartSheetHandle(),
                  Flexible(child: SingleChildScrollView(child: WholesaleCartSheetShimmer())),
                ]);
              }

              final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WholesaleCartSheetHandle(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                        child: WholesaleCartSheetBody(controller: controller, product: product),
                      ),
                    ),
                  ),
                  if (!isKeyboardOpen)
                    WholesaleCartSheetFooter(controller: controller, product: product, callback: callback),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class WholesaleCartSheetHandle extends StatelessWidget {
  const WholesaleCartSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Icon(Icons.cancel, color: Theme.of(context).hintColor, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WholesaleCartSheetBody extends StatelessWidget {
  final WholesaleProductDetailsController controller;
  final WholesaleProductDetailsModel product;

  const WholesaleCartSheetBody({super.key, required this.controller, required this.product});

  @override
  Widget build(BuildContext context) {
    final List<WholesaleVariationAxis> axes = controller.axes;
    final List<WholesalePriceTier> tiers = controller.activePriceRow?.tiers ?? const [];

    if (axes.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WholesaleCartSheetGallery(controller: controller, product: product),
          if (tiers.isNotEmpty) WholesaleCartSheetVariationTierCards(controller: controller, tiers: tiers),
          WholesaleCartSheetPurchaseCard(controller: controller),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WholesaleCartSheetDiscountBanner(controller: controller),
        Text(
          getTranslated('variations', context) ?? 'Variations',
          style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        WholesaleCartSheetVariationPicker(controller: controller, axes: axes),

        tiers.isNotEmpty
            ? WholesaleCartSheetVariationTierCards(controller: controller, tiers: tiers)
            : const SizedBox(height: Dimensions.paddingSizeDefault),

        WholesaleCartSheetGallery(controller: controller, product: product),
        WholesaleCartSheetPurchaseCard(controller: controller),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      ],
    );
  }
}

class WholesaleCartSheetDiscountBanner extends StatelessWidget {
  final WholesaleProductDetailsController controller;

  const WholesaleCartSheetDiscountBanner({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final WholesaleDiscountHighlights? highlights = controller.product?.purchaseOptions?.discountHighlights;
    final List<WholesaleDiscountHighlightItem> items = highlights?.items ?? const [];
    if (highlights?.kind == null || items.isEmpty) return const SizedBox.shrink();

    final bool isCombination = highlights!.isCombination;
    final String axisTitle = wholesaleAxisTitle(context, controller.axes, highlights.axisKey);

    final List<WholesaleCombinationDiscountOffer> offers = [
      for (final WholesaleDiscountHighlightItem item in items)
        WholesaleCombinationDiscountOffer(
          label: _label(item, axisTitle: axisTitle, isCombination: isCombination),
          minQty: item.minQty,
        ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall),
      child: WholesaleCartDiscountBannerWidget(
        unitLabel: isCombination ? (getTranslated('combination', context) ?? 'Combination') : axisTitle,
        offers: offers,
        onSelectOffer: (offer) {
          final int index = offers.indexOf(offer);
          if (index >= 0) controller.applyDiscountHighlight(items[index]);
        },
      ),
    );
  }

  String _label(WholesaleDiscountHighlightItem item, {required String axisTitle, required bool isCombination}) {
    final String value = item.variationValue ?? item.value ?? '';
    if (!isCombination) return value;

    final String range = item.maxQty != null ? '${item.minQty}-${item.maxQty}' : '${item.minQty}+';
    return item.minQty == null ? '$axisTitle $value' : '$axisTitle $value ($range)';
  }
}

class WholesaleCartSheetVariationPicker extends StatelessWidget {
  final WholesaleProductDetailsController controller;
  final List<WholesaleVariationAxis> axes;

  const WholesaleCartSheetVariationPicker({super.key, required this.controller, required this.axes});

  @override
  Widget build(BuildContext context) {
    final colourCatalogue = Provider.of<SplashController>(context, listen: false).configModel?.colors;
    final Map<String, WholesaleVariationAxis> axisByLabel = {};
    final List<WholesaleVariationAttribute> attributes = [];
    final Map<String, int> selectedIndexByAttribute = {};

    for (final WholesaleVariationAxis axis in axes) {
      final String label = wholesaleAxisLabel(context, axis);
      axisByLabel[label] = axis;

      attributes.add(WholesaleVariationAttribute(
        name: label,
        options: [
          for (final WholesaleAxisOption option in axis.options)
            WholesaleVariationOptionValue(
              value: option.label,
              swatch: axis.isColorAxis ? WholesaleColorHelper.swatchForName(colourCatalogue, option.value) : null,
              hasDiscount: option.hasDiscount,
            ),
        ],
      ));

      final int selected = axis.options.indexWhere((option) => controller.isSelected(axis, option));
      selectedIndexByAttribute[label] = selected < 0 ? 0 : selected;
    }

    return WholesaleCartVariationSelectorWidget(
      attributes: attributes,
      selectedIndexByAttribute: selectedIndexByAttribute,
      onSelect: (attributeName, optionIndex) {
        final WholesaleVariationAxis? axis = axisByLabel[attributeName];
        if (axis == null || optionIndex >= axis.options.length) return;
        controller.selectOption(axis, axis.options[optionIndex]);
      },
    );
  }
}

class WholesaleCartSheetVariationTierCards extends StatelessWidget {
  final WholesaleProductDetailsController controller;
  final List<WholesalePriceTier> tiers;

  const WholesaleCartSheetVariationTierCards({super.key, required this.controller, required this.tiers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: WholesaleCartVariationTierCardsWidget(
        tiers: [for (final WholesalePriceTier tier in tiers) WholesaleQuantityTier(minQty: tier.minQty, maxQty: tier.maxQty)],
        tierPrices: [for (final WholesalePriceTier tier in tiers) tier.discountedUnitPrice ?? tier.unitPrice],
        selectedTierIndex: controller.quote?.tierIndex ?? -1,
        onTapTierIndex: (index) => controller.selectTier(tiers[index]),
      ),
    );
  }
}

class WholesaleCartSheetGallery extends StatefulWidget {
  final WholesaleProductDetailsController controller;
  final WholesaleProductDetailsModel product;

  const WholesaleCartSheetGallery({super.key, required this.controller, required this.product});

  @override
  State<WholesaleCartSheetGallery> createState() => _WholesaleCartSheetGalleryState();
}

class _WholesaleCartSheetGalleryState extends State<WholesaleCartSheetGallery> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<WholesaleVariationAxis> imageAxes = widget.controller.imageAxes;
    final int tabIndex = imageAxes.isEmpty ? 0 : _tabIndex.clamp(0, imageAxes.length - 1);

    final List<String> axisImages = imageAxes.isEmpty ? const [] : widget.controller.imagesForAxis(imageAxes[tabIndex]);
    final List<String> images = axisImages.isNotEmpty
        ? axisImages : widget.product.allImages.map((image) => image.path ?? '').where((path) => path.isNotEmpty).toList();

    return WholesaleCartImageGalleryWidget(
      key: ValueKey('$tabIndex-${images.length}-${images.isEmpty ? '' : images.first}'),
      images: images,
      tabLabels: [for (final WholesaleVariationAxis axis in imageAxes) wholesaleAxisLabel(context, axis)],
      selectedTabIndex: tabIndex,
      onTabChanged: (index) => setState(() => _tabIndex = index),
    );
  }
}

class WholesaleCartSheetPurchaseCard extends StatelessWidget {
  final WholesaleProductDetailsController controller;

  const WholesaleCartSheetPurchaseCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WholesaleCartSheetVariantPriceRow(controller: controller),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, 0, Dimensions.paddingSizeExtraSmall,
            ),
            child: WholesaleCartSheetQuantity(controller: controller),
          ),
        ],
      ),
    );
  }
}

class WholesaleCartSheetVariantPriceRow extends StatelessWidget {
  final WholesaleProductDetailsController controller;

  const WholesaleCartSheetVariantPriceRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final WholesalePriceQuote? quote = controller.quote;

    final String variantKey = quote?.variantKey ?? '';
    if (variantKey.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: WholesaleCartVariantPriceRowWidget(
        variantKey: variantKey,
        price: quote?.discountedUnitPrice,
        originalPrice: (quote?.discountPerUnit ?? 0) > 0 ? quote?.unitPrice : null,
      ),
    );
  }
}

class WholesaleCartSheetQuantity extends StatelessWidget {
  final WholesaleProductDetailsController controller;

  const WholesaleCartSheetQuantity({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return WholesaleCartQuantitySelectorWidget(
      quantity: controller.quantity,
      minimumOrderQuantity: controller.quote?.minimumQuantity
          ?? controller.product?.purchaseOptions?.minimumOrderQty ?? controller.product?.minimumOrderQuantity ?? 1,
      maximumQuantity: controller.quote?.maximumQuantity,
      onChanged: (quantity, {immediate = false}) => controller.setQuantity(quantity, debounce: !immediate),
    );
  }
}

class WholesaleCartSheetFooter extends StatelessWidget {
  final WholesaleProductDetailsController controller;
  final WholesaleProductDetailsModel product;
  final VoidCallback? callback;

  const WholesaleCartSheetFooter({super.key, required this.controller, required this.product, this.callback});

  @override
  Widget build(BuildContext context) {
    final WholesalePriceQuote? quote = controller.quote;
    final bool canBuy = quote?.isPurchasableIn(isShopClosed: product.isShopClosed) ?? false;

    final bool isOutOfStock = !product.isShopClosed && quote?.reason == WholesaleQuoteReason.outOfStock;
    final bool isLoggedIn = Provider.of<AuthController>(context, listen: false).isLoggedIn();

    return Consumer<WholesaleCartController>(
      builder: (context, cartController, _) => WholesaleCartTotalFooterWidget(
        total: quote?.total ?? 0,
        originalTotal: (quote?.discountAmount ?? 0) > 0 ? quote?.subtotal : null,
        discountAmount: quote?.discountAmount ?? 0,
        taxAmount: quote?.taxAmount ?? 0,
        isEnabled: canBuy && !controller.isQuoting,
        blockedMessage: product.isShopClosed ? getTranslated('this_shop_is_close_now', context) : quote?.message,
        isBuyingNow: cartController.isBuyingNow,
        isAddingToCart: cartController.isAdding,
        onBuyNow: () => _submit(context, cartController, buyNow: true),
        onAddToCart: () => _submit(context, cartController, buyNow: false),
        isOutOfStock: isOutOfStock,
        isLoggedIn: isLoggedIn,
        isRestockRequested: controller.isRestockRequested(quote?.variantKey),
        isRequestingRestock: cartController.isRequestingRestock,
        onRequestRestock: () => _requestRestock(context, cartController, quote),
        onPromptRestockLogin: () => _promptRestockLogin(context),
      ),
    );
  }

  void _promptRestockLogin(BuildContext context) {
    Navigator.of(context).pop();
    showCustomSnackBarWidget(getTranslated('to_request_the_restock', context), context, snackBarType: SnackBarType.warning);
  }

  Future<void> _requestRestock(BuildContext context, WholesaleCartController cartController, WholesalePriceQuote? quote) async {
    final int? productId = product.id;
    if (productId == null) return;

    final bool isSuccess = await cartController.requestRestock(productId: productId, variation: controller.selection);
    if (!context.mounted || !isSuccess) return;

    controller.markRestockRequested(quote?.variantKey);
    Navigator.of(context).pop();
  }

  Future<void> _submit(BuildContext context, WholesaleCartController cartController, {required bool buyNow, int? shippingMethodId}) async {
    final int? productId = product.id;
    if (productId == null) return;

    if (buyNow && !Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      showCustomSnackBar(getTranslated('please_login_to_buy_this_product', context), context);
      return;
    }

    final int? guestId = wholesaleGuestId(context);

    final WholesaleAddToCartResult result = await cartController.addToCart(
      productId: productId,
      quantity: controller.quantity,
      variation: controller.selection,
      buyNow: buyNow,
      shippingMethodId: shippingMethodId,
      guestId: guestId,
    );
    if (!context.mounted || result.statusCode == null) return;

    if (result.requiresShippingMethod) {
      final int? methodId = await WholesaleShippingMethodBottomSheetWidget.show(context, methods: result.shippingMethods);
      if (methodId == null || !context.mounted) return;
      await _submit(context, cartController, buyNow: buyNow, shippingMethodId: methodId);
      return;
    }

    if (result.isSuccess) {
      Navigator.of(context).pop();
      controller.refreshQuote();
      cartController.getCart(guestId: guestId);

      if (buyNow || result.redirectsToCheckout) {
        RouterHelper.getWholesaleCheckoutScreenRoute(cartItems: [_checkoutItem(result.line)]);
      } else {
        callback?.call();
      }
      return;
    }

    if (result.isStale) {
      Navigator.of(context).pop();
      showCustomSnackBarWidget(result.message, Get.context, snackBarType: SnackBarType.error);
      if (product.slug != null) {
        controller.getProductDetails(
          product.slug!,
          colorCatalogue: Provider.of<SplashController>(Get.context!, listen: false).configModel?.colors,
          reload: true,
        );
      }
      return;
    }

    showOverlaySnackBar(context, result.message, snackBarType: SnackBarType.error);
    if (result.isQuantityIssue) controller.refreshQuote();
  }

  WholesaleCartItemModel _checkoutItem(WholesaleCartLine? line) {
    final WholesalePriceQuote? quote = controller.quote;
    final double unitPrice = quote?.discountedUnitPrice ?? 0;

    return WholesaleCartItemModel(
      id: line?.id ?? 0,
      productId: product.id ?? 0,
      name: line?.name ?? product.productName ?? '',
      thumbnail: product.thumbnailFullUrl?.path ?? '',
      pricingType: WholesalePricingType.none,
      variantKey: line?.variant ?? quote?.variantKey,
      attributeSummary: controller.selectionLabels,
      quantity: line?.quantity ?? controller.quantity,
      minimumOrderQuantity: quote?.minimumQuantity ?? product.minimumOrderQuantity ?? 1,
      unitPrice: unitPrice,
      originalUnitPrice: (quote?.unitPrice ?? 0) > unitPrice ? quote?.unitPrice : null,
    );
  }
}

String wholesaleAxisLabel(BuildContext context, WholesaleVariationAxis axis) {
  return axis.isColorAxis ? (getTranslated('color', context) ?? 'Color') : (axis.title ?? axis.key);
}

String wholesaleAxisTitle(BuildContext context, List<WholesaleVariationAxis> axes, String? axisKey) {
  for (final WholesaleVariationAxis axis in axes) {
    if (axis.key == axisKey) return wholesaleAxisLabel(context, axis);
  }
  return '';
}
