import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_sliver_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/wholesale_offer_type.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WholesalePriceDropItemsSection extends StatelessWidget {
  static const int _shimmerItemCount = 6;

  final List<WholesaleProduct>? products;
  final int? totalSize;
  final int? offset;
  final ScrollController scrollController;
  final Future<void> Function(int? offset) onPaginate;

  const WholesalePriceDropItemsSection({
    super.key,
    required this.products,
    required this.totalSize,
    required this.offset,
    required this.scrollController,
    required this.onPaginate,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [BoxShadow(color: Color(0x12000000), offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0)],
      ),
      sliver: SliverMainAxisGroup(slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeSmall)),
        SliverToBoxAdapter(
          child: WholesaleSectionHeader(
            titleKey: 'price_drop_items',
            titleFallback: 'Price Drop Items',
            onViewAll: () => RouterHelper.getWholesaleOfferProductsScreenRoute(
              action: RouteAction.push,
              title: getTranslated('price_drop_items', Get.context!) ?? 'Price Drop Items',
              type: WholesaleOfferType.priceDrop,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeExtraSmall)),
        if (products == null)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding - Dimensions.paddingSizeExtraSmall),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: WholesaleProductCardShimmerWidget(),
              ),
              childCount: _shimmerItemCount,
            ),
          )
        else
          PaginatedSliverListView(
            scrollController: scrollController,
            totalSize: totalSize,
            offset: offset,
            onPaginate: onPaginate,
            itemView: SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding - Dimensions.paddingSizeExtraSmall),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: WholesaleProductCardWidget(product: products![index]),
                ),
                childCount: products!.length,
              ),
            ),
          ),
      ]),
    );
  }
}
