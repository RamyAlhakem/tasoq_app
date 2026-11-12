import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/helper/wholesale_guest_helper.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/controllers/wholesale_home_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_search_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_seller_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_seller_card_shimmer_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/controllers/wholesale_offers_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:provider/provider.dart';

class WholesaleAllManufacturersScreen extends StatefulWidget {
  final String title;
  final List<WholesaleSeller>? sellers;

  final String manufacturerType;

  const WholesaleAllManufacturersScreen({super.key, required this.title, this.sellers, this.manufacturerType = 'top-discounted'});

  @override
  State<WholesaleAllManufacturersScreen> createState() => _WholesaleAllManufacturersScreenState();
}

class _WholesaleAllManufacturersScreenState extends State<WholesaleAllManufacturersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<WholesaleSeller> _staticSellers = widget.sellers ?? [];
  bool _isSearching = false;

  bool get _isStatic => widget.sellers != null;

  @override
  void initState() {
    super.initState();
    if (!_isStatic) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _load(reload: true);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _load({required bool reload, int offset = 1}) {
    Provider.of<WholesaleOffersController>(context, listen: false).getAllManufacturers(
      offset: offset, type: widget.manufacturerType, reload: reload, search: _searchController.text.trim(),
    );
  }

  void _search() => _isStatic ? _searchStatic() : _load(reload: true);

  void _clearSearch() {
    _searchController.clear();
    _isStatic ? _searchStatic() : _load(reload: true);
  }

  Future<void> _searchStatic() async {
    final String query = _searchController.text.trim();
    setState(() => _isSearching = true);

    final List<WholesaleSeller>? result = await Provider.of<WholesaleHomeController>(context, listen: false).searchRecentlyViewedSellers(query);
    if (!mounted || query != _searchController.text.trim()) return;

    setState(() {
      _staticSellers = result ?? _staticSellers;
      _isSearching = false;
    });
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
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              Dimensions.homePagePadding,
              Dimensions.paddingSizeDefault,
              Dimensions.paddingSizeDefault,
              Dimensions.paddingSizeSmall,
            ),
            child: WholesaleSearchBarWidget(
              controller: _searchController,
              hintText: getTranslated('search_manufacturers', context) ?? 'Search Manufacturers',
              onSubmitted: (_) => _search(),
              onSearchPressed: _search,
              onClearPressed: _clearSearch,
              onChanged: () => setState(() {}),
            ),
          ),
          Expanded(child: _isStatic ? _buildStaticList(context) : _buildPaginatedList(context)),
        ],
      ),
    );
  }

  Widget _buildStaticList(BuildContext context) {
    if (_isSearching) return const WholesaleSellerCardShimmerListWidget();

    final List<WholesaleSeller> sellers = _staticSellers;

    if (sellers.isEmpty) {
      return const Center(child: NoInternetOrDataScreenWidget(isNoInternet: false, icon: Images.noOffer));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(Dimensions.homePagePadding),
      itemCount: sellers.length,
      separatorBuilder: (_, __) => const SizedBox(height: Dimensions.paddingSizeDefault),
      itemBuilder: (context, index) => WholesaleSellerCard(
        seller: sellers[index],
        onChat: () => openWholesaleSellerChat(context, sellers[index]),
        onTap: () => _openShop(sellers[index]),
      ),
    );
  }

  Widget _buildPaginatedList(BuildContext context) {
    return Consumer<WholesaleOffersController>(
      builder: (context, controller, _) {
        final List<WholesaleSeller>? sellers = controller.allManufacturers;

        if (sellers == null) return const WholesaleSellerCardShimmerListWidget();

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
    );
  }
}
