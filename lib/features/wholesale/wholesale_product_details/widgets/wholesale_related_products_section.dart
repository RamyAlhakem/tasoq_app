import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_feature_highlights_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_most_demanded_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/controllers/wholesale_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleRelatedProductsSection extends StatefulWidget {
  final String productSlug;

  const WholesaleRelatedProductsSection({super.key, required this.productSlug});

  @override
  State<WholesaleRelatedProductsSection> createState() => _WholesaleRelatedProductsSectionState();
}

class _WholesaleRelatedProductsSectionState extends State<WholesaleRelatedProductsSection> {
  static const int _shimmerItemCount = 2;
  static const int _maxRowCount = 2;
  static const double _rowHeight = 117.5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleProductController>(context, listen: false).getSimilarProducts(widget.productSlug);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.85;
    final List<WholesaleTrustPolicy> highlights = Provider.of<SplashController>(context, listen: false)
        .configModel?.wholesaleConfig?.trustPolicy ?? [];

    return Consumer<WholesaleProductController>(
      builder: (context, productController, _) {
        final WholesaleProductListModel? model = productController.similarProductsFor(widget.productSlug);
        final List<WholesaleProduct> products = model?.products ?? [];

        if (model != null && products.isEmpty) return const SizedBox.shrink();

        final int itemCount = model == null ? _shimmerItemCount : products.length;
        final int rowCount = itemCount < _maxRowCount ? itemCount : _maxRowCount;
        final double gridHeight = (rowCount * _rowHeight)
            + ((rowCount - 1) * Dimensions.paddingSizeSmall)
            + (2 * Dimensions.paddingSizeExtraSmall);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (highlights.isNotEmpty) ...[
              WholesaleFeatureHighlightsWidget(highlights: highlights),
              const SizedBox(height: Dimensions.paddingSizeLarge),
            ],
            WholesaleSectionHeader(titleKey: 'related_products', titleFallback: 'Related Products', showViewAll : false),
            const SizedBox(height: Dimensions.paddingSizeTwelve),

            SizedBox(
              height: gridHeight,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.homePagePadding,
                  vertical: Dimensions.paddingSizeExtraSmall,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowCount,
                  crossAxisSpacing: Dimensions.paddingSizeSmall,
                  mainAxisSpacing: Dimensions.paddingSizeSmall,
                  mainAxisExtent: cardWidth,
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) => model == null ? const WholesaleShimmerBoxWidget() : WholesaleMostDemandedProductCard(product: products[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}
