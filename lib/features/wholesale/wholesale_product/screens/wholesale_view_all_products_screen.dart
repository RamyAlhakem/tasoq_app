import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/controllers/wholesale_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/enums/wholesale_product_list_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_search_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class WholesaleViewAllProductsScreen extends StatefulWidget {
  final WholesaleProductListType type;

  final String? slug;

  final int? categoryId;

  const WholesaleViewAllProductsScreen(
      {super.key, required this.type, this.slug, this.categoryId});

  @override
  State<WholesaleViewAllProductsScreen> createState() =>
      _WholesaleViewAllProductsScreenState();
}

class _WholesaleViewAllProductsScreenState
    extends State<WholesaleViewAllProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _activeSearch = '';

  bool get _isSearchable =>
      widget.type == WholesaleProductListType.recentlyViewed;

  static const int _shimmerItemCount = 6;

  static const int _defaultLimit = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _load(offset: 1);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({required int offset}) {
    final bool isLoggedIn =
        Provider.of<AuthController>(context, listen: false).isLoggedIn();
    final WholesaleProductController productController =
        Provider.of<WholesaleProductController>(context, listen: false);

    switch (widget.type) {
      case WholesaleProductListType.recentlyViewed:
        return productController.getRecentlyViewedProducts(
            isLoggedIn: isLoggedIn, offset: offset, search: _activeSearch);
      case WholesaleProductListType.sellerProducts:
        return productController.getSellerProducts(widget.slug ?? '',
            offset: offset);
      case WholesaleProductListType.similarProducts:
        return productController.getSimilarProducts(widget.slug ?? '',
            offset: offset);
      case WholesaleProductListType.mostDemanded:
      case WholesaleProductListType.bestPrices:
        return productController.getRailProducts(widget.type.rail!,
            categoryId: widget.categoryId, offset: offset);
    }
  }

  WholesaleProductListModel? _modelOf(
      WholesaleProductController productController) {
    switch (widget.type) {
      case WholesaleProductListType.recentlyViewed:
        return _activeSearch.isEmpty
            ? productController.recentlyViewedModel
            : productController.recentlyViewedSearchModel;
      case WholesaleProductListType.sellerProducts:
        return productController.sellerProductsFor(widget.slug ?? '');
      case WholesaleProductListType.similarProducts:
        return productController.similarProductsFor(widget.slug ?? '');
      case WholesaleProductListType.mostDemanded:
      case WholesaleProductListType.bestPrices:
        return productController.railProductsFor(widget.type.rail!,
            categoryId: widget.categoryId);
    }
  }

  void _search() {
    final String query = _searchController.text.trim();
    if (query == _activeSearch) return;
    setState(() => _activeSearch = query);
    _load(offset: 1);
  }

  void _clearSearch() {
    _searchController.clear();
    if (_activeSearch.isEmpty) {
      setState(() {});
      return;
    }
    setState(() => _activeSearch = '');
    _load(offset: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: getTranslated(widget.type.titleKey, context) ??
              widget.type.titleFallback),
      body: Column(
        children: [
          if (_isSearchable)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                Dimensions.homePagePadding,
                Dimensions.paddingSizeDefault,
                Dimensions.paddingSizeDefault,
                Dimensions.paddingSizeSmall,
              ),
              child: WholesaleSearchBarWidget(
                controller: _searchController,
                hintText: getTranslated('search_products', context) ??
                    'Search Products',
                onSubmitted: (_) => _search(),
                onSearchPressed: _search,
                onClearPressed: _clearSearch,
                onChanged: () => setState(() {}),
              ),
            ),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<WholesaleProductController>(
      builder: (context, productController, _) {
        final WholesaleProductListModel? model = _modelOf(productController);
        final List<WholesaleProduct> products = model?.products ?? [];

        if (model == null) return _buildShimmer(context);

        if (products.isEmpty) {
          return const Center(
              child: NoInternetOrDataScreenWidget(isNoInternet: false));
        }

        return Padding(
          padding: const EdgeInsets.all(
              Dimensions.homePagePadding - Dimensions.paddingSizeExtraSmall),
          child: PaginatedListView(
            scrollController: _scrollController,
            totalSize: model.totalSize,
            offset: model.offset,
            limit: model.limit ?? _defaultLimit,
            onPaginate: (offset) => _load(offset: offset ?? 1),
            itemView: Expanded(
              child: MasonryGridView.count(
                controller: _scrollController,
                crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                itemCount: products.length,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: WholesaleProductCardWidget(product: products[index]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
          Dimensions.homePagePadding - Dimensions.paddingSizeExtraSmall),
      child: MasonryGridView.count(
        crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
        itemCount: _shimmerItemCount,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: WholesaleProductCardShimmerWidget(),
        ),
      ),
    );
  }
}
