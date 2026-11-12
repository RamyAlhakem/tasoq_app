import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/di_container.dart' as di;
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/controllers/wholesale_campaign_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/domain/models/wholesale_campaign_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/widgets/wholesale_campaign_banner_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/widgets/wholesale_campaign_info_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/widgets/wholesale_campaign_products_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/widgets/wholesale_campaign_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleCampaignScreen extends StatelessWidget {
  final String? slug;

  const WholesaleCampaignScreen({super.key, this.slug});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WholesaleCampaignController>(
      create: (_) => di.sl<WholesaleCampaignController>(),
      child: _WholesaleCampaignView(slug: slug),
    );
  }
}

class _WholesaleCampaignView extends StatefulWidget {
  final String? slug;

  const _WholesaleCampaignView({this.slug});

  @override
  State<_WholesaleCampaignView> createState() => _WholesaleCampaignViewState();
}

class _WholesaleCampaignViewState extends State<_WholesaleCampaignView> {
  final ScrollController _scrollController = ScrollController();

  static const double _paginationTriggerOffset = 200;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<WholesaleCampaignController>().bind(slug: widget.slug);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - _paginationTriggerOffset) {
      context.read<WholesaleCampaignController>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WholesaleCampaignController controller = context.watch<WholesaleCampaignController>();
    final WholesaleCampaign? campaign = controller.campaign;
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('campaign_details', context) ?? 'Campaign details'),
      body: RefreshIndicator(
        onRefresh: controller.retry,
        child: _body(context, controller, campaign, isDark),
      ),
    );
  }

  Widget _body(BuildContext context, WholesaleCampaignController controller, WholesaleCampaign? campaign, bool isDark) {
    if (controller.isCampaignLoading && campaign == null) {
      return const WholesaleCampaignShimmer();
    }

    if (controller.campaignNotFound || (campaign == null && controller.campaignErrorMessage != null)) {
      return ListView(
        controller: _scrollController,
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
          NoInternetOrDataScreenWidget(
            isNoInternet: false,
            message: controller.campaignNotFound
                ? (getTranslated('no_campaign_found', context) ?? 'No campaign found') : (getTranslated(controller.campaignErrorMessage, context) ?? controller.campaignErrorMessage!),
            icon: Images.noOffer,
          ),
        ],
      );
    }

    if (campaign == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Container(
            decoration: BoxDecoration(
              boxShadow: isDark ? null : [BoxShadow(color: Colors.grey.withValues(alpha:.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],
              color: Theme.of(context).cardColor,
            ),

            child: Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                WholesaleCampaignBannerWidget(image: campaign.imageFullUrl),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                WholesaleCampaignInfoCardWidget(
                  title: campaign.title,
                  description: campaign.description,
                  discountRange: campaign.discountRangeLabel,
                  manufacturerCount: campaign.manufacturerCountLabel,
                  productCount: campaign.productCountLabel,
                  validTill: campaign.endDate,
                ),
                const SizedBox(height: Dimensions.homePagePadding),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Container(
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                WholesaleCampaignProductsSection(
                  products: controller.products,
                  isLoadingMore: controller.isProductLoading && (controller.products?.isNotEmpty ?? false),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
