import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/category_content_screen_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_sliver_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/enums/auction_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_category/controllers/auction_category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/auction/auction_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_home/domain/models/auction_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

AuctionCardState _cardState(AuctionProduct p) {
  return p.auctionDetails?.status == 'upcoming' ? AuctionCardState.upcoming : AuctionCardState.live;
}

DateTime _targetTime(AuctionProduct p) {
  final isLive = _cardState(p) == AuctionCardState.live;
  final raw = isLive ? p.auctionDetails?.endTime : p.auctionDetails?.startTime;
  return raw != null ? DateTime.tryParse(raw) ?? DateTime.now() : DateTime.now();
}

double _price(AuctionProduct p) {
  final isLive = _cardState(p) == AuctionCardState.live;
  if (isLive) {
    final highest = p.auctionDetails?.highestBidAmount;
    return (highest != null && highest != 0) ? highest.toDouble() : (p.startingPrice?.toDouble() ?? 0.0);
  }
  return p.startingPrice?.toDouble() ?? 0.0;
}

class CategoryContent extends StatelessWidget {
  final String categoryName;
  final int categoryId;

  const CategoryContent({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) => _CategoryContentBody(
    categoryName: categoryName,
    categoryId: categoryId,
  );
}

class _CategoryContentBody extends StatefulWidget {
  final String categoryName;
  final int categoryId;

  const _CategoryContentBody({
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<_CategoryContentBody> createState() => _CategoryContentBodyState();
}

class _CategoryContentBodyState extends State<_CategoryContentBody> with AutomaticKeepAliveClientMixin {
  final TextEditingController searchTextEditingController = TextEditingController();
  final DebounceHelper _debounceHelper = DebounceHelper(milliseconds: 500);
  String _activeSearchQuery = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<AuctionCategoryController>(context, listen: false).getCategoryProducts(widget.categoryId, 1);
    });
  }

  @override
  void dispose() {
    searchTextEditingController.dispose();
    _debounceHelper.dispose();
    super.dispose();
  }

  void _searchProducts() {
    final query = searchTextEditingController.text.trim();
    if (query.isEmpty) {
      showCustomSnackBarWidget(getTranslated('enter_somethings', context), Get.context!, snackBarType: SnackBarType.warning);
      return;
    }
    _debounceHelper.run(() {
      _activeSearchQuery = query;
      final controller = Provider.of<AuctionCategoryController>(context, listen: false);
      controller.clearCategoryProductFor(widget.categoryId);
      controller.getCategoryProducts(widget.categoryId, 1, searchProduct: _activeSearchQuery);
    });
  }

  void _clearSearch() {
    searchTextEditingController.clear();
    _activeSearchQuery = '';
    final controller = Provider.of<AuctionCategoryController>(context, listen: false);
    controller.clearCategoryProductFor(widget.categoryId);
    controller.getCategoryProducts(widget.categoryId, 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<AuctionCategoryController>(
      builder: (context, controller, _) {
        final model = controller.categoryProductsFor(widget.categoryId);
        final products = model?.products;
        final bool isLoading = products == null;

        return RefreshIndicator(
          onRefresh: () async {
            controller.clearCategoryProductFor(widget.categoryId);
            await controller.getCategoryProducts(widget.categoryId, 1, searchProduct: _activeSearchQuery);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),

              if (!isLoading)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverSearchBarDelegate(
                    height: 70,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: AuctionCategorySearchBar(
                        controller: searchTextEditingController,
                        onChanged: () => setState(() {}),
                        onSearch: _searchProducts,
                        onClear: _clearSearch,
                      ),
                    ),
                  ),
                ),

              if (isLoading)
                const SliverToBoxAdapter(child: CategoryContentScreenShimmer(isAuction: true))
              else if (products.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: NoInternetOrDataScreenWidget(isNoInternet: false, message: getTranslated('no_auction_found', context)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  sliver: PaginatedSliverListView(
                    scrollController: null,
                    totalSize: model?.totalSize,
                    offset: model?.offset,
                    onPaginate: (offset) => controller.getCategoryProducts(widget.categoryId, offset ?? 1, searchProduct: _activeSearchQuery),
                    itemView: SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeEight)
                          .copyWith(bottom: MediaQuery.of(context).padding.bottom),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Container(
                            margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            child: AuctionCardWidget(
                              slug: product.slug ?? '',
                              state: _cardState(product),
                              imageUrl: product.thumbnailFullUrl?.path ?? '',
                              productName: product.name ?? '',
                              price: _price(product),
                              targetTime: _targetTime(product),
                              viewCount: product.auctionDetails?.totalViews ?? 0,
                              bidCount: product.auctionDetails?.totalBids,
                            ),
                          );
                        },
                        childCount: products.length,
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

class AuctionCategorySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const AuctionCategorySearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeSmall).copyWith(right: Dimensions.paddingSizeDefault),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onChanged: (value) => onChanged(),
              onFieldSubmitted: (value) => onSearch(),
              style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      borderSide: BorderSide(color: Colors.grey[300]!)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      borderSide: BorderSide(color: Colors.grey[300]!)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      borderSide: BorderSide(color: Colors.grey[300]!)),
                  hintText: getTranslated('search_auction', context),
                  hintStyle: textRegular.copyWith(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.9)),
                  suffixIcon: SizedBox(width: controller.text.isNotEmpty ? 70 : 50,
                    child: Row(children: [
                      if(controller.text.isNotEmpty)
                        InkWell(
                          onTap: onClear,
                          child: const Icon(Icons.clear, size: 20,),
                        ),

                      InkWell(
                        onTap: onSearch,
                        child: Container(
                          margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                          child: Image.asset(Images.search, color: Colors.white, height: Dimensions.iconSizeSmall, width: Dimensions.iconSizeSmall, fit: BoxFit.contain),
                        ),
                      ),
                    ]),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const _SliverSearchBarDelegate({required this.child, required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_SliverSearchBarDelegate oldDelegate) => oldDelegate.child != child || oldDelegate.height != height;
}