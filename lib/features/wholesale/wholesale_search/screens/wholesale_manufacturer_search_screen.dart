import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_manufacturer_filter_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_search_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_seller_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_seller_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/controllers/wholesale_offers_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/controllers/wholesale_search_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/widgets/wholesale_popular_tags_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/widgets/wholesale_search_default_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleManufacturerSearchScreen extends StatefulWidget {
  const WholesaleManufacturerSearchScreen({super.key});

  @override
  State<WholesaleManufacturerSearchScreen> createState() => _WholesaleManufacturerSearchScreenState();
}

class _WholesaleManufacturerSearchScreenState extends State<WholesaleManufacturerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String _type = WholesaleManufacturerFilterType.all;

  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FocusScope.of(context).requestFocus(_focusNode);
      final WholesaleSearchController searchController = Provider.of<WholesaleSearchController>(context, listen: false);
      searchController.initHistory();
      searchController.getPopularTags();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _load({required bool reload, int offset = 1}) {
    Provider.of<WholesaleOffersController>(context, listen: false).getAllManufacturers(
      offset: offset, type: _type, reload: reload, search: _searchController.text.trim(),
    );
  }

  void _search() {
    final String term = _searchController.text.trim();
    _focusNode.unfocus();
    if (term.isNotEmpty) {
      Provider.of<WholesaleSearchController>(context, listen: false).saveSearchName(term);
    }
    setState(() => _hasSearched = true);
    _load(reload: true);
  }

  void _handleBack() {
    if (_hasSearched) {
      _searchController.clear();
      _focusNode.unfocus();
      setState(() => _hasSearched = false);
      return;
    }
    Navigator.pop(context);
  }

  void _clearSearch() {
    _searchController.clear();
    if (_hasSearched) {
      _focusNode.unfocus();
      setState(() => _hasSearched = false);
    } else {
      setState(() {});
    }
  }

  void _onTermSelected(String term) {
    _searchController.text = term;
    _searchController.selection = TextSelection.fromPosition(TextPosition(offset: term.length));
    _search();
  }

  Future<void> _openFilterSheet() async {
    final String? type = await WholesaleManufacturerFilterBottomSheet.show(context, selectedType: _type);
    if (type == null || !mounted) return;
    if (type == _type && _hasSearched) return;

    setState(() {
      _type = type;
      _hasSearched = true;
    });
    _load(reload: true);
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



  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final bool isFiltered = _type != WholesaleManufacturerFilterType.all;

    return PopScope(
      canPop: !_hasSearched,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          automaticallyImplyLeading: false,
          toolbarHeight: 64,
          titleSpacing: 0,
          elevation: 0,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          title: Row(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18,
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: .75)),
                onPressed: _handleBack,
              ),
            ),
            Expanded(
              child: WholesaleSearchBarWidget(
                controller: _searchController,
                focusNode: _focusNode,
                hintText: getTranslated('search_manufacturers', context) ?? 'Search Manufacturers',
                onSubmitted: (_) => _search(),
                onSearchPressed: _search,
                onClearPressed: _clearSearch,
                onChanged: () => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeSmall, end: Dimensions.paddingSizeDefault, bottom: 8),
              child: InkWell(
                onTap: _openFilterSheet,
                child: Icon(
                  Icons.filter_list,
                  color: isFiltered ? (isDark ? Colors.white : Theme.of(context).primaryColor) : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: .75),
                ),
              ),
            ),
          ]),
        ),
        body: !_hasSearched
            ? SingleChildScrollView(
                child: Column(children: [
                  WholesaleSearchDefaultViewWidget(onTermSelected: _onTermSelected),
                  WholesalePopularTagsWidget(onTagSelected: _onTermSelected),
                ]),
              )
            : Consumer<WholesaleOffersController>(
                builder: (context, controller, _) {
                  final List<WholesaleSeller>? sellers = controller.allManufacturers;

                  if (sellers == null) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(Dimensions.homePagePadding),
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(height: Dimensions.paddingSizeDefault),
                      itemBuilder: (_, __) => const WholesaleSellerCardShimmerWidget(),
                    );
                  }

                  if (sellers.isEmpty) {
                    return const Center(child: NoInternetOrDataScreenWidget(isNoInternet: false, icon: Images.noOffer));
                  }

                  return PaginatedListView(
                    scrollController: _scrollController,
                    totalSize: controller.allManufacturersTotalSize,
                    offset: controller.allManufacturersOffset,
                    onPaginate: (offset) async => _load(reload: false, offset: offset ?? 1),
                    itemView: Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(Dimensions.homePagePadding),
                        itemCount: sellers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: Dimensions.paddingSizeDefault),
                        itemBuilder: (context, index) => WholesaleSellerCard(
                          seller: sellers[index],
                          onChat: () => openWholesaleSellerChat(context, sellers[index]),
                          onTap: () => _openShop(sellers[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
