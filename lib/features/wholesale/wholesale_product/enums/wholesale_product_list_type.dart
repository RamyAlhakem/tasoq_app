import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/wholesale_home_enum.dart';

enum WholesaleProductListType {
  recentlyViewed,
  sellerProducts,
  similarProducts,
  mostDemanded,
  bestPrices,
}

extension WholesaleProductListTypeExtension on WholesaleProductListType {
  String get titleKey {
    switch (this) {
      case WholesaleProductListType.recentlyViewed:
        return 'recently_viewed';
      case WholesaleProductListType.sellerProducts:
        return 'more_from_the_seller';
      case WholesaleProductListType.similarProducts:
        return 'related_products';
      case WholesaleProductListType.mostDemanded:
        return 'most_in_demand_items';
      case WholesaleProductListType.bestPrices:
        return 'best_wholesale_prices';
    }
  }

  String get titleFallback {
    switch (this) {
      case WholesaleProductListType.recentlyViewed:
        return 'Recently Viewed';
      case WholesaleProductListType.sellerProducts:
        return 'More From the Whole Seller';
      case WholesaleProductListType.similarProducts:
        return 'Related Products';
      case WholesaleProductListType.mostDemanded:
        return 'Most In-Demand Items';
      case WholesaleProductListType.bestPrices:
        return 'Best Wholesale Prices';
    }
  }

  WholesaleProductRailEnum? get rail {
    switch (this) {
      case WholesaleProductListType.mostDemanded:
        return WholesaleProductRailEnum.mostDemanded;
      case WholesaleProductListType.bestPrices:
        return WholesaleProductRailEnum.bestPrice;
      default:
        return null;
    }
  }

  bool get requiresSlug => this == WholesaleProductListType.sellerProducts || this == WholesaleProductListType.similarProducts;
}
