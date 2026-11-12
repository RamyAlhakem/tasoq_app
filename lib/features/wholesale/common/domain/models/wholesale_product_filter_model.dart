enum WholesaleSortOption {
  latest,
  priceAsc,
  bestSelling,
  mostReviewed,
  oldest;

  String get value {
    switch (this) {
      case WholesaleSortOption.latest:
        return 'latest';
      case WholesaleSortOption.priceAsc:
        return 'price_asc';
      case WholesaleSortOption.bestSelling:
        return 'best-selling';
      case WholesaleSortOption.mostReviewed:
        return 'most-reviewed';
      case WholesaleSortOption.oldest:
        return 'oldest';
    }
  }

  String get titleKey {
    switch (this) {
      case WholesaleSortOption.latest:
        return 'latest_products';
      case WholesaleSortOption.priceAsc:
        return 'low_to_high_price';
      case WholesaleSortOption.bestSelling:
        return 'best_selling';
      case WholesaleSortOption.mostReviewed:
        return 'most_reviewed';
      case WholesaleSortOption.oldest:
        return 'oldest';
    }
  }

  String get titleFallback {
    switch (this) {
      case WholesaleSortOption.latest:
        return 'Latest Products';
      case WholesaleSortOption.priceAsc:
        return 'Low to high price';
      case WholesaleSortOption.bestSelling:
        return 'Best Selling';
      case WholesaleSortOption.mostReviewed:
        return 'Most Reviewed';
      case WholesaleSortOption.oldest:
        return 'Oldest';
    }
  }
}

class WholesaleProductFilterModel {
  final WholesaleSortOption sort;
  final Set<int> categoryIds;
  final Set<int> subCategoryIds;
  final Set<int> subSubCategoryIds;
  final Set<int> brandIds;
  final double? minPrice;
  final double? maxPrice;
  final bool featuredOnly;
  final int? shopId;

  const WholesaleProductFilterModel({
    this.sort = WholesaleSortOption.latest,
    this.categoryIds = const {},
    this.subCategoryIds = const {},
    this.subSubCategoryIds = const {},
    this.brandIds = const {},
    this.minPrice,
    this.maxPrice,
    this.featuredOnly = false,
    this.shopId,
  });

  bool get isSortApplied => sort != WholesaleSortOption.latest;

  bool get hasCategory => categoryIds.isNotEmpty || subCategoryIds.isNotEmpty || subSubCategoryIds.isNotEmpty;

  int get activeFilterCount {
    int count = 0;
    if (hasCategory) count++;
    if (brandIds.isNotEmpty) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (featuredOnly) count++;
    return count;
  }

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};

    if (isSortApplied) params['sort_by'] = sort.value;
    if (categoryIds.isNotEmpty) params['category_ids[]'] = categoryIds.toList();
    if (subCategoryIds.isNotEmpty) params['sub_category_ids[]'] = subCategoryIds.toList();
    if (subSubCategoryIds.isNotEmpty) params['sub_sub_category_ids[]'] = subSubCategoryIds.toList();
    if (brandIds.isNotEmpty) params['brand_ids[]'] = brandIds.toList();
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    if (featuredOnly) params['featured_status'] = 1;
    if (shopId != null) params['shop_id'] = shopId;

    return params;
  }

  WholesaleProductFilterModel copyWith({
    WholesaleSortOption? sort,
    Set<int>? categoryIds,
    Set<int>? subCategoryIds,
    Set<int>? subSubCategoryIds,
    Set<int>? brandIds,
    double? minPrice,
    double? maxPrice,
    bool? featuredOnly,
    int? shopId,
    bool clearPriceRange = false,
    bool clearShopId = false,
  }) {
    return WholesaleProductFilterModel(
      sort: sort ?? this.sort,
      categoryIds: categoryIds ?? this.categoryIds,
      subCategoryIds: subCategoryIds ?? this.subCategoryIds,
      subSubCategoryIds: subSubCategoryIds ?? this.subSubCategoryIds,
      brandIds: brandIds ?? this.brandIds,
      minPrice: clearPriceRange ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPriceRange ? null : (maxPrice ?? this.maxPrice),
      featuredOnly: featuredOnly ?? this.featuredOnly,
      shopId: clearShopId ? null : (shopId ?? this.shopId),
    );
  }
  WholesaleProductFilterModel cleared() => WholesaleProductFilterModel(sort: sort, shopId: shopId);
}
