enum WholesaleProductRailEnum {
  mostDemanded,
  bestPrice;

  String get sortBy {
    switch (this) {
      case WholesaleProductRailEnum.mostDemanded:
        return 'best-selling';
      case WholesaleProductRailEnum.bestPrice:
        return 'price_asc';
    }
  }
}

enum WholesaleSellerRailEnum {
  topWholesaler,
  verifiedSeller,
  all,
  recommended;

  String get type {
    switch (this) {
      case WholesaleSellerRailEnum.topWholesaler:
        return 'top-wholesaler';
      case WholesaleSellerRailEnum.verifiedSeller:
        return 'verified-seller';
      case WholesaleSellerRailEnum.all:
        return 'all';
      case WholesaleSellerRailEnum.recommended:
        return 'recommended';
    }
  }
}

enum WholesaleHomeTabScope {
  products(
    productRails: [WholesaleProductRailEnum.mostDemanded, WholesaleProductRailEnum.bestPrice],
    sellerRails: [WholesaleSellerRailEnum.topWholesaler],
  ),
  manufacturers(
    productRails: [WholesaleProductRailEnum.mostDemanded],
    sellerRails: [
      WholesaleSellerRailEnum.topWholesaler,
      WholesaleSellerRailEnum.verifiedSeller,
      WholesaleSellerRailEnum.all,
      WholesaleSellerRailEnum.recommended,
    ],
  );

  const WholesaleHomeTabScope({required this.productRails, required this.sellerRails});

  final List<WholesaleProductRailEnum> productRails;
  final List<WholesaleSellerRailEnum> sellerRails;
}
