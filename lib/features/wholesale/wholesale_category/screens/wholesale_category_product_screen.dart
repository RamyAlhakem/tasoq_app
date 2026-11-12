import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_product_list_result_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/domain/models/wholesale_category_node_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/controllers/wholesale_offers_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product/controllers/wholesale_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_search_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_seller_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_seller_card.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleCategoryProductScreen extends StatefulWidget {
  final WholesaleCategoryNode parentCategory;
  final int? initialSelectedId;
  final bool fromWholesalers;

  final int parentCategoryLevel;

  const WholesaleCategoryProductScreen({
    super.key,
    required this.parentCategory,
    this.initialSelectedId,
    this.fromWholesalers = false,
    this.parentCategoryLevel = 1,
  });

  @override
  State<WholesaleCategoryProductScreen> createState() => _WholesaleCategoryProductScreenState();
}

class _WholesaleCategoryProductScreenState extends State<WholesaleCategoryProductScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this, initialIndex: widget.fromWholesalers ? 1 : 0);
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _manufacturerScrollController = ScrollController();
  final ScrollController _productScrollController = ScrollController();
  late int? _selectedId = widget.initialSelectedId ?? widget.parentCategory.id;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchManufacturers();
    _fetchProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _manufacturerScrollController.dispose();
    _productScrollController.dispose();
    super.dispose();
  }

  ({int? categoryId, int? subCategoryId, int? subSubCategoryId}) _resolveCategorySelection() {
    final int? id = _selectedId;
    if (id == null) return (categoryId: null, subCategoryId: null, subSubCategoryId: null);

    final bool isParentSelected = id == widget.parentCategory.id;
    if (widget.parentCategoryLevel == 1) {
      return isParentSelected
          ? (categoryId: id, subCategoryId: null, subSubCategoryId: null)
          : (categoryId: null, subCategoryId: id, subSubCategoryId: null);
    }
    return isParentSelected
        ? (categoryId: null, subCategoryId: id, subSubCategoryId: null)
        : (categoryId: null, subCategoryId: null, subSubCategoryId: id);
  }

  void _fetchManufacturers({bool reload = true, int offset = 1}) {
    final selection = _resolveCategorySelection();

    Provider.of<WholesaleOffersController>(context, listen: false).getCategoryManufacturers(
      offset: offset, reload: reload, search: _searchQuery,
      categoryId: selection.categoryId, subCategoryId: selection.subCategoryId, subSubCategoryId: selection.subSubCategoryId,
    );
  }

  void _fetchProducts() {
    final selection = _resolveCategorySelection();

    Provider.of<WholesaleProductController>(context, listen: false).loadCategoryTabProducts(
      categoryId: selection.categoryId, subCategoryId: selection.subCategoryId, subSubCategoryId: selection.subSubCategoryId,
      search: _searchQuery,
    );
  }

  void _onSelectTab(int? id) {
    setState(() => _selectedId = id);
    _fetchManufacturers();
    _fetchProducts();
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      showCustomSnackBarWidget(getTranslated('enter_somethings', context), Get.context!, snackBarType: SnackBarType.warning);
      return;
    }
    setState(() => _searchQuery = query);
    _fetchManufacturers();
    _fetchProducts();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
    _fetchManufacturers();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      WholesaleCategoryNode(id: widget.parentCategory.id, name: getTranslated('all_products', context) ?? 'All Products'),
      ...?widget.parentCategory.children,
    ];

    return Scaffold(
      appBar: CustomAppBar(title: widget.parentCategory.name),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color: Theme.of(context).primaryColor),
              insets: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
            ),
            labelPadding: EdgeInsets.zero,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            labelStyle: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, height: 1.0),
            unselectedLabelStyle: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge, height: 1.0),
            tabs: [
              Tab(text: getTranslated('products', context)!),
              Tab(text: getTranslated('manufacturers', context)!),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: Dimensions.homePagePadding,
              end: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault + Dimensions.paddingSizeEight,
            ),
            child: WholesaleSearchBarWidget(
              controller: _searchController,
              hintText: getTranslated('search_products', context),
              onSubmitted: (_) => _search(),
              onSearchPressed: _search,
              onClearPressed: _clearSearch,
              onChanged: () => setState(() {}),
            ),
          ),
          if (tabs.length > 1)
            _CategoryChipRow(tabs: tabs, selectedId: _selectedId, onSelectTab: _onSelectTab),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ProductsTab(
                  scrollController: _productScrollController,
                  onRetry: _fetchProducts,
                ),
                _ManufacturersTab(
                  scrollController: _manufacturerScrollController,
                  onLoadMore: (offset) => _fetchManufacturers(reload: false, offset: offset),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChipRow extends StatefulWidget {
  final List<WholesaleCategoryNode> tabs;
  final int? selectedId;
  final ValueChanged<int?> onSelectTab;

  const _CategoryChipRow({required this.tabs, required this.selectedId, required this.onSelectTab});

  @override
  State<_CategoryChipRow> createState() => _CategoryChipRowState();
}

class _CategoryChipRowState extends State<_CategoryChipRow> {
  final GlobalKey _selectedChipKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? chipContext = _selectedChipKey.currentContext;
      if (chipContext == null) return;
      Scrollable.ensureVisible(chipContext, alignment: 0.5, duration: const Duration(milliseconds: 300));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Dimensions.homePagePadding, top: Dimensions.paddingSizeLarge, right: Dimensions.homePagePadding),
      child: SizedBox(
        height: 30,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int index = 0; index < widget.tabs.length; index++) ...[
                if (index > 0) const SizedBox(width: Dimensions.paddingSizeSmall),
                _CategoryTabChip(
                  key: widget.tabs[index].id == widget.selectedId ? _selectedChipKey : null,
                  label: widget.tabs[index].name ?? '',
                  isSelected: widget.tabs[index].id == widget.selectedId,
                  onTap: () => widget.onSelectTab(widget.tabs[index].id),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductsTab extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback onRetry;

  const _ProductsTab({
    required this.scrollController,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.homePagePadding),
        Expanded(
          child: WholesaleProductListResultWidget(
            source: context.watch<WholesaleProductController>(),
            scrollController: scrollController,
            showHeader: false,
            onSortTap: () {},
            onFilterTap: () {},
            onRetry: onRetry,
          ),
        ),
      ],
    );
  }
}

class _ManufacturersTab extends StatelessWidget {
  final ScrollController scrollController;
  final ValueChanged<int> onLoadMore;

  const _ManufacturersTab({required this.scrollController, required this.onLoadMore});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WholesaleOffersController>();
    final List<WholesaleSeller>? sellers = controller.categoryManufacturers;

    if (sellers == null) {
      return ListView.separated(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(height: Dimensions.paddingSizeDefault),
        itemBuilder: (context, index) => const WholesaleSellerCardShimmerWidget(),
      );
    }

    if (sellers.isEmpty) {
      return const Center(child: NoInternetOrDataScreenWidget(isNoInternet: false, icon: Images.noOffer));
    }

    return PaginatedListView(
      scrollController: scrollController,
      totalSize: controller.categoryManufacturersTotalSize,
      offset: controller.categoryManufacturersOffset,
      onPaginate: (offset) async => onLoadMore(offset ?? 1),
      itemView: Expanded(
        child: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          itemCount: sellers.length,
          separatorBuilder: (context, index) => const SizedBox(height: Dimensions.paddingSizeDefault),
          itemBuilder: (context, index) => WholesaleSellerCard(
            seller: sellers[index],
            onChat: () => openWholesaleSellerChat(context, sellers[index]),
            onTap: () => _openShop(sellers[index]),
          ),
        ),
      ),
    );
  }

  void _openShop(WholesaleSeller seller) {
    if (seller.slug == null) return;
    RouterHelper.getWholesaleShopRoute(
      action: RouteAction.push,
      slug: seller.slug!,
      shopId: seller.id,
      shopName: seller.shopName,
    );
  }


}

class _CategoryTabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTabChip({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.2)),
        ),
        child: Text(label,
          style: isSelected
              ? titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white)
              : titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleMedium?.color),
        ),
      ),
    );
  }
}
