import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/controllers/wholesale_brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/models/wholesale_brand_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/controllers/wholesale_category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/domain/models/wholesale_category_node_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/domain/models/wholesale_product_filter_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_option_list_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleProductFilterBottomSheet extends StatefulWidget {
  final WholesaleProductFilterModel currentFilter;
  final WholesalePriceBounds? priceBounds;

  final bool showBrands;

  const WholesaleProductFilterBottomSheet({super.key, required this.currentFilter, this.priceBounds, this.showBrands = true});

  static Future<WholesaleProductFilterModel?> show(
    BuildContext context, {
    required WholesaleProductFilterModel currentFilter,
    WholesalePriceBounds? priceBounds,
    bool showBrands = true,
  }) {
    return showModalBottomSheet<WholesaleProductFilterModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WholesaleProductFilterBottomSheet(currentFilter: currentFilter, priceBounds: priceBounds, showBrands: showBrands),
    );
  }

  @override
  State<WholesaleProductFilterBottomSheet> createState() => _WholesaleProductFilterBottomSheetState();
}

class _WholesaleProductFilterBottomSheetState extends State<WholesaleProductFilterBottomSheet> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  late Set<int> _categoryIds = {...widget.currentFilter.categoryIds};
  late Set<int> _subCategoryIds = {...widget.currentFilter.subCategoryIds};
  late Set<int> _subSubCategoryIds = {...widget.currentFilter.subSubCategoryIds};
  late Set<int> _brandIds = {...widget.currentFilter.brandIds};
  late bool _featuredOnly = widget.currentFilter.featuredOnly;

  final Set<int> _expandedIds = {};

  bool _fetchRequested = false;

  @override
  void initState() {
    super.initState();

    if (widget.currentFilter.minPrice != null) _minController.text = widget.currentFilter.minPrice!.toStringAsFixed(0);
    if (widget.currentFilter.maxPrice != null) _maxController.text = widget.currentFilter.maxPrice!.toStringAsFixed(0);

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchOptionsAfterOpen());
  }

  void _fetchOptionsAfterOpen() {
    if (!mounted) return;

    final Animation<double>? animation = ModalRoute.of(context)?.animation;
    if (animation != null && animation.status != AnimationStatus.completed) {
      void onStatus(AnimationStatus status) {
        if (status != AnimationStatus.completed && status != AnimationStatus.dismissed) return;
        animation.removeStatusListener(onStatus);
        if (status == AnimationStatus.completed) _fetchOptionsAfterOpen();
      }
      animation.addStatusListener(onStatus);
      return;
    }

    setState(() => _fetchRequested = true);
    Provider.of<WholesaleCategoryController>(context, listen: false).getCategoryList();
    if (widget.showBrands) Provider.of<WholesaleBrandController>(context, listen: false).getBrandList();
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  double? get _boundMin => widget.priceBounds?.min;
  double? get _boundMax => widget.priceBounds?.max;

  bool get _hasUsableBounds => _boundMin != null && _boundMax != null && _boundMax! > _boundMin!;

  void _apply() {
    double? min = double.tryParse(_minController.text.trim());
    double? max = double.tryParse(_maxController.text.trim());

    if (min != null && max != null && min > max) {
      final double swap = min;
      min = max;
      max = swap;
    }

    if (_hasUsableBounds) {
      if (min != null) min = min.clamp(_boundMin!, _boundMax!);
      if (max != null) max = max.clamp(_boundMin!, _boundMax!);
    }

    if (min != null && max != null && min > max) {
      showCustomSnackBarWidget(
        getTranslated('min_price_should_not_grater', context), context, snackBarType: SnackBarType.error,
      );
      return;
    }

    Navigator.pop(
      context,
      widget.currentFilter.copyWith(
        categoryIds: _categoryIds,
        subCategoryIds: _subCategoryIds,
        subSubCategoryIds: _subSubCategoryIds,
        brandIds: _brandIds,
        featuredOnly: _featuredOnly,
        minPrice: min,
        maxPrice: max,
        clearPriceRange: min == null && max == null,
      ),
    );
  }

  void _reset() {
    setState(() {
      _categoryIds = {};
      _subCategoryIds = {};
      _subSubCategoryIds = {};
      _brandIds = {};
      _featuredOnly = false;
      _minController.clear();
      _maxController.clear();
    });

    if (widget.currentFilter.activeFilterCount == 0) {
      Navigator.pop(context);
      return;
    }
    Navigator.pop(context, widget.currentFilter.cleared());
  }

  Set<int> _selectionOf(int level) => switch (level) {
        1 => _categoryIds,
        2 => _subCategoryIds,
        _ => _subSubCategoryIds,
      };

  void _toggleCategory(int id, int level, bool checked) {
    setState(() {
      if (!checked) {
        _selectionOf(level).remove(id);
        return;
      }

      for (final int other in const [1, 2, 3]) {
        if (other != level) _selectionOf(other).clear();
      }
      _selectionOf(level).add(id);
    });
  }

  void _toggleExpanded(WholesaleCategoryNode node, int level) {
    final int? id = node.id;
    if (id == null) return;

    if (!_expandedIds.remove(id)) {
      _expandedIds.add(id);
      final WholesaleCategoryController controller = Provider.of<WholesaleCategoryController>(context, listen: false);
      level == 1 ? controller.ensureSubCategoryLoaded(node) : controller.ensureSubSubCategoryLoaded(node);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
        ),
        child: Column(children: [
          _buildHandle(context),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
              children: [
                _buildSection(context, 'price_range', 'Price Range', _buildPriceRange(context)),
                _buildSection(context, 'category', 'Category', _buildCategory(context)),
                if (widget.showBrands) _buildSection(context, 'brand', 'Brand', _buildBrands(context)),
                _buildSection(context, 'featured_products', 'Featured Products', _buildFeatured(context)),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ],
            ),
          ),
          _buildFooter(context),
        ]),
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Column(children: [
        Container(
          width: 35,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Text(
          getTranslated('filter', context) ?? 'Filter',
          style: titilliumBold.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null,
          ),
        ),
      ]),
    );
  }

  Widget _buildSection(BuildContext context, String titleKey, String fallback, Widget child) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              getTranslated(titleKey, context) ?? fallback,
              style: titilliumSemiBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            child,
          ]),
        ),
      ),
    );
  }

  Widget _buildPriceRange(BuildContext context) {
    final double min = double.tryParse(_minController.text.trim()) ?? (_boundMin ?? 0);
    final double max = double.tryParse(_maxController.text.trim()) ?? (_boundMax ?? 0);

    return Column(children: [
      Row(children: [
        Expanded(child: _buildPriceField(context, _minController, 'min_price', 'Min')),
        const SizedBox(width: Dimensions.paddingSizeDefault),
        Expanded(child: _buildPriceField(context, _maxController, 'max_price', 'Max')),
      ]),
      if (_hasUsableBounds)
        RangeSlider(
          min: _boundMin!,
          max: _boundMax!,
          divisions: (_boundMax! - _boundMin!).round().clamp(1, 1000),
          values: RangeValues(
            min.clamp(_boundMin!, _boundMax!),
            max.clamp(_boundMin!, _boundMax!) < min.clamp(_boundMin!, _boundMax!)
                ? _boundMax!
                : max.clamp(_boundMin!, _boundMax!),
          ),
          labels: RangeLabels(min.toStringAsFixed(0), max.toStringAsFixed(0)),
          activeColor: Theme.of(context).primaryColor,
          onChanged: (values) => setState(() {
            _minController.text = values.start.toStringAsFixed(0);
            _maxController.text = values.end.toStringAsFixed(0);
          }),
        ),
    ]);
  }

  Widget _buildPriceField(BuildContext context, TextEditingController controller, String titleKey, String fallback) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: textRegular.copyWith(
        fontSize: Dimensions.fontSizeDefault,
        color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null,
      ),
      decoration: InputDecoration(
        isDense: true,
        labelText: getTranslated(titleKey, context) ?? fallback,
        labelStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeSmall,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        enabledBorder: isDark ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: .3)),
        ) : null,
        focusedBorder: isDark ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ) : null,
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildCategory(BuildContext context) {
    return Consumer<WholesaleCategoryController>(
      builder: (context, categoryController, _) {
        final List<WholesaleCategoryNode> categories = categoryController.categoryList;

        if (categories.isEmpty && (!_fetchRequested || categoryController.isLoading)) {
          return const WholesaleOptionListShimmerWidget();
        }

        if (categories.isEmpty) {
          return Text(
            getTranslated('no_data_found', context) ?? 'No data found',
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
          );
        }

        return Column(
          children: categories.map((category) => _buildCategoryTile(context, category, 1, categoryController)).toList(),
        );
      },
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    WholesaleCategoryNode node,
    int level,
    WholesaleCategoryController categoryController,
  ) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final bool isExpanded = node.id != null && _expandedIds.contains(node.id);
    final bool isSelected = node.id != null && _selectionOf(level).contains(node.id);
    final bool isChildLoading = categoryController.isChildLoading(node.id);
    final List<WholesaleCategoryNode> children = node.children ?? const [];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsetsDirectional.only(start: (level - 1) * Dimensions.paddingSizeDefault),
        child: Row(children: [
          Expanded(
            child: CheckboxListTile(
              value: isSelected,
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Theme.of(context).primaryColor,
              title: Text(node.name ?? '', style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null,
              )),
              onChanged: (checked) {
                if (node.id == null) return;
                _toggleCategory(node.id!, level, checked == true);
              },
            ),
          ),
          if (level < 3)
            isChildLoading
                ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : InkWell(
                    onTap: () => _toggleExpanded(node, level),
                    child: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 20,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
        ]),
      ),
      if (isExpanded && !isChildLoading)
        children.isEmpty
            ? Padding(
                padding: EdgeInsetsDirectional.only(
                  start: level * Dimensions.paddingSizeDefault,
                  bottom: Dimensions.paddingSizeExtraSmall,
                ),
                child: Text(
                  getTranslated('no_data_found', context) ?? 'No data found',
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),
              )
            : Column(
                children: children
                    .map((child) => _buildCategoryTile(context, child, level + 1, categoryController))
                    .toList(),
              ),
    ]);
  }

  Widget _buildBrands(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return Consumer<WholesaleBrandController>(
      builder: (context, brandController, _) {
        final List<WholesaleBrand>? brands = brandController.brands;

        if (brands == null) {
          return const WholesaleOptionListShimmerWidget();
        }

        if (brands.isEmpty) {
          return Text(
            getTranslated('no_data_found', context) ?? 'No data found',
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
          );
        }

        return Column(
          children: brands.map((brand) {
            final bool isSelected = brand.id != null && _brandIds.contains(brand.id);
            return CheckboxListTile(
              value: isSelected,
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Theme.of(context).primaryColor,
              title: Text(brand.name ?? '', style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null,
              )),
              onChanged: (checked) {
                if (brand.id == null) return;
                setState(() => checked == true ? _brandIds.add(brand.id!) : _brandIds.remove(brand.id));
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFeatured(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return CheckboxListTile(
      value: _featuredOnly,
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Theme.of(context).primaryColor,
      title: Text(
        getTranslated('featured_products', context) ?? 'Featured Products',
        style: textRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null,
        ),
      ),
      onChanged: (checked) => setState(() => _featuredOnly = checked ?? false),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return Container(
      padding: EdgeInsets.fromLTRB(
        Dimensions.homePagePadding,
        Dimensions.paddingSizeSmall,
        Dimensions.homePagePadding,
        MediaQuery.of(context).padding.bottom + Dimensions.paddingSizeDefault,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.15))),
      ),
      child: Row(children: [
        SizedBox(
          width: 120,
          child: CustomButton(
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: .5),
            textColor: isDark ? Colors.white : Theme.of(context).primaryColor,
            radius: 8,
            buttonText: getTranslated('clear', context),
            onTap: _reset,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(
          child: CustomButton(
            radius: 8,
            buttonText: getTranslated('apply', context),
            onTap: _apply,
          ),
        ),
      ]),
    );
  }
}
