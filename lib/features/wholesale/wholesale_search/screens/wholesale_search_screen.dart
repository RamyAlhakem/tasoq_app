import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/controllers/wholesale_product_listing_mixin.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/controllers/wholesale_search_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/domain/models/wholesale_product_filter_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/widgets/wholesale_search_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/widgets/wholesale_popular_tags_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/widgets/wholesale_search_default_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_filter_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_list_result_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_sort_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

class WholesaleSearchScreen extends StatefulWidget {
  final String? initialQuery;
  final int? initialCategoryId;

  const WholesaleSearchScreen({super.key, this.initialQuery, this.initialCategoryId});

  @override
  State<WholesaleSearchScreen> createState() => _WholesaleSearchScreenState();
}

class _WholesaleSearchScreenState extends State<WholesaleSearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final WholesaleSearchController controller = Provider.of<WholesaleSearchController>(context, listen: false);
      controller.cleanSearch();
      controller.initHistory();
      controller.getPopularTags();

      if (widget.initialCategoryId != null) {
        controller.applyFilter(controller.filter.copyWith(categoryIds: {widget.initialCategoryId!}));
      }

      final String? initialQuery = widget.initialQuery?.trim();
      if (initialQuery != null && initialQuery.isNotEmpty) {
        _queryController.text = initialQuery;
        controller.submitSearch(initialQuery);
      }
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleBack() {
    final WholesaleSearchController controller = Provider.of<WholesaleSearchController>(context, listen: false);

    if (controller.listState != WholesaleProductListState.idle) {
      _queryController.clear();
      _focusNode.unfocus();
      controller.cleanSearch(notify: true);
      return;
    }

    Navigator.pop(context);
  }

  void _runSearch(String term) {
    _queryController.text = term;
    _focusNode.unfocus();
    Provider.of<WholesaleSearchController>(context, listen: false).submitSearch(term);
  }

  Future<void> _openSortSheet() async {
    final WholesaleSearchController controller = Provider.of<WholesaleSearchController>(context, listen: false);
    final WholesaleSortOption? sort = await WholesaleProductSortBottomSheet.show(context, selected: controller.filter.sort);

    if (sort == null || !mounted) return;

    controller.applySort(sort);
    controller.searchProduct(page: 1);
  }

  Future<void> _openFilterSheet() async {
    final WholesaleSearchController controller = Provider.of<WholesaleSearchController>(context, listen: false);
    final WholesaleProductFilterModel? filter = await WholesaleProductFilterBottomSheet.show(
      context,
      currentFilter: controller.filter,
      priceBounds: controller.priceBounds,
    );

    if (filter == null || !mounted) return;

    controller.applyFilter(filter);
    controller.searchProduct(page: 1);
  }

  void _clearFilter() {
    final WholesaleSearchController controller = Provider.of<WholesaleSearchController>(context, listen: false);
    controller.clearFilter();
    controller.searchProduct(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: WholesaleSearchAppBar(
          queryController: _queryController,
          focusNode: _focusNode,
          onBackPressed: _handleBack,
        ),
        body: Consumer<WholesaleSearchController>(
          builder: (context, controller, _) {
            if (controller.listState == WholesaleProductListState.idle) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WholesaleSearchDefaultViewWidget(onTermSelected: _runSearch),
                    WholesalePopularTagsWidget(onTagSelected: _runSearch),
                  ],
                ),
              );
            }

            return WholesaleProductListResultWidget(
              source: controller,
              scrollController: _scrollController,
              onSortTap: _openSortSheet,
              onFilterTap: _openFilterSheet,
              onClearFilter: _clearFilter,
              onRetry: () => controller.loadProducts(page: 1),
            );
          },
        ),
      ),
    );
  }
}
