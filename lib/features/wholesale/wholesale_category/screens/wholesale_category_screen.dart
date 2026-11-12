import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/controllers/wholesale_category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/domain/models/wholesale_category_node_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_category/widgets/wholesale_category_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleCategoryScreen extends StatefulWidget {
  final bool fromWholesalers;
  final int? initialCategoryId;
  final int? initialSubCategoryId;

  final bool isBackButtonExist;

  const WholesaleCategoryScreen({
    super.key,
    this.fromWholesalers = false,
    this.initialCategoryId,
    this.initialSubCategoryId,
    this.isBackButtonExist = false,
  });

  @override
  State<WholesaleCategoryScreen> createState() => _WholesaleCategoryScreenState();
}

class _WholesaleCategoryScreenState extends State<WholesaleCategoryScreen> {
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _subCategoryScrollController = ScrollController();
  bool _isInitialSelectionApplied = false;

  void _applyInitialSelection(WholesaleCategoryController categoryController) {
    if (_isInitialSelectionApplied || categoryController.categoryList.isEmpty) return;
    _isInitialSelectionApplied = true;

    final int? categoryId = widget.initialCategoryId;
    if (categoryId == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final int index = categoryController.categoryList.indexWhere((category) => category.id == categoryId);
      if (index >= 0 && index != categoryController.categorySelectedIndex) {
        categoryController.onChangeSelectedIndex(index);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleCategoryController>(context, listen: false).getCategoryList();
    });
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    _subCategoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('CATEGORY', context), isBackButtonExist: widget.isBackButtonExist),
      body: Consumer<WholesaleCategoryController>(
        builder: (context, categoryController, _) {
          if (categoryController.categoryList.isEmpty) {
            return categoryController.isLoading ? const WholesaleCategoryShimmer() : const SizedBox.shrink();
          }

          _applyInitialSelection(categoryController);

          final selectedCategory = categoryController.categoryList[categoryController.categorySelectedIndex];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeEight),
                  height: double.infinity,
                  color: Theme.of(context).highlightColor,
                  child: PaginatedListView(
                    scrollController: _categoryScrollController,
                    totalSize: categoryController.categoryResponseModel?.totalSize,
                    offset: categoryController.categoryResponseModel?.offset,
                    limit: categoryController.categoryResponseModel?.limit ?? 25,
                    onPaginate: (offset) => categoryController.getCategoryList(offset: offset ?? 1),
                    itemView: Expanded(
                      child: ListView.builder(
                        controller: _categoryScrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: categoryController.categoryList.length,
                        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom),
                        itemBuilder: (context, index) {
                          final category = categoryController.categoryList[index];
                          return InkWell(
                            onTap: () => categoryController.onChangeSelectedIndex(index),
                            child: CategoryItem(
                              title: category.name,
                              icon: category.imageUrl?.path,
                              isSelected: categoryController.categorySelectedIndex == index,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
                    color: Theme.of(context).highlightColor,
                    child: Builder(builder: (context) {
                      final List<WholesaleCategoryNode> subCategories = selectedCategory.children ?? [];

                      if (subCategories.isEmpty && categoryController.isChildLoading(selectedCategory.id)) {
                        return const WholesaleSubCategoryListShimmer(itemCount: 1);
                      }

                      return PaginatedListView(
                        scrollController: _subCategoryScrollController,
                        totalSize: selectedCategory.childTotalSize,
                        offset: selectedCategory.childOffset,
                        limit: selectedCategory.childLimit ?? 25,
                        onPaginate: (offset) => categoryController.getSubCategoryList(
                          category: selectedCategory, offset: offset ?? 1,
                        ),
                        itemView: Expanded(
                          child: ListView.separated(
                            controller: _subCategoryScrollController,
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom),
                            itemCount: subCategories.length + 1,
                            separatorBuilder: (context, index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Divider(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.10), thickness: 1),
                            ),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return _AllProductsTile(
                                  label: subCategories.length > 1 ? getTranslated('all_products', context)! : getTranslated('view_all_products', context)!,
                                  parentCategory: selectedCategory,
                                  fromWholesalers: widget.fromWholesalers,
                                );
                              }
                              final WholesaleCategoryNode subCategory = subCategories[index - 1];
                              return _SubCategoryExpansionTile(
                                key: ValueKey(subCategory.id),
                                subCategory: subCategory,
                                fromWholesalers: widget.fromWholesalers,
                                initiallyExpanded: subCategory.id != null && subCategory.id == widget.initialSubCategoryId,
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AllProductsTile extends StatelessWidget {
  final String label;
  final WholesaleCategoryNode parentCategory;
  final bool fromWholesalers;

  const _AllProductsTile({required this.label, required this.parentCategory, required this.fromWholesalers});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).highlightColor,
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Text(label, style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        onTap: () => RouterHelper.getWholesaleCategoryProductScreenRoute(action: RouteAction.push, parentCategory: parentCategory, initialSelectedId: parentCategory.id, fromWholesalers: fromWholesalers, parentCategoryLevel: 1),
      ),
    );
  }
}

class _SubCategoryExpansionTile extends StatefulWidget {
  final WholesaleCategoryNode subCategory;
  final bool fromWholesalers;
  final bool initiallyExpanded;

  const _SubCategoryExpansionTile({super.key, required this.subCategory, required this.fromWholesalers, this.initiallyExpanded = false});

  @override
  State<_SubCategoryExpansionTile> createState() => _SubCategoryExpansionTileState();
}

class _SubCategoryExpansionTileState extends State<_SubCategoryExpansionTile> {
  WholesaleCategoryNode get subCategory => widget.subCategory;
  bool get fromWholesalers => widget.fromWholesalers;

  @override
  void initState() {
    super.initState();
    if (!widget.initiallyExpanded) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleCategoryController>(context, listen: false).ensureSubSubCategoryLoaded(subCategory);
      Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 300));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleCategoryController>(builder: (context, categoryController, _) {
      return Material(
        color: Theme.of(context).highlightColor,
        child: ExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          visualDensity: const VisualDensity(vertical: -4),
          tilePadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          iconColor: Theme.of(context).textTheme.bodyLarge?.color,
          shape: const Border(),
          onExpansionChanged: (expanded) {
            if (expanded) {
              categoryController.ensureSubSubCategoryLoaded(subCategory);
            }
          },
          title: Text(subCategory.name ?? '', style: textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall), maxLines: 2, overflow: TextOverflow.ellipsis),
          children: _buildChildren(context, categoryController),
        ),
      );
    });
  }

  List<Widget> _buildChildren(BuildContext context, WholesaleCategoryController categoryController) {
    if (!subCategory.isChildrenLoaded) {
      return [const WholesaleSubCategoryListShimmer(itemCount: 1, shrinkWrap: true)];
    }

    final List<WholesaleCategoryNode> leaves = subCategory.children ?? [];

    final List<Widget> children = [
      _LeafTile(
        label: getTranslated('all_products', context)!,
        onTap: () => RouterHelper.getWholesaleCategoryProductScreenRoute(action: RouteAction.push, parentCategory: subCategory, initialSelectedId: subCategory.id, fromWholesalers: fromWholesalers, parentCategoryLevel: 2),
      ),
      for (final leaf in leaves)
        _LeafTile(
          label: leaf.name ?? '',
          onTap: () => RouterHelper.getWholesaleCategoryProductScreenRoute(action: RouteAction.push, parentCategory: subCategory, initialSelectedId: leaf.id, fromWholesalers: fromWholesalers, parentCategoryLevel: 2),
        ),
    ];

    final int total = subCategory.childTotalSize ?? leaves.length;
    if (leaves.length < total) {
      final bool isLoading = categoryController.isChildLoading(subCategory.id);
      children.add(_LeafTile(
        label: isLoading ? '' : '${getTranslated('see_more', context)} (${total - leaves.length})',
        isLoading: isLoading,
        onTap: () => categoryController.getSubSubCategoryList(
          subCategory: subCategory, offset: (subCategory.childOffset ?? 1) + 1,
        ),
      ));
    }

    return children;
  }
}

class _LeafTile extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const _LeafTile({required this.label, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).highlightColor,
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        title: Padding(
          padding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeSmall),
          child: isLoading
              ? Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                )))
              : Text(label,
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.80)),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
        ),
        onTap: isLoading ? null : onTap,
      ),
    );
  }
}
