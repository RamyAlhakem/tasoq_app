import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_filter_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_list_result_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_sort_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/domain/models/wholesale_product_filter_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/controllers/wholesale_offer_products_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offer_products/domain/wholesale_offer_type.dart';
import 'package:provider/provider.dart';

class WholesaleOfferProductsScreen extends StatefulWidget {
  final String title;
  final WholesaleOfferType type;

  const WholesaleOfferProductsScreen({super.key, required this.title, required this.type});

  @override
  State<WholesaleOfferProductsScreen> createState() => _WholesaleOfferProductsScreenState();
}

class _WholesaleOfferProductsScreenState extends State<WholesaleOfferProductsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final WholesaleOfferProductsController controller = Provider.of<WholesaleOfferProductsController>(context, listen: false);
    controller.setOfferType(widget.type);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) controller.loadProducts(page: 1);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openSortSheet(WholesaleOfferProductsController controller) async {
    final WholesaleSortOption? sort = await WholesaleProductSortBottomSheet.show(context, selected: controller.filter.sort);
    if (sort == null || !mounted) return;

    controller.applySort(sort);
    controller.loadProducts(page: 1);
  }

  Future<void> _openFilterSheet(WholesaleOfferProductsController controller) async {
    final WholesaleProductFilterModel? filter = await WholesaleProductFilterBottomSheet.show(
      context,
      currentFilter: controller.filter,
      priceBounds: controller.priceBounds,
    );
    if (filter == null || !mounted) return;

    controller.applyFilter(filter);
    controller.loadProducts(page: 1);
  }

  void _clearFilter(WholesaleOfferProductsController controller) {
    controller.clearFilter();
    controller.loadProducts(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Consumer<WholesaleOfferProductsController>(
        builder: (context, controller, _) {
          return WholesaleProductListResultWidget(
            source: controller,
            scrollController: _scrollController,
            onSortTap: () => _openSortSheet(controller),
            onFilterTap: () => _openFilterSheet(controller),
            onClearFilter: () => _clearFilter(controller),
            onRetry: () => controller.loadProducts(page: 1),
          );
        },
      ),
    );
  }
}
