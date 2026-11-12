import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final bool isBacButtonExist;

  const CategoryScreen({super.key, this.isBacButtonExist = true});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _subCategoryScrollController = ScrollController();
  bool _subCategoryHasOverflow = false;

  static const double _bottomNavHeight = 60;

  @override
  void dispose() {
    _categoryScrollController.dispose();
    _subCategoryScrollController.dispose();
    super.dispose();
  }

  void _updateSubCategoryOverflow(double bottomSpace) {
    if (!mounted || !_subCategoryScrollController.hasClients) return;
    final double spacerNow = _subCategoryHasOverflow ? bottomSpace : 0;
    final bool overflow = (_subCategoryScrollController.position.maxScrollExtent - spacerNow) > 0.5;
    if (overflow != _subCategoryHasOverflow) {
      setState(() => _subCategoryHasOverflow = overflow);
    }
  }

  @override
  void initState() {
    super.initState();

    final categoryController = Provider.of<CategoryController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (categoryController.categoryList.isNotEmpty) {
        Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(
          isBrand: false,
          id: categoryController.categoryList.first.id,
          offset: 1,
          isUpdate: false,
        );
        categoryController.onChangeSelectedIndex(0, isUpdate: false);
        categoryController.ensureSubCategoryLoaded(categoryController.categoryList.first);
      } else {
        categoryController.getCategoryList(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('CATEGORY', context), isBackButtonExist: widget.isBacButtonExist),
      body: Consumer<CategoryController>(
        builder: (context, categoryProvider, child) {
          final double bottomSpace = _bottomNavHeight + MediaQuery.of(context).padding.bottom;

          WidgetsBinding.instance.addPostFrameCallback((_) => _updateSubCategoryOverflow(bottomSpace));

          return categoryProvider.categoryList.isNotEmpty ?
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Expanded(flex: 3, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeEight),
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    offset: const Offset(1, -1),
                    spreadRadius: 0,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: PaginatedListView(
                scrollController: _categoryScrollController,
                totalSize: categoryProvider.categoryResponseModel?.totalSize,
                offset: categoryProvider.categoryResponseModel?.offset,
                limit: categoryProvider.categoryResponseModel?.limit ?? 25,
                onPaginate: (offset) => categoryProvider.getCategoryList(false, offset: offset ?? 1),
                itemView: Expanded(
                  child: ListView.builder(
                    controller: _categoryScrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: categoryProvider.categoryList.length + 1,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      if (index == categoryProvider.categoryList.length) {
                        return SizedBox(height: MediaQuery.of(context).padding.bottom);
                      }
                      CategoryModel category = categoryProvider.categoryList[index];
                      return InkWell(
                        onTap: () {
                          categoryProvider.onChangeSelectedIndex(index);
                          Provider.of<ProductController>(context, listen: false).initBrandOrCategoryProductList(
                            isBrand: false,
                            id: categoryProvider.categoryList[index].id,
                            offset: 1,
                          );
                        },
                        child: CategoryItem(
                          title: category.name,
                          icon: category.imageFullUrl?.path,
                          isSelected: categoryProvider.categorySelectedIndex == index,
                        ),
                      );
                    },
                  ),
                ),
              ),
            )),

            Expanded(flex: 7, child: Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      offset: const Offset(0, 1),
                      spreadRadius: 0,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Builder(builder: (context) {
                  final CategoryModel selectedCategory = categoryProvider.categoryList[categoryProvider.categorySelectedIndex!];
                  final List<SubCategory> subCategories = selectedCategory.subCategories ?? [];

                  if (subCategories.isEmpty && categoryProvider.isChildLoading(selectedCategory.id)) {
                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                  }

                  return NotificationListener<ScrollMetricsNotification>(
                  onNotification: (_) {
                    WidgetsBinding.instance.addPostFrameCallback((_) => _updateSubCategoryOverflow(bottomSpace));
                    return false;
                  },
                  child: PaginatedListView(
                    scrollController: _subCategoryScrollController,
                    totalSize: selectedCategory.subCategoryTotalSize,
                    offset: selectedCategory.subCategoryOffset,
                    limit: selectedCategory.subCategoryLimit ?? 25,
                    onPaginate: (offset) => categoryProvider.getSubCategoryList(category: selectedCategory, offset: offset ?? 1),
                    itemView: Expanded(
                      child: CustomScrollView(
                  controller: _subCategoryScrollController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final subCategoryCount = subCategories.length;

                          // Odd i => separator (was separatorBuilder(context, i ~/ 2)); even i => item (was itemBuilder(context, i ~/ 2)).
                          if (i.isOdd) {
                            final sepIndex = i ~/ 2;
                            if (sepIndex == subCategoryCount) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Divider(
                                color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.10),
                                thickness: 1,
                              ),
                            );
                          }

                          final index = i ~/ 2;
                          if (index == subCategoryCount + 1) {
                            return SizedBox(height: _subCategoryHasOverflow ? bottomSpace : 0);
                          }
                          late SubCategory subCategory;
                          if(index != 0) {
                            subCategory = subCategories[index-1];
                          }
                          if(index == 0) {
                            return Material(
                              color: Theme.of(context).highlightColor,
                              child: ListTile(
                                visualDensity: const VisualDensity(vertical: -4),
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                  child: Text(
                                      subCategoryCount > 1 ?
                                      getTranslated('all_products', context)! : getTranslated('view_all_products', context)!,
                                      style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      maxLines: 2, overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                onTap: () {
                                  RouterHelper.getBrandCategoryRoute(
                                    isBrand: false,
                                    id: selectedCategory.id,
                                    name: selectedCategory.name,
                                    categoryModel: selectedCategory,
                                    isAllProduct: true,
                                  );
                                },
                              ),
                            );
                          } else {
                            return Material(
                                color: Theme.of(context).highlightColor,
                                child: ExpansionTile(
                                    visualDensity: const VisualDensity(vertical: -4),
                                    tilePadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    iconColor: Theme.of(context).textTheme.bodyLarge?.color,
                                    shape: const Border(),
                                    key: Key('${categoryProvider.categorySelectedIndex}$index'),
                                    onExpansionChanged: (expanded) {
                                      if(expanded) {
                                        categoryProvider.ensureSubSubCategoryLoaded(subCategory);
                                      }
                                    },
                                    title: Text(subCategory.name ?? '', style: textBold.copyWith(
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                      fontSize: Dimensions.fontSizeSmall,
                                    ), maxLines: 2, overflow: TextOverflow.ellipsis),
                                    children: _getSubSubCategories(context, subCategory, categoryProvider)
                                ),
                            );
                          }
                        },
                        childCount: 2 * (subCategories.length + 2) - 1,
                      ),
                    ),
                  ],
                ),
                    ),
                  ),
                );
                }),
              ),
            )),

          ]) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }

  List<Widget> _getSubSubCategories(BuildContext context, SubCategory subCategory, CategoryController categoryProvider) {

    if (subCategory.subSubCategories == null) {
      return [Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ))),
      )];
    }

    List<Widget> subSubCategories = [];
    subSubCategories.add(Material(
      color: Theme.of(context).highlightColor,
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        title: Row(children: [
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Flexible(child: Text(getTranslated('all_products', context)!, style: textRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.80)
          ), maxLines: 2, overflow: TextOverflow.ellipsis)),
        ]),
        onTap: () {
          RouterHelper.getBrandCategoryRoute(
            action: RouteAction.push,
            isBrand: false,
            id: subCategory.id,
            name: subCategory.name,
            subCategory: subCategory,
            isAllProduct: true,
          );
        },
      ),
    ));
    for(int index=0; index < subCategory.subSubCategories!.length; index++) {
      subSubCategories.add(Material(
        color: Theme.of(context).highlightColor,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: -4),
          title: Row(children: [

            const SizedBox(width: Dimensions.paddingSizeSmall),

            Flexible(
              child: Text(subCategory.subSubCategories![index].name!, style: textRegular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.80),
                fontSize: Dimensions.fontSizeSmall,
              ), maxLines: 2, overflow: TextOverflow.ellipsis),
            ),

          ]),
          onTap: () {
            RouterHelper.getBrandCategoryRoute(
              action: RouteAction.push,
              isBrand: false,
              id: subCategory.subSubCategories![index].id,
              name: subCategory.name,
              subCategory: subCategory,
            );
          },
        ),
      ));
    }

    final int loadedCount = subCategory.subSubCategories!.length;
    final int totalCount = subCategory.subSubCategoryTotalSize ?? loadedCount;
    if (loadedCount < totalCount) {
      final bool isLoading = categoryProvider.isChildLoading(subCategory.id);
      subSubCategories.add(Material(
        color: Theme.of(context).highlightColor,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: -4),
          title: isLoading ? Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ))) : Text(
            '${getTranslated('see_more', context)} (${totalCount - loadedCount})',
            style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          ),
          onTap: isLoading ? null : () => categoryProvider.getSubSubCategoryList(
            subCategory: subCategory,
            offset: (subCategory.subSubCategoryOffset ?? 1) + 1,
          ),
        ),
      ));
    }

    return subSubCategories;
  }
}

class CategoryItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool isSelected;
  const CategoryItem({super.key, required this.title, required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Container(
          height: boxConstraints.maxWidth,
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).hintColor.withValues(alpha: 0.07),
          ),
          child: Center(child: Column(children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CustomImageWidget(fit: BoxFit.cover, image: '$icon', height: 40, width: 40),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              child: Text(title!, maxLines: 2, style: textBold.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                height: 1.0,
                color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
              ), overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
            ),
          ])),
        );
      }
    );
  }
}
