import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

enum WholesaleOfferType {
  discounted,
  priceDrop,
  reducedMoq;

  String get uri {
    switch (this) {
      case WholesaleOfferType.discounted:
        return AppConstants.wholesaleDiscountedProductsUri;
      case WholesaleOfferType.priceDrop:
        return AppConstants.wholesalePriceDropProductsUri;
      case WholesaleOfferType.reducedMoq:
        return AppConstants.wholesaleReducedMoqProductsUri;
    }
  }
}
