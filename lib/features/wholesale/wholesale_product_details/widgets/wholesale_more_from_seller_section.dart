import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/controllers/wholesale_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/enums/wholesale_product_list_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class WholesaleMoreFromSellerSection extends StatefulWidget {
  final String productSlug;

  const WholesaleMoreFromSellerSection({super.key, required this.productSlug});

  @override
  State<WholesaleMoreFromSellerSection> createState() => _WholesaleMoreFromSellerSectionState();
}

class _WholesaleMoreFromSellerSectionState extends State<WholesaleMoreFromSellerSection> {
  static const int _shimmerItemCount = 4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleProductController>(context, listen: false).getSellerProducts(widget.productSlug);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleProductController>(
      builder: (context, productController, _) {
        final WholesaleProductListModel? model = productController.sellerProductsFor(widget.productSlug);
        final List<WholesaleProduct> products = model?.products ?? [];

        if (model != null && products.isEmpty) return const SizedBox.shrink();

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(color: Color(0x12000000), offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0),
            ],
          ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeEight),
            WholesaleSectionHeader(
              titleKey: 'more_from_the_seller',
              titleFallback: 'More From the Whole Seller',
              onViewAll: () => RouterHelper.getWholesaleViewAllProductsScreenRoute(
                action: RouteAction.push,
                type: WholesaleProductListType.sellerProducts,
                slug: widget.productSlug,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(11),
              child: MasonryGridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                itemCount: model == null ? _shimmerItemCount : products.length,
                itemBuilder: (context, index) => RepaintBoundary(
                  child: Container(
                    margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: model == null
                        ? const WholesaleProductCardShimmerWidget()
                        : WholesaleProductCardWidget(product: products[index]),
                  ),
                ),
              ),
            ),
          ],
          ),
        );
      },
    );
  }
}
