import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/controllers/wholesale_campaign_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/widgets/wholesale_campaign_banner_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/controllers/wholesale_offers_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/widgets/wholesale_discounted_products_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/widgets/wholesale_price_drop_items_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/widgets/wholesale_reduced_moq_products_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/widgets/wholesale_top_discounted_manufacturers_section.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';

class WholesaleOffersScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const WholesaleOffersScreen({super.key, this.isBackButtonExist = true});

  @override
  State<WholesaleOffersScreen> createState() => _WholesaleOffersScreenState();
}

class _WholesaleOffersScreenState extends State<WholesaleOffersScreen> {
  static const double _sectionSpacing = 24;
  static bool _isShown(List? rows) => rows == null || rows.isNotEmpty;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _refresh();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() {
    final WholesaleOffersController offersController = Provider.of<WholesaleOffersController>(context, listen: false);
    return Future.wait([
      offersController.getDiscountedProducts(),
      offersController.getReducedMoqProducts(),
      offersController.getTopDiscountedManufacturers(),
      offersController.getPriceDropItems(1, true),
      Provider.of<WholesaleCampaignController>(context, listen: false).getCampaignList(reload: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final offersController = context.watch<WholesaleOffersController>();

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('offers', context) ?? 'Offers', isBackButtonExist: widget.isBackButtonExist),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  WholesaleCampaignBannerSection(campaigns: context.watch<WholesaleCampaignController>().campaigns),

                  if (_isShown(offersController.discountedProducts)) ...[
                    const SizedBox(height: _sectionSpacing),
                    WholesaleDiscountedProductsSection(products: offersController.discountedProducts),
                  ],

                  if (_isShown(offersController.topDiscountedManufacturers)) ...[
                    const SizedBox(height: _sectionSpacing),
                    WholesaleTopDiscountedManufacturersSection(sellers: offersController.topDiscountedManufacturers),
                  ],

                  if (_isShown(offersController.reducedMoqProducts)) ...[
                    const SizedBox(height: _sectionSpacing),
                    WholesaleReducedMoqProductsSection(products: offersController.reducedMoqProducts),
                  ],
                  const SizedBox(height: _sectionSpacing),
                ],
              ),
            ),
            if (_isShown(offersController.priceDropItems))
              WholesalePriceDropItemsSection(
                products: offersController.priceDropItems,
                totalSize: offersController.priceDropTotalSize,
                offset: offersController.priceDropOffset,
                scrollController: _scrollController,
                onPaginate: (offset) => offersController.getPriceDropItems(offset ?? 1, false),
              ),
            SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom)),
          ],
        ),
      ),
    );
  }
}
