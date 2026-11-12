import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_video_player_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/youtube_video_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_product_details_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/controllers/wholesale_product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_purchase_options_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_bottom_cart_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_cart_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_more_from_seller_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_product_details_header_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_product_details_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_product_specification_review_faq_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_product_variation_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_related_products_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_store_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleProductDetailsScreen extends StatefulWidget {
  final String productSlug;
  final bool fromDeepLink;

  const WholesaleProductDetailsScreen({
    super.key,
    required this.productSlug,
    this.fromDeepLink = false,
  });

  @override
  State<WholesaleProductDetailsScreen> createState() => _WholesaleProductDetailsScreenState();
}

class _WholesaleProductDetailsScreenState extends State<WholesaleProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final controller = Provider.of<WholesaleProductDetailsController>(context, listen: false);
      controller.reset();

      controller.getProductDetails(
        widget.productSlug,
        colorCatalogue: Provider.of<SplashController>(context, listen: false).configModel?.colors,
      );
    });
  }

  void _handleDeepLinkBack() {
    RouterHelper.getDashboardRoute(action: RouteAction.pushNamedAndRemoveUntil, page: 'home');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDeepLinkEntry = widget.fromDeepLink && !Navigator.canPop(context);
    return PopScope(
      canPop: !isDeepLinkEntry,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _handleDeepLinkBack();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: WholesaleProductDetailsAppBarWidget(
          title: getTranslated('product_details', context) ?? 'Product Details',
          onBackPressed: isDeepLinkEntry ? _handleDeepLinkBack : null,
        ),
        body: Consumer<WholesaleProductDetailsController>(
          builder: (context, controller, _) {
            if (controller.isNotFound) {
              return Center(
                child: NoInternetOrDataScreenWidget(
                  isNoInternet: false,
                  message: getTranslated('product_not_found', context),
                ),
              );
            }

            final WholesaleProductDetailsModel? product = controller.product;
            if (product == null) return const WholesaleProductDetailsShimmer();

            return WholesaleProductDetailsBody(
              controller: controller,
              product: product,
              productSlug: widget.productSlug,
            );
          },
        ),
        bottomNavigationBar: Consumer<WholesaleProductDetailsController>(
          builder: (context, controller, _) => controller.product == null
              ? const SizedBox.shrink()
              : WholesaleBottomCartWidget(product: controller.product),
        ),
      ),
    );
  }
}

class WholesaleProductDetailsBody extends StatelessWidget {
  final WholesaleProductDetailsController controller;
  final WholesaleProductDetailsModel product;
  final String productSlug;

  const WholesaleProductDetailsBody({
    super.key,
    required this.controller,
    required this.product,
    required this.productSlug,
  });

  @override
  Widget build(BuildContext context) {
    final List<WholesaleVariationAxis> axes = product.purchaseOptions?.axes ?? const [];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WholesaleProductDetailsHeaderWidget(product: product, sharableLink: product.productShareLink),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          if (axes.isNotEmpty) ...[
            WholesaleProductVariationWidget(
              variations: [
                for (final WholesaleVariationAxis axis in axes)
                  WholesaleProductVariation(
                    name: wholesaleAxisLabel(context, axis),
                    options: [
                      for (final WholesaleAxisOption option in axis.options)
                        WholesaleVariationOption(
                          value: option.label,
                          color: axis.isColorAxis ? controller.swatchFor(option) : null,
                        ),
                    ],
                  ),
              ],
              onSelectVariation: () => WholesaleCartBottomSheetWidget.show(context, product: product),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          ],

          WholesaleProductSpecificationReviewFaqWidget(
            averageReview: product.rating,
            productSlug: productSlug,
            details: product.details,
            faqItems: [
              for (final WholesaleProductFaq faq in product.faqs)
                WholesaleFaqItem(question: faq.question ?? '', answer: faq.answer ?? ''),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          if ((product.video?.isValidYouTubeUrl ?? false) || (product.video?.isFile ?? false)) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: product.video!.isFile
                  ? CustomVideoPlayerWidget(url: product.video!.url!)
                  : YoutubeVideoWidget(url: product.video!.url),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          ],

          if (product.shop != null) ...[
            WholesaleStoreWidget(
              storeName: product.shop?.name ?? '',
              storeLogoUrl: product.shop?.imageFullUrl?.path,
              isVerified: product.shop?.isVerified ?? false,
              isTemporaryClosed: product.shop?.isShopTemporaryClosed ?? false,
              isOnVacation: (product.shop?.isShopOnVacation ?? false) || ((product.shop?.isClosed ?? false) && !(product.shop?.isShopTemporaryClosed ?? false)),
              reviewCount: product.shop?.reviewCount ?? 0,
              productCount: product.shop?.productCount ?? 0,
              onChat: product.shop?.id == null ? null : () => openWholesaleChat(
                context,
                id: product.shop!.sellerId,
                name: product.shop!.name,
                image: product.shop!.imageFullUrl?.path,
                isShopOnVacation: product.shop!.isShopOnVacation,
                isShopTemporaryClosed: product.shop!.isShopTemporaryClosed,
              ),
              onVisitStore: product.shop?.slug == null ? null
                  : () => RouterHelper.getWholesaleShopRoute(action: RouteAction.push, slug: product.shop!.slug!, shopId: product.shop!.id, shopName: product.shop!.name),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          ],

          WholesaleRelatedProductsSection(productSlug: productSlug),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          WholesaleMoreFromSellerSection(productSlug: productSlug),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ],
      ),
    );
  }
}


