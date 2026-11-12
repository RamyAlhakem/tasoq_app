import 'package:flutter_sixvalley_ecommerce/common/enums/local_caches_type_enum.dart';
import 'package:flutter_sixvalley_ecommerce/localization/models/language_model.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class AppConstants {
  static const String appName = 'Tasoq';
  static const String slogan = 'E-Commerce Marketplace';
  static const String appVersion = '16.6';

  ///Flutter SDK 3.47.0
  static const bool demo = false;

  static const int imageQuality = 100;
  static const LocalCachesTypeEnum cachesType = LocalCachesTypeEnum.all;

  static const String baseUrl = 'https://tasoq.com';
  // 'https://6valley-lifestyle.6amtech.com';
  //  'https://tasoq.com';

  static const String googleServerClientId = 'client_id here';
  static const String userId = 'userId';

  static const String name = 'name';
  static const String categoriesUri = '/api/v6/categories';
  static const String subCategoriesUri = '/api/v6/categories/sub-categories/';
  static const String subSubCategoriesUri =
      '/api/v6/categories/sub-sub-categories/';
  static const String brandUri = '/api/v6/brands?guest_id=1';

  static const String categoryProductUri = '/api/v6/categories/';
  static const String brandProductUri = '/api/v6/brands/';
  static const String registrationUri = '/api/v6/auth/register';
  static const String loginUri = '/api/v6/auth/login';

  static const String logOut = '/api/v6/auth/logout';
  static const String latestProductUri = '/api/v6/products/latest';
  static const String newArrivalProductUri = '/api/v6/products/new-arrival';
  static const String topProductUri = '/api/v6/products/top-rated';
  static const String bestSellingProductUri = '/api/v6/products/best-selling';
  static const String discountedProductUri = '/api/v6/products/discounted';
  static const String featuredProductUri = '/api/v6/products/featured';
  static const String homeCategoryProductUri = '/api/v6/categories/home';
  static const String productDetailsUri = '/api/v6/products/';
  static const String productReviewUri = '/api/v6/products/';
  static const String searchUri = '/api/v6/products/filter';
  static const String getSuggestionProductName =
      '/api/v6/products/suggestions?name=';
  static const String configUri = '/api/v6/config';
  static const String faqUri = '/api/v6/faq';
  static const String addWishListUri = '/api/v6/customer/wishlist';
  static const String removeWishListUri = '/api/v6/customer/wishlist/';
  static const String updateProfileUri = '/api/v6/customer/profile';
  static const String customerUri = '/api/v6/customer/profile';
  static const String addressListUri = '/api/v6/customer/addresses';
  static const String removeAddressUri = '/api/v6/customer/addresses';
  static const String addAddressUri = '/api/v6/customer/addresses';
  static const String updateAddressUri = '/api/v6/customer/addresses';
  static const String getWishListUri = '/api/v6/customer/wishlist';
  static const String supportTicketUri = '/api/v6/customer/support-tickets';
  static const String getBannerList = '/api/v6/banners';
  static const String relatedProductUri = '/api/v6/products/';
  static const String orderUri = '/api/v6/customer/orders?limit=10&offset=';
  static const String orderDetailsUri = '/api/v6/customer/orders/';
  static const String orderPlaceUri =
      '/api/v6/customer/orders/cash-on-delivery';
  static const String sellerUri = '/api/v6/shops/';
  static const String sellerProductUri = '/api/v6/shops/';
  static const String sellerList = '/api/v6/shops';
  static const String forgetPasswordUri = '/api/v6/auth/password/forgot';
  static const String getSupportTicketUri = '/api/v6/customer/support-tickets';

  static const String supportTicketConversationUri =
      '/api/v6/customer/support-tickets/';
  static const String supportTicketReplyUri =
      '/api/v6/customer/support-tickets/';

  static const String closeSupportTicketUri =
      '/api/v6/customer/support-tickets/';
  static const String submitReviewUri = '/api/v6/customer/reviews';
  static const String updateReviewUri = '/api/v6/customer/reviews/';
  static const String getOrderWiseReview = '/api/v6/customer/orders/';
  static const String deleteOrderWiseReviewImage = '/api/v6/customer/reviews/';
  static const String flashDealUri = '/api/v6/flash-deals';
  static const String featuredDealUri = '/api/v6/featured-deals';
  static const String featuredDealProductUri = '/api/v6/featured-deals/';
  static const String clearanceSaleProductUri =
      '/api/v6/clearance-sale/products';
  static const String flashDealProductUri = '/api/v6/flash-deals/';
  static const String counterUri = '/api/v6/products/';
  static const String socialLinkUri = '/api/v6/products/';
  static const String shippingUri = '/api/v6/products/shipping-methods';
  static const String couponUri = '/api/v6/customer/coupons/discount';
  static const String messageUri = '/api/v6/customer/chats/';
  static const String chatInfoUri = '/api/v6/customer/chats';
  static const String searchChat = '/api/v6/customer/chats';
  static const String sendMessageUri = '/api/v6/customer/chats/';
  static const String seenMessageUri = '/api/v6/customer/chats/';
  static const String tokenUri = '/api/v6/customer/device-token';
  static const String notificationUri = '/api/v6/notifications';
  static const String seenNotificationUri = '/api/v6/notifications/';
  static const String getCartDataUri = '/api/v6/customer/cart';
  static const String addToCartUri = '/api/v6/customer/cart/items';
  static const String updateCartQuantityUri = '/api/v6/customer/cart/items';
  static const String removeFromCartUri = '/api/v6/customer/cart/items';
  static const String getShippingMethod = '/api/v6/customer/shipping-methods';
  static const String chooseShippingMethod =
      '/api/v6/customer/cart/shipping-methods';
  static const String chosenShippingMethod =
      '/api/v6/customer/cart/shipping-methods';
  static const String sendOtpToPhone = '/api/v6/auth/otp/send';
  static const String resendPhoneOtpUri = '/api/v6/auth/otp/send';
  static const String verifyPhoneUri = '/api/v6/auth/otp/verify';
  static const String socialLoginUri = '/api/v6/auth/social/login';
  static const String sendOtpToEmail = '/api/v6/auth/otp/send';
  static const String resendEmailOtpUri = '/api/v6/auth/otp/send';
  static const String verifyEmailUri = '/api/v6/auth/otp/verify';
  static const String resetPasswordUri = '/api/v6/auth/password/reset';
  static const String verifyOtpUri = '/api/v6/auth/otp/verify';
  static const String refundRequestUri = '/api/v6/customer/refunds';
  static const String refundRequestPreReqUri =
      '/api/v6/customer/refunds/eligibility/';
  static const String refundResultUri = '/api/v6/customer/refunds/';
  static const String cancelOrderUri = '/api/v6/customer/orders/';
  static const String getSelectedShippingTypeUri =
      '/api/v6/customer/cart/shipping-type';
  static const String dealOfTheDay = '/api/v6/deal-of-the-day';
  static const String walletTransactionUri =
      '/api/v6/customer/wallet/transactions';
  static const String loyaltyPointUri = '/api/v6/customer/loyalty/transactions';
  static const String loyaltyPointConvert =
      '/api/v6/customer/loyalty/conversions';
  static const String deleteCustomerAccount = '/api/v6/customer/account';
  static const String deliveryRestrictedCountryList =
      '/api/v6/customer/delivery-restrictions/countries';
  static const String deliveryRestrictedZipList =
      '/api/v6/customer/delivery-restrictions/zip-codes';
  static const String getOrderFromOrderId = '/api/v6/customer/orders/';
  static const String offlinePayment =
      '/api/v6/customer/orders/offline-payment';
  static const String walletPayment = '/api/v6/customer/orders/wallet';
  static const String couponListApi = '/api/v6/coupons';
  static const String sellerWiseCouponListApi = '/api/v6/shops/';
  static const String sellerWiseBestSellingProduct = '/api/v6/shops/';
  static const String digitalPayment = '/api/v6/customer/payments/digital';
  static const String offlinePaymentList =
      '/api/v6/customer/offline-payment-methods';
  static const String sellerWiseCategoryList = '/api/v6/categories';
  static const String sellerWiseBrandList = '/api/v6/brands';
  static const String getDigitalAuthorList = '/api/v6/digital-authors';
  static const String getDigitalPublishingHouse =
      '/api/v6/digital-publishing-houses';
  static const String verifyProfileInfo = '/api/v6/auth/identity/verify';
  static const String firebaseAuthTokenStore = '/api/v6/auth/firebase/session';
  static const String productRestockRequest =
      '/api/v6/customer/restock-requests';
  static const String productRestockList = '/api/v6/customer/restock-requests';
  static const String productRestockDelete =
      '/api/v6/customer/restock-requests';
  static const String clearanceShopProductUri = '/api/v6/shops/';
  static const String clearanceShopSearchProductUri = '/api/v6/shops/';
  static const String businessPagesUri = '/api/v6/business-pages';
  static const String getDeliveryManReview = '/api/v6/customer/orders/';
  static const String submitDeliveryManReview = '/api/v6/customer/orders/';
  static const String mergeGuestCart = '/api/v6/customer/cart/merge-guest';
  static const String wholesaleMergeGuestCart =
      '/api/v6/wholesale/customer/cart/merge-guest';
  static const String orderDetailsTrack = '/api/v6/orders/';

  //address
  static const String geocodeUri = '/api/v6/maps/geocode';
  static const String searchLocationUri = '/api/v6/maps/places';
  static const String placeDetailsUri = '/api/v6/maps/places/';

  static const String getGuestIdUri = '/api/v6/get-guest-id';
  static const String mostDemandedProduct = '/api/v6/products/most-demanded';
  static const String shopAgainFromRecentStore =
      '/api/v6/customer/products/shop-again';
  static const String findWhatYouNeed = '/api/v6/categories/find-what-you-need';
  static const String orderTrack = '/api/v6/orders/track';
  static const String addFundToWallet = '/api/v6/customer/wallet/funds';
  static const String reorder = '/api/v6/customer/orders/';
  static const String walletBonusList = '/api/v6/customer/wallet/bonuses';
  static const String moreStore = '/api/v6/shops';
  static const String justForYou = '/api/v6/products/just-for-you';
  static const String mostSearching = '/api/v6/products/most-searched';
  static const String contactUsUri = '/api/v6/contact-us';
  static const String attributeUri = '/api/v6/attributes';
  static const String availableCoupon = '/api/v6/customer/coupons/applicable';
  static const String downloadDigitalProduct = '/api/v6/customer/order-items/';
  static const String otpVResendForDigitalProduct =
      '/api/v6/customer/order-items/';
  static const String otpVerificationForDigitalProduct =
      '/api/v6/customer/order-items/';
  static const String selectCartItemsUri = '/api/v6/customer/cart/selection';
  static const String generateInvoice = '/api/v6/customer/orders/';

  static const String checkEmailUri = '/api/v6/auth/availability/email';
  static const String checkPhoneUri = '/api/v6/auth/availability/phone';
  static const String firebaseAuthVerify = '/api/v6/auth/firebase/verify';
  static const String registerWithOtp = '/api/v6/auth/register/otp';
  static const String verifyTokenUri = '/api/v6/auth/password/verify-otp';
  static const String existingAccountCheck =
      '/api/v6/auth/social/existing-account';
  static const String referralAmountUri =
      '/api/v6/customer/cart/referral-discount';

  static const String duePaymentByCodUri = '/api/v6/customer/orders/';
  static const String duePaymentByDigitalPayment = '/api/v6/customer/orders/';
  static const String duePaymentByWallet = '/api/v6/customer/orders/';
  static const String duePaymentByOfflinePayment = '/api/v6/customer/orders/';

  static const String wholesaleEditOrderDuePaymentUri =
      '/api/dummy/edit-payment';

  // wholesale ai-shopping
  static const String wholesaleAiShoppingSessions =
      '/api/v6/wholesale/ai/assistant/sessions';
  static const String wholesaleAiShoppingUploadImage =
      '/api/v6/wholesale/ai/assistant/upload-image';
  static const String wholesaleAttributeUri = '/api/v6/wholesale/attributes';
  static const String wholesaleBannerUri = '/api/v6/wholesale/banners';
  static const String wholesaleBrandUri = '/api/v6/wholesale/brands';
  static const String wholesaleCategoryUri = '/api/v6/wholesale/categories';
  static const String wholesaleSubCategoryUri =
      '/api/v6/wholesale/categories/sub-categories/';
  static const String wholesaleSubSubCategoryUri =
      '/api/v6/wholesale/categories/sub-sub-categories/';
  static const String wholesaleCategoryProductUri =
      '/api/v6/wholesale/products';
  static const String wholesaleProductSuggestionUri =
      '/api/v6/wholesale/products/suggestions';
  static const String wholesaleTagsUri = '/api/v6/wholesale/tags';
  static const String wholesaleDiscountedProductsUri =
      '/api/v6/wholesale/products/discounted';
  static const String wholesalePriceDropProductsUri =
      '/api/v6/wholesale/products/price-drop';
  static const String wholesaleReducedMoqProductsUri =
      '/api/v6/wholesale/products/reduced-moq';
  static const String wholesaleProductDetailsUri =
      '/api/v6/wholesale/products/';
  static const String wholesaleSellerProductUri = '/api/v6/wholesale/products/';
  static const String wholesaleSimilarProductUri =
      '/api/v6/wholesale/products/';
  static const String wholesalePriceQuoteUri = '/api/v6/wholesale/products/';
  static const String wholesaleCartItemUri =
      '/api/v6/wholesale/customer/cart/items';
  static const String wholesaleCartUri = '/api/v6/wholesale/customer/cart';
  static const String wholesaleCartSelectionUri =
      '/api/v6/wholesale/customer/cart/selection';
  static const String wholesaleCartShippingMethodUri =
      '/api/v6/wholesale/customer/cart/shipping-method';
  static const String wholesaleCartCouponUri =
      '/api/v6/wholesale/customer/cart/coupon';
  static const String wholesaleApplicableCouponUri =
      '/api/v6/wholesale/customer/coupons/applicable';
  static const String wholesaleRestockRequestUri =
      '/api/v6/wholesale/customer/restock-requests';
  static const String wholesaleOrderCashOnDeliveryUri =
      '/api/v6/wholesale/customer/orders/cash-on-delivery';
  static const String wholesaleOrderOfflinePaymentUri =
      '/api/v6/wholesale/customer/orders/offline-payment';
  static const String wholesaleOrderWalletUri =
      '/api/v6/wholesale/customer/orders/wallet';
  static const String wholesaleOrderDigitalPaymentUri =
      '/api/v6/wholesale/customer/orders/digital-payment';
  static const String wholesaleOrderDigitalPaymentByRefUri =
      '/api/v6/wholesale/customer/orders/digital-payment/';
  static const String wholesaleCustomerOrderUri =
      '/api/v6/wholesale/customer/orders';
  static const String wholesaleOrderDetailsUri =
      '/api/v6/wholesale/customer/orders/';
  static const String wholesaleOrderStatusHistoryUri =
      '/api/v6/wholesale/orders/';
  static const String wholesaleOrderTrackUri = '/api/v6/wholesale/orders/track';
  static const String wholesaleOrderTrackingUri = '/api/v6/wholesale/orders/';
  static const String wholesaleOrderInvoiceUri =
      '/api/v6/wholesale/customer/orders/';
  static const String wholesaleOrderCancelUri =
      '/api/v6/wholesale/customer/orders/';
  static const String wholesaleRefundRequestUri =
      '/api/v6/wholesale/customer/refunds';
  static const String wholesaleRefundEligibilityUri =
      '/api/v6/wholesale/customer/refunds/eligibility/';
  static const String wholesaleRefundResultUri =
      '/api/v6/wholesale/customer/refunds/';
  static const String wholesaleOrderProductReviewUri =
      '/api/v6/wholesale/customer/orders/';
  static const String wholesaleReviewUri = '/api/v6/wholesale/customer/reviews';
  static const String wholesaleRecentlyViewedProductUri =
      '/api/v6/wholesale/customer/products/recently-viewed';
  static const String wholesaleShopListUri = '/api/v6/wholesale/shops';
  static const String wholesaleRecentlyViewedShopUri =
      '/api/v6/wholesale/customer/shops/recently-viewed';
  static const String wholesaleCouponUri = '/api/v6/wholesale/coupons';
  static const String wholesaleCampaignUri = '/api/v6/wholesale/campaigns';
  static const String wholesaleCampaignDetailsUri =
      '/api/v6/wholesale/campaigns/';
  static const String wholesaleShopCouponUri = '/api/v6/wholesale/shops/';
  static const String wholesaleShopDetailsUri = '/api/v6/wholesale/shops/';
  static const String wholesaleNotificationUri =
      '/api/v6/wholesale/notifications';
  static const String wholesaleNotificationSeenUri =
      '/api/v6/wholesale/notifications/';
  static const String wholesaleAddWishListUri =
      '/api/v6/wholesale/customer/wishlist';
  static const String wholesaleRemoveWishListUri =
      '/api/v6/wholesale/customer/wishlist/';
  static const String wholesaleGetWishListUri =
      '/api/v6/wholesale/customer/wishlist';

  static const String getCompareList = '/api/v6/customer/compare';
  static const String addToCompareList = '/api/v6/customer/compare';
  static const String removeAllFromCompareList = '/api/v6/customer/compare';
  static const String replaceFromCompareList = '/api/v6/customer/compare/';
  static const String setCurrentLanguage = '/api/v6/customer/language';
  static const String registerWithSocialMedia = '/api/v6/auth/register/social';

  // vat-tax (auction)
  static const String auctionVatTaxSetup = '/api/v6/auction/vat-tax/setup';
  static const String auctionVatTaxListUri = '/api/v6/auction/vat-tax/list';

  static const String auctionAddonPurchaseUrl = '';

  // auction
  static const String createAuctionProductsUri = '/api/v6/auction/products';
  static const String updateAuctionProductsUri = '/api/v6/auction/products';
  static const String creatorAuctionProductDetailsUri =
      '/api/v6/auction/products';
  static const String customerAuctionProductRequestListUri =
      '/api/v6/auction/products/pending-approval';
  static const String customerAuctionProductListUri =
      '/api/v6/auction/products';
  static const String customerMyBidList = '/api/v6/auction/products/my-bids';
  static const String auctionCategoriesUri = '/api/v6/auction/categories';
  static const String auctionCategoryProductListUri =
      '/api/v6/auction/products';
  static const String customerAuctionProductDeleteUri =
      '/api/v6/auction/products/';
  static const String customerAuctionProductCancelUri =
      '/api/v6/auction/products/';
  static const String auctionPopularTags = '/api/v6/auction/tags';
  static const String auctionProductListUri = '/api/v6/auction/products';
  static const String getAuctionSuggestionProductName =
      '/api/v6/auction/products/suggestions';
  static const String participationAuctionProductDetailsUri =
      '/api/v6/auction/products';
  static const String auctionEntryFeeUri = '/api/v6/auction/entry-fees';
  static const String auctionPlaceBidUri = '/api/v6/auction/bids';
  static const String auctionWithdrawBidUri = '/api/v6/auction/bids/withdraw';
  static const String auctionRollbackBidUri = '/api/v6/auction/bids/rollback';
  static const String auctionBidListUri = '/api/v6/auction/products/';
  static const String auctionCreatorBidListUri = '/api/v6/auction/my-auctions/';
  static const String auctionSaveUri = '/api/v6/auction/saved-products';
  static const String auctionClaimUri = '/api/v6/auction/claims';
  static const String auctionSocialShareUri = '/api/v6/auction/products/';
  static const String auctionSaveListUri = '/api/v6/auction/saved-products';
  static const String auctionGenerateInvoice = '/api/v6/auction/products/';
  static const String auctionRecentViewsUri = '/api/v6/auction/recent-views';
  static const String auctionUploadTrackingUri = '/api/v6/auction/products/';
  static const String auctionDeliveryStatusUri = '/api/v6/auction/products/';

  static const String userCreatedAuctionList =
      '/api/v6/auction/products/my-auctions';
  static const String auctionSalesReportUri = '/api/v6/auction/sales-report';
  static const String withdrawMethodListUri =
      '/api/v6/auction/withdraw-methods';
  static const String auctionCommissionPayUri = '/api/v6/auction/products/';
  static const String auctionWithdrawStoreUri = '/api/v6/auction/withdraws';
  static const String auctionWithdrawUpdateUri = '/api/v6/auction/withdraws/';
  static const String auctionRelaunchUri = '/api/v6/auction/products/';
  static const String auctionTransactionHistoryUri =
      '/api/v6/auction/transactions';
  static const String auctionBrandUri = '/api/v6/auction/brands';

  // ai-
  static const String auctionTitleAutoFill =
      '/api/v6/auction/product/title-auto-fill';
  static const String auctionDescriptionAutoFill =
      '/api/v6/auction/product/description-auto-fill';
  static const String auctionGeneralSetupAutoFill =
      '/api/v6/auction/product/general-setup-auto-fill';
  static const String auctionShippingPolicyAutoFill =
      '/api/v6/auction/product/shipping-policy-auto-fill';
  static const String auctionInfoAutoFill =
      '/api/v6/auction/product/auction-info-auto-fill';
  static const String auctionSeoSectionAutoFill =
      '/api/v6/auction/product/seo-section-auto-fill';
  static const String auctionAnalyzeImageAutoFill =
      '/api/v6/auction/product/analyze-image-auto-fill';
  static const String auctionSetupAutoFill =
      '/api/v6/auction/product/setup-auto-fill';
  static const String auctionGenerateTitleSuggestions =
      '/api/v6/auction/product/generate-title-suggestions';
  static const String auctionGenerateLimitCheck =
      '/api/v6/auction/product/generate-limit-check';

  // ai-shopping
  static const String aiShoppingSearch = '/api/v6/ai/assistant/sessions';
  static const String aiShoppingUploadImage =
      '/api/v6/ai/assistant/upload-image';
  static const String aiShoppingSessions = '/api/v6/ai/assistant/sessions';

  static const String auctionDashboardSummaryUri =
      '/api/v6/auction/dashboard-summary';
  static const String auctionNotificationListUri =
      '/api/v6/auction/notifications';
  static const String auctionNotificationSeenUri =
      '/api/v6/auction/notifications/seen';

  // sharePreference
  static const String userLoginToken = 'user_login_token';
  static const String guestId = 'guestId';
  static const String user = 'user';
  static const String userEmail = 'user_email';
  static const String userPassword = 'user_password';
  static const String homeAddress = 'home_address';
  static const String searchProductName = 'search_product';
  static const String auctionSearchProductName = 'auction_search_product_name';
  static const String wholesaleSearchProductName =
      'wholesale_search_product_name';
  static const String officeAddress = 'office_address';
  static const String config = 'config';
  static const String guestMode = 'guest_mode';
  static const String currency = 'currency';
  static const String langKey = 'lang';
  static const String intro = 'intro';
  static const String userLogData = 'user_log_data';
  static const pi = 3.14;
  static const defaultSpread = 0.0872665;
  static const double minFilter = 0;
  static const double maxFilter = 1000000;
  static const String appleLoginEmail = 'apple_login_email';
  static const String guestCartId = 'guest_cart_id';

  // order status
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String processing = 'processing';
  static const String processed = 'processed';
  static const String delivered = 'delivered';
  static const String failed = 'failed';
  static const String returned = 'returned';
  static const String cancelled = 'canceled';
  static const String outForDelivery = 'out_for_delivery';
  static const String maintenanceModeTopic = 'maintenance_mode_start_user_app';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String theme = 'theme';
  static const String topic = 'sixvalley';
  static const String wholesaleTopic = 'sixvalley_wholesale';
  static const String demoTopic = 'demo_reset';
  static const String userAddress = 'user_address';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.ar,
        languageName: 'Arabic',
        countryCode: 'SA',
        languageCode: 'ar'),
    LanguageModel(
        imageUrl: Images.en,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.hi,
        languageName: 'Hindi',
        countryCode: 'IN',
        languageCode: 'hi'),
    LanguageModel(
        imageUrl: Images.bn,
        languageName: 'Bangla',
        countryCode: 'BD',
        languageCode: 'bn'),
    LanguageModel(
        imageUrl: Images.es,
        languageName: 'Spanish',
        countryCode: 'ES',
        languageCode: 'es'),
  ];

  static const reviewList = ['very_bad', 'bad', 'good', 'very_good', 'best'];

  static const double maxSizeOfASingleFile = 10;
  static const double maxLimitOfTotalFileSent = 5;
  static const double maxLimitOfFileSentINConversation = 25;
  static const int fileImageMaxLimit = 2;
  static const int flashDealProductShowLimit = 10;
  static const int flashDealProductShowMaximumLimit = 99;
  static const int auctionProductProductShowLimit = 13;
  static const int auctionProductShowMaximumLimit = 99;

  static const List<String> filterTypeList = ['all', 'debit', 'credit'];

  static const List<String> loyaltyEarnTypeList = [
    'order_place',
    'point_to_wallet',
    'refund_order'
  ];

  static const List<String> walletEarnTypeList = [
    'order_refund',
    'order_place',
    'loyalty_point',
    'add_fund',
    'add_fund_by_admin',
    'due_payment_for_order',
    'return_order_amount_by_admin',
    'return_order_amount_by_seller',
    'auction_entry_fee',
    'auction_claim_payment',
    'auction_commission_payment',
    'added_via_payment_method',
    'earned_by_referral',
    'auction',
  ];

  static const List<String> auctionWalletEarnTypeList = [
    'auction_entry_fee',
    'auction_claim_payment',
    'auction_commission_payment',
    'auction',
  ];

  static List<String> getWalletEarnTypeList({required bool isAuctionEnabled}) =>
      isAuctionEnabled
          ? walletEarnTypeList
          : walletEarnTypeList
              .where((type) => !auctionWalletEarnTypeList.contains(type))
              .toList();

  static const List<String> videoExtensions = [
    'mp4',
    'mkv',
    'avi',
    'mov',
    'wmv',
    'flv',
    'webm',
    'mpeg',
    'mpg',
    'm4v',
    '3gp',
    'ogv'
  ];

  static const List<String> imageExtensions = [
    'png',
    'jpg',
    'jpeg',
    'gif',
    'webp'
  ];

  static const List<String> documentExtensions = [
    'doc',
    'docx',
    'txt',
    'csv',
    'xls',
    'xlsx',
    'rar',
    'tar',
    'targz',
    'zip',
    'pdf'
  ];
}
