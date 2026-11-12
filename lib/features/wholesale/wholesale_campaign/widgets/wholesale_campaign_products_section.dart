import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCampaignProductsSection extends StatelessWidget {
  final List<WholesaleProduct>? products;
  final bool isLoadingMore;

  const WholesaleCampaignProductsSection({super.key, required this.products, this.isLoadingMore = false});

  static const int _shimmerCount = 4;

  @override
  Widget build(BuildContext context) {
    if (products != null && products!.isEmpty) return const SizedBox.shrink();

    final int itemCount = products?.length ?? _shimmerCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimensions.homePagePadding),
        const WholesaleSectionHeader(
          titleKey: 'explore_products',
          titleFallback: 'Explore Products',
          showViewAll: false,
        ),
        const SizedBox(height: Dimensions.homePagePadding),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Dimensions.paddingSizeSmall,
              mainAxisSpacing: Dimensions.paddingSizeDefault,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) => products == null ? const WholesaleProductCardShimmerWidget() : WholesaleProductCardWidget(product: products![index]),
          ),
        ),

        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
