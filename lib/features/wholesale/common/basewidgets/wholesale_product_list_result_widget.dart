import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/controllers/wholesale_product_listing_mixin.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class WholesaleProductListResultWidget extends StatelessWidget {
  final WholesaleProductListingMixin source;
  final ScrollController scrollController;
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;
  final VoidCallback? onClearFilter;
  final VoidCallback onRetry;

  const WholesaleProductListResultWidget({
    super.key,
    required this.source,
    required this.scrollController,
    required this.onSortTap,
    required this.onFilterTap,
    this.onClearFilter,
    required this.onRetry,
    this.isNested = false,
    this.showHeader = true,
  });

  final bool isNested;

  final bool showHeader;

  static const int _shimmerItemCount = 6;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader) ...[
            _buildHeader(context),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
          isNested ? _buildBody(context) : Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final int? totalSize = source.resultModel?.totalSize;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
      child: Row(children: [
        Expanded(
          child: Text(
            totalSize == null
                ? (getTranslated('product_list', context) ?? 'Product List') : '$totalSize ${getTranslated('product_list', context) ?? 'Product List'}',
            style: titilliumSemiBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null,
            ),
          ),
        ),
        _buildActionButton(context, icon: Images.sort, isApplied: source.isSortApplied, onTap: onSortTap),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        _buildActionButton(context, icon: Images.filterIcon, isApplied: source.isFilterApplied, onTap: onFilterTap),
      ]),
    );
  }

  Widget _buildActionButton(BuildContext context, {required String icon, required bool isApplied, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
            ),
            child: CustomAssetImageWidget(icon, height: 18, width: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          if (isApplied)
            PositionedDirectional(
              top: -2,
              end: -2,
              child: CircleAvatar(radius: 5, backgroundColor: Theme.of(context).primaryColor),
            ),
        ]),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (source.listState) {
      case WholesaleProductListState.idle:
      case WholesaleProductListState.loading:
        return _buildShimmer(context);

      case WholesaleProductListState.error:
        return _buildMessage(
          context,
          message: getTranslated(source.errorMessage ?? 'something_went_wrong', context) ?? source.errorMessage ?? 'Something went wrong',
          actionLabel: getTranslated('try_again', context) ?? 'Try again',
          onAction: onRetry,
        );

      case WholesaleProductListState.empty:
        return _buildMessage(
          context,
          message: getTranslated('no_product_found', context) ?? 'No product found',
          actionLabel: source.isFilterApplied && onClearFilter != null ? (getTranslated('clear_filter', context) ?? 'Clear filter') : null,
          onAction: source.isFilterApplied ? onClearFilter : null,
        );

      default:
        return _buildGrid(context);
    }
  }

  Widget _buildGrid(BuildContext context) {
    final List<WholesaleProduct> products = source.products;

    final Widget paginated = PaginatedListView(
        scrollController: scrollController,
        totalSize: source.resultModel?.totalSize,
        offset: source.resultModel?.offset,
        limit: source.resultModel?.limit ?? WholesaleProductListingMixin.kLimit,
        onPaginate: (offset) async => source.loadProducts(page: offset ?? 1),
        itemView: MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
          itemCount: products.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: WholesaleProductCardWidget(product: products[index]),
          ),
        ),
    );

    return isNested ? paginated : SingleChildScrollView(controller: scrollController, child: paginated);
  }

  Widget _buildShimmer(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: isNested,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
      itemCount: _shimmerItemCount,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        child: WholesaleProductCardShimmerWidget(),
      ),
    );
  }

  Widget _buildMessage(BuildContext context, {required String message, String? actionLabel, VoidCallback? onAction}) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final Widget column = Column(children: [
        NoInternetOrDataScreenWidget(isNoInternet: false, message: message),
        if (actionLabel != null && onAction != null)
          Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
            child: OutlinedButton(
              onPressed: onAction,
              style: isDark ? OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                backgroundColor: Theme.of(context).cardColor,
                side: BorderSide(color: Theme.of(context).primaryColor),
              ) : null,
              child: Text(actionLabel),
            ),
          ),
    ]);

    return isNested ? column : SingleChildScrollView(child: column);
  }
}
