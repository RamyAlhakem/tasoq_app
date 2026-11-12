import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/controllers/wholesale_home_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleHomeCategoryFilterSection extends StatefulWidget {
  final List<WholesaleCategoryTab>? tabs;
  final WholesaleHomeTabScope scope;

  const WholesaleHomeCategoryFilterSection({super.key, required this.tabs, required this.scope});

  @override
  State<WholesaleHomeCategoryFilterSection> createState() => _WholesaleHomeCategoryFilterSectionState();
}

class _WholesaleHomeCategoryFilterSectionState extends State<WholesaleHomeCategoryFilterSection> {
  final Map<int?, GlobalKey> _tabKeys = {};
  final ScrollController _stripController = ScrollController();
  int? _lastSelectedId;

  GlobalKey _keyFor(int? id) => _tabKeys.putIfAbsent(id, () => GlobalKey());

  @override
  void dispose() {
    _stripController.dispose();
    super.dispose();
  }

  void _revealSelectedTab(int? selectedId) {
    if (selectedId == _lastSelectedId) return;
    _lastSelectedId = selectedId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderObject? tab = _tabKeys[selectedId]?.currentContext?.findRenderObject();
      if (!mounted || tab == null || !_stripController.hasClients) return;

      final RenderAbstractViewport viewport = RenderAbstractViewport.of(tab);
      final ScrollPosition position = _stripController.position;
      final double target = viewport.getOffsetToReveal(tab, 0.5).offset.clamp(position.minScrollExtent, position.maxScrollExtent);
      _stripController.animateTo(target, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<WholesaleCategoryTab>? tabs = widget.tabs;
    if (tabs == null) return const _CategoryFilterShimmer();

    final WholesaleHomeTabScope scope = widget.scope;
    final int? selectedId = context.select<WholesaleHomeController, int?>((controller) => controller.categoryIdFor(scope));
    _revealSelectedTab(selectedId);

    WholesaleCategoryTab? selectedTab;
    for (final WholesaleCategoryTab tab in tabs) {
      if (selectedId != null && tab.id == selectedId) selectedTab = tab;
    }
    final List<WholesaleCategory> subCategories = selectedTab?.categories ?? const [];

    void select(int? categoryId) => Provider.of<WholesaleHomeController>(context, listen: false).filterByCategory(scope, categoryId);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      color: scope == WholesaleHomeTabScope.manufacturers ? Theme.of(context).cardColor : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            controller: _stripController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.only(start: Dimensions.homePagePadding, end: Dimensions.paddingSizeTwelve),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(height: 2, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
                  ),
                ),
                Row(
                  children: [
                    _CategoryFilterTab(
                      key: _keyFor(null),
                      label: getTranslated('all', context) ?? 'All',
                      isSelected: selectedId == null,
                      onTap: () => select(null),
                    ),
                    for (final WholesaleCategoryTab tab in tabs)
                      _CategoryFilterTab(
                        key: _keyFor(tab.id),
                        label: tab.name,
                        isSelected: tab.id != null && tab.id == selectedId,
                        onTap: () => select(tab.id),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (selectedId == null && scope == WholesaleHomeTabScope.manufacturers)
            Container(height: 14, color: Theme.of(context).cardColor, child : Row(children: [])),
          if (scope == WholesaleHomeTabScope.manufacturers && selectedId != null)
            const _CategoryManufacturerRow(),
          if (scope == WholesaleHomeTabScope.products && selectedTab != null && subCategories.isNotEmpty) ...[
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: Dimensions.homePagePadding),
              color: Theme.of(context).cardColor,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsetsDirectional.only(start: Dimensions.homePagePadding, end: Dimensions.paddingSizeTwelve),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int index = 0; index < subCategories.length; index++) ...[
                      if (index != 0) const SizedBox(width: Dimensions.paddingSizeSmall),
                      _SubCategoryItem(
                        subCategory: subCategories[index],
                        onTap: () => RouterHelper.getWholesaleCategoryScreenRoute(
                          action: RouteAction.push,
                          initialCategoryId: selectedTab!.id,
                          initialSubCategoryId: subCategories[index].id,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryFilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryFilterTab({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsetsDirectional.only(end: 20),
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: isSelected
              ? titilliumSemiBold.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor)
              : titilliumRegular.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: Theme.of(context).textTheme.titleMedium?.color),
        ),
      ),
    );
  }
}

class _SubCategoryItem extends StatelessWidget {
  final WholesaleCategory subCategory;
  final VoidCallback onTap;

  const _SubCategoryItem({required this.subCategory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              foregroundDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.15) : Theme.of(context).primaryColor.withValues(alpha: 0.15), width: 1),
              ),
              child: ClipOval(child: CustomImageWidget(image: subCategory.imageUrl?.path ?? '', fit: BoxFit.cover)),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
            Text(
              subCategory.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryManufacturerRow extends StatelessWidget {
  const _CategoryManufacturerRow();

  @override
  Widget build(BuildContext context) {
    final List<WholesaleSeller>? sellers = context.select<WholesaleHomeController, List<WholesaleSeller>?>(
      (controller) => controller.sellerRailFor(WholesaleHomeTabScope.manufacturers, WholesaleSellerRailEnum.all),
    );
    if (sellers != null && sellers.isEmpty) return  Container(height: 14, color: Theme.of(context).cardColor, child : Row(children: []));

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.homePagePadding),
        color: Theme.of(context).cardColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: sellers == null ? const NeverScrollableScrollPhysics() : null,
          padding: const EdgeInsetsDirectional.only(start: Dimensions.homePagePadding, end: Dimensions.paddingSizeTwelve),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int index = 0; index < (sellers?.length ?? 5); index++) ...[
                if (index != 0) const SizedBox(width: Dimensions.paddingSizeSmall),
                sellers == null ? const _ManufacturerItemShimmer() : _ManufacturerItem(seller: sellers[index]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ManufacturerItem extends StatelessWidget {
  final WholesaleSeller seller;

  const _ManufacturerItem({required this.seller});

  static const double _imageSize = 60;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return InkWell(
      onTap: seller.slug == null ? null : () => RouterHelper.getWholesaleShopRoute(
        action: RouteAction.push,
        slug: seller.slug!,
        shopId: seller.id,
        shopName: seller.shopName,
      ),
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: SizedBox(
        width: 76,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _imageSize,
              height: _imageSize,
              foregroundDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.15) : Theme.of(context).primaryColor.withValues(alpha: 0.15), width: 1),
              ),
              child: ClipOval(child: CustomImageWidget(image: seller.shopLogoUrl?.path ?? '', fit: BoxFit.cover)),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
            Text(
              seller.shopName ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManufacturerItemShimmer extends StatelessWidget {
  const _ManufacturerItemShimmer();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 76,
      child: Column(
        children: [
          WholesaleShimmerBoxWidget(width: _ManufacturerItem._imageSize, height: _ManufacturerItem._imageSize, borderRadius: _ManufacturerItem._imageSize / 2),
          SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
          WholesaleShimmerBoxWidget(width: 50, height: 10),
        ],
      ),
    );
  }
}

class _CategoryFilterShimmer extends StatelessWidget {
  const _CategoryFilterShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall, start: Dimensions.homePagePadding),
      color: Colors.transparent,
      child: const Row(
        children: [
          WholesaleShimmerBoxWidget(width: 40, height: 16),
          SizedBox(width: Dimensions.paddingSizeLarge),
          WholesaleShimmerBoxWidget(width: 70, height: 16),
          SizedBox(width: Dimensions.paddingSizeLarge),
          WholesaleShimmerBoxWidget(width: 70, height: 16),
        ],
      ),
    );
  }
}
