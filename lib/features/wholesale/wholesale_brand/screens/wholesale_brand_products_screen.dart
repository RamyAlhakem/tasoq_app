import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_filter_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_list_result_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_sort_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/domain/models/wholesale_product_filter_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/controllers/wholesale_brand_products_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';

class WholesaleBrandProductsScreen extends StatefulWidget {
  final int brandId;
  final String? brandName;

  const WholesaleBrandProductsScreen({super.key, required this.brandId, this.brandName});

  @override
  State<WholesaleBrandProductsScreen> createState() => _WholesaleBrandProductsScreenState();
}

class _WholesaleBrandProductsScreenState extends State<WholesaleBrandProductsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final WholesaleBrandProductsController controller = Provider.of<WholesaleBrandProductsController>(context, listen: false);
      controller.setBrand(widget.brandId);
      controller.loadProducts(page: 1);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openSortSheet(WholesaleBrandProductsController controller) async {
    final WholesaleSortOption? sort = await WholesaleProductSortBottomSheet.show(context, selected: controller.filter.sort);
    if (sort == null || !mounted) return;

    controller.applySort(sort);
    controller.loadProducts(page: 1);
  }

  Future<void> _openFilterSheet(WholesaleBrandProductsController controller) async {
    final WholesaleProductFilterModel? filter = await WholesaleProductFilterBottomSheet.show(
      context,
      currentFilter: controller.filter,
      priceBounds: controller.priceBounds,
      showBrands: false,
    );
    if (filter == null || !mounted) return;

    controller.applyFilter(filter);
    controller.loadProducts(page: 1);
  }

  void _clearFilter(WholesaleBrandProductsController controller) {
    controller.clearFilter();
    controller.loadProducts(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    final String? brandName = widget.brandName;

    return Scaffold(
      appBar: CustomAppBar(title: (brandName != null && brandName.isNotEmpty) ? brandName : getTranslated('brand', context)),
      body: Consumer<WholesaleBrandProductsController>(
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
