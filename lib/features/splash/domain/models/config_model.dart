import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/enums/vacation_duration_type.dart';

class ConfigModel {
  String? brandSetting;
  String? digitalProductSetting;
  int? systemDefaultCurrency;
  bool? digitalPayment;
  bool? cashOnDelivery;
  String? sellerRegistration;
  String? posActive;
  String? companyPhone;
  String? companyEmail;
  ImageFullUrl? companyLogo;
  ImageFullUrl? companyCoverImage;
  String? companyIcon;
  String? companyName;
  int? deliveryCountryRestriction;
  int? deliveryZipCodeAreaRestriction;
  BaseUrls? baseUrls;
  StaticUrls? staticUrls;
  String? aboutUs;
  String? privacyPolicy;
  List<Faq>? faq;
  String? termsConditions;
  RefundPolicy? refundPolicy;
  RefundPolicy? returnPolicy;
  RefundPolicy? cancellationPolicy;
  RefundPolicy? shippingPolicy;
  List<CurrencyList>? currencyList;
  String? currencySymbolPosition;
  String? businessMode;
  bool? maintenanceMode;
  List<Language>? language;
  List<ColorsModel>? colors;
  List<String>? unit;
  String? shippingMethod;
  bool? emailVerification;
  bool? phoneVerification;
  bool? firebaseVerification;
  String? countryCode;
  List<SocialLogin>? socialLogin;
  String? currencyModel;
  String? forgotPasswordVerification;
  Announcement? announcement;
  String? softwareVersion;
  int? decimalPointSettings;
  String? inhouseSelectedShippingType;
  int? billingInputByCustomer;
  int? minimumOrderLimit;
  int? walletStatus;
  int? loyaltyPointStatus;
  double? loyaltyPointExchangeRate;
  int? loyaltyPointMinimumPoint;
  List<PaymentMethods>? paymentMethods;
  OfflinePayment? offlinePayment;
  String? paymentMethodImagePath;
  String? refEarningStatus;
  String? activeTheme;
  List<PopularTags>? popularTags;
  int? guestCheckOut;
  int? addFundsToWallet;
  double? minimumAddFundAmount;
  double? maximumAddFundAmount;
  String? refSignup;
  int? orderVerification;
  InhouseTemporaryClose? inhouseTemporaryClose;
  InhouseVacationAdd? inhouseVacationAdd;
  int? mapApiStatus;
  DefaultLocation? defaultLocation;
  UserAppVersionControl? userAppVersionControl;
  ImageFullUrl? companyFavIcon;
  String? primaryColorCode;
  String? secondaryColorCode;
  MaintenanceMode? maintenanceModeData;
  CustomerLogin? customerLogin;
  CustomerVerification? customerVerification;
  int? refundDayLimit;
  int? otpResendTime;
  bool? hasLocaldb;
  bool? localMaintenanceMode;
  String? blogUrl;
  double? productMaxUnitPriceRange;
  double? productMinUnitPriceRange;
  InHouseShop? inHouseShop;
  int? systemTaxIncludeStatus;
  int? systemImageFileUploadMaxSize;
  int? systemGeneralFileUploadMaxSize;
  List<CompanyReliability>? companyReliability;
  bool? isAiFeatureEnabled;
  WholesaleConfig? wholesaleConfig;
  ConfigModules? modules;
  bool get isWholesaleActive => wholesaleConfig?.status ?? false;
  bool get isWholesaleModuleInstalled => modules?.wholesale ?? false;
  AuctionConfig? auctionConfig;
  bool get isAuctionActive => auctionConfig?.status ?? false;
  String? systemTaxType;
  bool? aiShoppingAssistantStatus;


  ConfigModel(
      {this.brandSetting,
        this.digitalProductSetting,
        this.systemDefaultCurrency,
        this.digitalPayment,
        this.cashOnDelivery,
        this.sellerRegistration,
        this.posActive,
        this.companyPhone,
        this.companyEmail,
        this.companyLogo,
        this.companyCoverImage,
        this.companyIcon,
        this.companyName,
        this.deliveryCountryRestriction,
        this.deliveryZipCodeAreaRestriction,
        this.baseUrls,
        this.staticUrls,
        this.aboutUs,
        this.privacyPolicy,
        this.faq,
        this.termsConditions,
        this.refundPolicy,
        this.returnPolicy,
        this.cancellationPolicy,
        this.shippingPolicy,
        this.currencyList,
        this.currencySymbolPosition,
        this.businessMode,
        this.maintenanceMode,
        this.language,
        this.colors,
        this.unit,
        this.shippingMethod,
        this.emailVerification,
        this.phoneVerification,
        this.firebaseVerification,
        this.countryCode,
        this.socialLogin,
        this.currencyModel,
        this.forgotPasswordVerification,
        this.announcement,
        this.softwareVersion,
        this.decimalPointSettings,
        this.inhouseSelectedShippingType,
        this.billingInputByCustomer,
        this.minimumOrderLimit,
        this.walletStatus,
        this.loyaltyPointStatus,
        this.loyaltyPointExchangeRate,
        this.loyaltyPointMinimumPoint,
        this.paymentMethods,
        this.offlinePayment,
        this.paymentMethodImagePath,
        this.refEarningStatus,
        this.activeTheme,
        this.popularTags,
        this.guestCheckOut,
        this.addFundsToWallet,
        this.minimumAddFundAmount,
        this.maximumAddFundAmount,
        this.refSignup,
        this.orderVerification,
        this.inhouseTemporaryClose,
        this.inhouseVacationAdd,
        this.mapApiStatus,
        this.defaultLocation,
        this.userAppVersionControl,
        this.companyFavIcon,
        this.primaryColorCode,
        this.secondaryColorCode,
        this.maintenanceModeData,
        this.customerLogin,
        this.customerVerification,
        this.refundDayLimit,
        this.otpResendTime,
        this.hasLocaldb,
        this.localMaintenanceMode,
        this.blogUrl,
        this.inHouseShop,
        this.productMaxUnitPriceRange,
        this.productMinUnitPriceRange,
        this.systemTaxIncludeStatus,
        this.systemImageFileUploadMaxSize,
        this.systemGeneralFileUploadMaxSize,
        this.companyReliability,
        this.isAiFeatureEnabled,
        this.wholesaleConfig,
        this.auctionConfig,
        this.systemTaxType,
        this.aiShoppingAssistantStatus
      });

  ConfigModel.fromJson(Map<String, dynamic> body) {
    final Map<String, dynamic> json = _map(ApiEnvelope.content(body));
    final Map<String, dynamic> company = _map(json['company']);
    final Map<String, dynamic> theme = _map(json['theme']);
    final Map<String, dynamic> business = _map(json['business']);
    final Map<String, dynamic> priceRange = _map(business['product_unit_price_range']);
    final Map<String, dynamic> currency = _map(json['currency']);
    final Map<String, dynamic> vendor = _map(json['vendor']);
    final Map<String, dynamic> order = _map(json['order']);
    final Map<String, dynamic> shipping = _map(json['shipping']);
    final Map<String, dynamic> shippingMap = _map(shipping['map']);
    final Map<String, dynamic> payment = _map(json['payment']);
    final Map<String, dynamic> offlinePaymentSetting = _map(payment['offline_payment']);
    final Map<String, dynamic> wallet = _map(json['wallet']);
    final Map<String, dynamic> addFunds = _map(wallet['add_funds']);
    final Map<String, dynamic> loyaltyPoint = _map(json['loyalty_point']);
    final Map<String, dynamic> referral = _map(json['referral']);
    final Map<String, dynamic> authentication = _map(json['authentication']);
    final Map<String, dynamic> customerAuth = _map(authentication['customer']);
    final Map<String, dynamic> verification = _map(customerAuth['verification']);
    final Map<String, dynamic> customerApp = _map(_map(json['app_versions'])['customer']);
    final Map<String, dynamic> inHouseShopJson = _map(json['in_house_shop']);
    final Map<String, dynamic> tax = _map(json['tax']);
    final Map<String, dynamic> ai = _map(json['ai']);
    final Map<String, dynamic> media = _map(json['media']);
    final Map<String, dynamic> uploadLimits = _map(media['upload_limits']);
    final Map<String, dynamic> urls = _map(json['urls']);

    companyName = company['name'];
    companyPhone = company['phone']?.toString();
    companyEmail = company['email'];
    countryCode = company['country_code'];
    companyLogo = _imageFullUrl(company['logo_full_url']);
    companyCoverImage = _imageFullUrl(company['cover_image_full_url']);
    companyFavIcon = _imageFullUrl(company['fav_icon_full_url']);
    companyReliability = _listOf(company['reliability'], CompanyReliability.fromJson);

    activeTheme = theme['active'];
    primaryColorCode = _map(theme['colors'])['primary'];
    secondaryColorCode = _map(theme['colors'])['secondary'];

    businessMode = business['mode'];
    softwareVersion = business['software_version'];
    brandSetting = _flagString(business['brand_enabled']);
    digitalProductSetting = _flagString(business['digital_product_enabled']);
    decimalPointSettings = int.tryParse('${business['decimal_point']}') ?? 1;
    unit = business['units'] is List ? List<String>.from(business['units']) : null;
    colors = _listOf(business['colors'], ColorsModel.fromJson);
    popularTags = _listOf(business['popular_tags'], PopularTags.fromJson);
    productMinUnitPriceRange = double.tryParse('${priceRange['min']}');
    productMaxUnitPriceRange = double.tryParse('${priceRange['max']}');
    announcement = Announcement.fromJson(_map(business['announcement']));

    systemDefaultCurrency = int.tryParse('${currency['default_id']}');
    currencyModel = currency['model'];
    currencySymbolPosition = currency['symbol_position'];
    currencyList = _listOf(currency['list'], CurrencyList.fromJson);
    language = _listOf(json['languages'], Language.fromJson);

    sellerRegistration = _flagString(vendor['registration']);
    posActive = _flagString(vendor['pos']);

    minimumOrderLimit = int.tryParse('${order['minimum_order_limit']}');
    billingInputByCustomer = _flag(order['billing_input_by_customer']);
    guestCheckOut = _flag(order['guest_checkout']) ?? 0;
    orderVerification = _flag(order['order_verification']);
    refundDayLimit = int.tryParse('${order['refund_day_limit']}');

    shippingMethod = shipping['method'];
    inhouseSelectedShippingType = shipping['in_house_shipping_type'];
    deliveryCountryRestriction = _flag(shipping['country_restriction']) ?? 0;
    deliveryZipCodeAreaRestriction = _flag(shipping['zip_code_restriction']) ?? 0;
    mapApiStatus = _flag(shippingMap['status']);
    defaultLocation = shippingMap['default_location'] is Map
        ? DefaultLocation.fromJson(_map(shippingMap['default_location'])) : null;

    digitalPayment = _flag(payment['digital_payment']) == 1;
    cashOnDelivery = _flag(payment['cash_on_delivery']) == 1;
    offlinePayment = _flag(offlinePaymentSetting['status']) == 1 ? OfflinePayment.fromJson(offlinePaymentSetting) : null;
    paymentMethods = _listOf(payment['methods'], PaymentMethods.fromJson);
    paymentMethodImagePath = _maps(payment['methods'])
        .map((method) => _urlDirectory(method['image_url'])).firstWhere((path) => path != null, orElse: () => null);

    walletStatus = _flag(wallet['status']);
    addFundsToWallet = _flag(addFunds['status']) ?? 0;
    minimumAddFundAmount = double.tryParse('${addFunds['minimum_amount']}') ?? 0;
    maximumAddFundAmount = double.tryParse('${addFunds['maximum_amount']}') ?? 0;

    loyaltyPointStatus = _flag(loyaltyPoint['status']);
    loyaltyPointExchangeRate = double.tryParse('${loyaltyPoint['exchange_rate']}') ?? 1;
    loyaltyPointMinimumPoint = int.tryParse('${loyaltyPoint['minimum_point']}');

    refEarningStatus = _flagString(referral['status']);
    refSignup = referral['signup_url'];

    customerLogin = CustomerLogin.fromJson(customerAuth);
    customerVerification = CustomerVerification.fromJson(verification);
    emailVerification = _flag(verification['email']) == 1;
    phoneVerification = _flag(verification['phone']) == 1;
    firebaseVerification = _flag(verification['firebase']) == 1;
    socialLogin = _listOf(customerAuth['social_mediums'], SocialLogin.fromJson);
    forgotPasswordVerification = customerAuth['forgot_password_method'];
    otpResendTime = int.tryParse('${authentication['otp_resend_seconds']}');

    maintenanceModeData = json['maintenance'] is Map ? MaintenanceMode.fromJson(_map(json['maintenance'])) : null;
    userAppVersionControl = customerApp.isEmpty ? null : UserAppVersionControl.fromJson(customerApp);

    inHouseShop = inHouseShopJson.isEmpty ? null : InHouseShop.fromJson(inHouseShopJson);
    inhouseTemporaryClose = InhouseTemporaryClose(status: _flag(inHouseShopJson['temporary_close']) == 1);
    inhouseVacationAdd = inHouseShopJson['vacation'] is Map ? InhouseVacationAdd.fromJson(_map(inHouseShopJson['vacation'])) : null;

    systemTaxType = tax['type'];
    systemTaxIncludeStatus = _flag(tax['is_included']);

    isAiFeatureEnabled = _flag(ai['enabled']) == 1;
    aiShoppingAssistantStatus = _flag(ai['shopping_assistant']) == 1;

    baseUrls = media['base_urls'] is Map ? BaseUrls.fromJson(_map(media['base_urls'])) : null;
    systemImageFileUploadMaxSize = int.tryParse('${uploadLimits['image_max_size_mb']}');
    systemGeneralFileUploadMaxSize = int.tryParse('${uploadLimits['file_max_size_mb']}');

    staticUrls = urls.isEmpty ? null : StaticUrls.fromJson(urls);
    blogUrl = urls['blog'];

    auctionConfig = json['auction'] is Map ? AuctionConfig.fromJson(_map(json['auction'])) : null;
    wholesaleConfig = json['wholesale'] is Map ? WholesaleConfig.fromJson(_map(json['wholesale'])) : null;
    modules = json['modules'] is Map ? ConfigModules.fromJson(_map(json['modules'])) : null;
  }
}

class ConfigModules {
  bool ai;
  bool auction;
  bool blog;
  bool builder;
  bool courier;
  bool taxModule;
  bool wholesale;

  ConfigModules({
    this.ai = false,
    this.auction = false,
    this.blog = false,
    this.builder = false,
    this.courier = false,
    this.taxModule = false,
    this.wholesale = false,
  });

  ConfigModules.fromJson(Map<String, dynamic> json)
      : ai = _flag(json['ai']) == 1,
        auction = _flag(json['auction']) == 1,
        blog = _flag(json['blog']) == 1,
        builder = _flag(json['builder']) == 1,
        courier = _flag(json['courier']) == 1,
        taxModule = _flag(json['tax_module']) == 1,
        wholesale = _flag(json['wholesale']) == 1;
}

class BaseUrls {
  String? productImageUrl;
  String? productThumbnailUrl;
  String? digitalProductUrl;
  String? brandImageUrl;
  String? customerImageUrl;
  String? bannerImageUrl;
  String? categoryImageUrl;
  String? reviewImageUrl;
  String? sellerImageUrl;
  String? shopImageUrl;
  String? notificationImageUrl;
  String? deliveryManImageUrl;

  BaseUrls(
      {this.productImageUrl,
        this.productThumbnailUrl,
        this.digitalProductUrl,
        this.brandImageUrl,
        this.customerImageUrl,
        this.bannerImageUrl,
        this.categoryImageUrl,
        this.reviewImageUrl,
        this.sellerImageUrl,
        this.shopImageUrl,
        this.notificationImageUrl,
        this.deliveryManImageUrl});

  BaseUrls.fromJson(Map<String, dynamic> json) {
    productImageUrl = json['product'];
    productThumbnailUrl = json['product_thumbnail'];
    digitalProductUrl = json['digital_product'];
    brandImageUrl = json['brand'];
    customerImageUrl = json['customer'];
    bannerImageUrl = json['banner'];
    categoryImageUrl = json['category'];
    reviewImageUrl = json['review'];
    sellerImageUrl = json['vendor'];
    shopImageUrl = json['shop'];
    notificationImageUrl = json['notification'];
    deliveryManImageUrl = json['deliveryman'];
  }

}

class StaticUrls {
  String? contactUs;
  String? brands;
  String? categories;
  String? customerAccount;
  String? auctionPromotionalPopup;
  String? wholesalePromotionalPopup;

  StaticUrls({this.contactUs, this.brands, this.categories, this.customerAccount, this.auctionPromotionalPopup, this.wholesalePromotionalPopup});

  StaticUrls.fromJson(Map<String, dynamic> json) {
    contactUs = json['contact_us'];
    brands = json['brands'];
    categories = json['categories'];
    customerAccount = json['customer_account'];
    auctionPromotionalPopup = json['auction_promotional_popup']?.toString();
    wholesalePromotionalPopup = json['wholesale_promotional_popup']?.toString();
  }
}

class Faq {
  int? id;
  String? question;
  String? answer;
  int? ranking;
  int? status;
  String? createdAt;
  String? updatedAt;

  Faq(
      {this.id,
        this.question,
        this.answer,
        this.ranking,
        this.status,
        this.createdAt,
        this.updatedAt});

  Faq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    ranking = json['ranking'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}

class RefundPolicy {
  int? status;
  String? content;

  RefundPolicy({this.status, this.content});

  RefundPolicy.fromJson(Map<String, dynamic> json) {
    if(json['status'] != null){
      try{
        status = json['status'];
      }catch(e){
        status = int.parse(json['status'].toString());
      }
    }

    content = json['content'];
  }

}

class CurrencyList {
  int? id;
  String? name;
  String? symbol;
  String? code;
  bool? status;
  double? exchangeRate;
  String? createdAt;
  String? updatedAt;

  CurrencyList(
      {this.id,
        this.name,
        this.symbol,
        this.code,
        this.status,
        this.exchangeRate,
        this.createdAt,
        this.updatedAt});

  CurrencyList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
    code = json['code'];
    status = json['status'];
    if(json['exchange_rate'] != null){
      try{
        exchangeRate = json['exchange_rate'].toDouble();
      }catch(e){
        exchangeRate = double.parse(json['exchange_rate'].toString());
      }
    }

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}

class Language {
  String? code;
  String? name;

  Language({this.code, this.name});

  Language.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }
}

class ColorsModel {
  int? id;
  String? name;
  String? code;
  String? createdAt;
  String? updatedAt;

  ColorsModel({this.id, this.name, this.code, this.createdAt, this.updatedAt});

  ColorsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}

class SocialLogin {
  String? loginMedium;
  bool? status;

  SocialLogin({this.loginMedium, this.status});

  SocialLogin.fromJson(Map<String, dynamic> json) {
    loginMedium = json['medium'];
    status = _flag(json['status']) == 1;
  }

}

class Announcement {
  String? status;
  String? color;
  String? textColor;
  String? announcement;

  Announcement({this.status, this.color, this.textColor, this.announcement});

  Announcement.fromJson(Map<String, dynamic> json) {
    status = _flagString(json['status']) ?? '0';
    color = json['color'];
    textColor = json['text_color'];
    announcement = json['text'];
  }

}

class PaymentMethods {
  String? keyName;
  AdditionalDatas? additionalDatas;

  PaymentMethods({this.keyName, this.additionalDatas});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    keyName = json['key_name'];
    additionalDatas = AdditionalDatas(
      gatewayTitle: json['title'],
      gatewayImage: _urlFileName(json['image_url']),
    );
  }

}

class AdditionalDatas {
  String? gatewayTitle;
  String? gatewayImage;

  AdditionalDatas({this.gatewayTitle, this.gatewayImage});

}

class OfflinePayment {
  String? name;
  String? image;

  OfflinePayment({this.name, this.image});

  OfflinePayment.fromJson(Map<String, dynamic> json) {
    image = json['image_url'];
  }

}

class PopularTags {
  int? id;
  String? tag;
  String? createdAt;
  String? updatedAt;

  PopularTags(
      {this.id, this.tag,  this.createdAt, this.updatedAt});

  PopularTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}


class InhouseTemporaryClose {
  bool? status;
  InhouseTemporaryClose({this.status});
}

class InhouseVacationAdd {
  bool? status;
  DateTime? vacationStartDate;
  DateTime? vacationEndDate;
  VacationDurationType? vacationDurationType;
  String? vacationNote;

  InhouseVacationAdd(
      {this.status,
        this.vacationStartDate,
        this.vacationEndDate,
        this.vacationNote,
        this.vacationDurationType,
      });

  InhouseVacationAdd.fromJson(Map<String, dynamic> json) {
    status = _flag(json['status']) == 1;
    vacationStartDate = DateTime.tryParse('${json['start_date']}');
    vacationEndDate = DateTime.tryParse('${json['end_date']}');
    vacationNote = json['note'];
    if (json['vacation_duration_type'] != null) {
      vacationDurationType = VacationDurationType.fromJson(json['vacation_duration_type']);
    }
  }
}


class DefaultLocation {
  String? lat;
  String? lng;

  DefaultLocation({this.lat, this.lng});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}


class UserAppVersionControl {
  ForAndroid? forAndroid;
  ForAndroid? forIos;

  UserAppVersionControl({this.forAndroid, this.forIos});

  UserAppVersionControl.fromJson(Map<String, dynamic> json) {
    forAndroid = json['android'] is Map ? ForAndroid.fromJson(_map(json['android'])) : null;
    forIos = json['ios'] is Map ? ForAndroid.fromJson(_map(json['ios'])) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (forAndroid != null) {
      data['for_android'] = forAndroid!.toJson();
    }
    if (forIos != null) {
      data['for_ios'] = forIos!.toJson();
    }
    return data;
  }
}

class ForAndroid {
  int? status;
  String? version;
  String? link;

  ForAndroid({this.status, this.version, this.link});

  ForAndroid.fromJson(Map<String, dynamic> json) {
    status = _flag(json['status']) ?? 0;
    version = json['version']?.toString();
    link = json['link']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['version'] = version;
    data['link'] = link;
    return data;
  }
}


class MaintenanceMode {
  int? maintenanceStatus;
  SelectedMaintenanceSystem? selectedMaintenanceSystem;
  MaintenanceMessages? maintenanceMessages;
  MaintenanceTypeAndDuration? maintenanceTypeAndDuration;

  MaintenanceMode(
      {this.maintenanceStatus,
        this.selectedMaintenanceSystem,
        this.maintenanceMessages, this.maintenanceTypeAndDuration});

  MaintenanceMode.fromJson(Map<String, dynamic> json) {
    maintenanceStatus = _flag(json['status']);
    selectedMaintenanceSystem = json['systems'] is Map ? SelectedMaintenanceSystem.fromJson(_map(json['systems'])) : null;
    maintenanceMessages = json['message'] is Map ? MaintenanceMessages.fromJson(_map(json['message'])) : null;
    maintenanceTypeAndDuration = json['duration'] is Map ? MaintenanceTypeAndDuration.fromJson(_map(json['duration'])) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_status'] = maintenanceStatus;
    if (selectedMaintenanceSystem != null) {
      data['selected_maintenance_system'] =
          selectedMaintenanceSystem!.toJson();
    }
    if (maintenanceMessages != null) {
      data['maintenance_messages'] = maintenanceMessages!.toJson();
    }
    if (maintenanceTypeAndDuration != null) {
      data['maintenance_type_and_duration'] =
          maintenanceTypeAndDuration!.toJson();
    }
    return data;
  }
}

class SelectedMaintenanceSystem {
  int? branchPanel;
  int? customerApp;
  int? webApp;
  int? deliverymanApp;

  SelectedMaintenanceSystem({this.branchPanel, this.customerApp, this.webApp, this.deliverymanApp});

  SelectedMaintenanceSystem.fromJson(Map<String, dynamic> json) {
    customerApp = _flag(json['user_app']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_panel'] = branchPanel;
    data['customer_app'] = customerApp;
    data['web_app'] = webApp;
    data['deliveryman_app'] = deliverymanApp;
    return data;
  }
}

class MaintenanceMessages {
  int? businessNumber;
  int? businessEmail;
  String? maintenanceMessage;
  String? messageBody;

  MaintenanceMessages(
      {this.businessNumber,
        this.businessEmail,
        this.maintenanceMessage,
        this.messageBody});

  MaintenanceMessages.fromJson(Map<String, dynamic> json) {
    businessNumber = _flag(json['show_business_number']);
    businessEmail = _flag(json['show_business_email']);
    maintenanceMessage = json['title'];
    messageBody = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_number'] = businessNumber;
    data['business_email'] = businessEmail;
    data['maintenance_message'] = maintenanceMessage;
    data['message_body'] = messageBody;
    return data;
  }
}

class MaintenanceTypeAndDuration {
  String? _maintenanceDuration;
  String? _startDate;
  String? _endDate;

  MaintenanceTypeAndDuration(
      {String? maintenanceDuration, String? startDate, String? endDate}) {
    if (maintenanceDuration != null) {
      _maintenanceDuration = maintenanceDuration;
    }
    if (startDate != null) {
      _startDate = startDate;
    }
    if (endDate != null) {
      _endDate = endDate;
    }
  }

  String? get maintenanceDuration => _maintenanceDuration;
  set setMaintenanceDuration(String? maintenanceDuration) =>
      _maintenanceDuration = maintenanceDuration;
  String? get startDate => _startDate;
  set setStartDate(String? startDate) => _startDate = startDate;
  String? get setEndDate => _endDate;
  set endDate(String? endDate) => _endDate = endDate;

  MaintenanceTypeAndDuration.fromJson(Map<String, dynamic> json) {
    _maintenanceDuration = json['type'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_duration'] = _maintenanceDuration;
    data['start_date'] = _startDate;
    data['end_date'] = _endDate;
    return data;
  }
}

class CustomerLogin {
  LoginOption? loginOption;
  SocialMediaLoginOptions? socialMediaLoginOptions;

  CustomerLogin({this.loginOption, this.socialMediaLoginOptions});

  CustomerLogin.fromJson(Map<String, dynamic> json) {
    loginOption = json['login_options'] is Map ? LoginOption.fromJson(_map(json['login_options'])) : null;
    socialMediaLoginOptions = json['social_mediums'] is List ? SocialMediaLoginOptions.fromMediums(json['social_mediums']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (loginOption != null) {
      data['login_option'] = loginOption!.toJson();
    }
    if (socialMediaLoginOptions != null) {
      data['social_media_login_options'] =
          socialMediaLoginOptions!.toJson();
    }
    return data;
  }
}

class LoginOption {
  int? manualLogin;
  int? otpLogin;
  int? socialMediaLogin;

  LoginOption({this.manualLogin, this.otpLogin, this.socialMediaLogin});

  LoginOption.fromJson(Map<String, dynamic> json) {
    manualLogin = _flag(json['manual']);
    otpLogin = _flag(json['otp']);
    socialMediaLogin = _flag(json['social']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['manual_login'] = manualLogin;
    data['otp_login'] = otpLogin;
    data['social_media_login'] = socialMediaLogin;
    return data;
  }
}

class SocialMediaLoginOptions {
  int? google;
  int? facebook;
  int? apple;

  SocialMediaLoginOptions({this.google, this.facebook, this.apple});

  SocialMediaLoginOptions.fromMediums(List mediums) {
    for (final Map<String, dynamic> medium in _maps(mediums)) {
      final int enabled = _flag(medium['status']) == 1 && _flag(medium['enabled_for_login']) == 1 ? 1 : 0;
      switch (medium['medium']) {
        case 'google':
          google = enabled;
        case 'facebook':
          facebook = enabled;
        case 'apple':
          apple = enabled;
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['google'] = google;
    data['facebook'] = facebook;
    data['apple'] = apple;
    return data;
  }
}


class CustomerVerification {
  int? status;
  int? phone;
  int? email;
  int? firebase;

  CustomerVerification({this.status, this.phone, this.email, this.firebase});

  CustomerVerification.fromJson(Map<String, dynamic> json) {
    status = _flag(json['required']);
    phone = _flag(json['phone']);
    email = _flag(json['email']);
    firebase = _flag(json['firebase']);

    // status = 1;
    // firebase = 1;
    // email = 0;
    // phone =  0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['phone'] = phone;
    data['email'] = email;
    data['firebase'] = firebase;
    return data;
  }
}


class InHouseShop {
  final int? id;
  final int? sellerId;
  final String? authorType;
  final String? name;
  final String? slug;
  final String? contact;
  final String? address;
  final String? image;
  final String? imageStorageType;
  final String? banner;
  final String? bannerStorageType;
  final String? offerBanner;
  final String? offerBannerStorageType;
  final String? bottomBanner;
  final String? bottomBannerStorageType;
  final int? vacationDurationType;
  final String? vacationStartDate;
  final String? vacationEndDate;
  final String? vacationNote;
  final bool? vacationStatus;
  final bool? temporaryClose;
  final String? updatedAt;
  final String? createdAt;

  final ImageFullUrl? imageFullUrl;
  final ImageFullUrl? bannerFullUrl;
  final ImageFullUrl? offerBannerFullUrl;
  final ImageFullUrl? bottomBannerFullUrl;
  final ImageFullUrl? tinCertificateFullUrl;

  InHouseShop({
    this.id,
    this.sellerId,
    this.authorType,
    this.name,
    this.slug,
    this.contact,
    this.address,
    this.image,
    this.imageStorageType,
    this.banner,
    this.bannerStorageType,
    this.offerBanner,
    this.offerBannerStorageType,
    this.bottomBanner,
    this.bottomBannerStorageType,
    this.vacationDurationType,
    this.vacationStartDate,
    this.vacationEndDate,
    this.vacationNote,
    this.vacationStatus,
    this.temporaryClose,
    this.updatedAt,
    this.createdAt,
    this.imageFullUrl,
    this.bannerFullUrl,
    this.offerBannerFullUrl,
    this.bottomBannerFullUrl,
    this.tinCertificateFullUrl,
  });

  factory InHouseShop.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> vacation = _map(json['vacation']);

    return InHouseShop(
    id: json['id'],
    sellerId: json['seller_id'],
    authorType: json['author_type'],
    name: json['name'],
    slug: json['slug'],
    contact: json['contact'],
    address: json['address'],
    image: json['image'],
    imageStorageType: json['image_storage_type'],
    banner: json['banner'],
    bannerStorageType: json['banner_storage_type'],
    offerBanner: json['offer_banner'],
    offerBannerStorageType: json['offer_banner_storage_type'],
    bottomBanner: json['bottom_banner'],
    bottomBannerStorageType: json['bottom_banner_storage_type'],
    vacationDurationType: int.tryParse('${vacation['vacation_duration_type']}'),
    vacationStartDate: vacation['start_date'],
    vacationEndDate: vacation['end_date'],
    vacationNote: vacation['note'],
    vacationStatus: vacation['status'] == null ? null : _flag(vacation['status']) == 1,
    temporaryClose: json['temporary_close'],
    updatedAt: json['updated_at'],
    createdAt: json['created_at'],
    imageFullUrl: json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null,
    bannerFullUrl: json['banner_full_url'] != null ? ImageFullUrl.fromJson(json['banner_full_url']) : null,
    offerBannerFullUrl: json['offer_banner_full_url'] != null ? ImageFullUrl.fromJson(json['offer_banner_full_url']) : null,
    bottomBannerFullUrl: json['bottom_banner_full_url'] != null ? ImageFullUrl.fromJson(json['bottom_banner_full_url']) : null,
    tinCertificateFullUrl: json['tin_certificate_full_url'] != null ? ImageFullUrl.fromJson(json['tin_certificate_full_url']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'seller_id': sellerId,
    'author_type': authorType,
    'name': name,
    'slug': slug,
    'contact': contact,
    'address': address,
    'image': image,
    'image_storage_type': imageStorageType,
    'banner': banner,
    'banner_storage_type': bannerStorageType,
    'offer_banner': offerBanner,
    'offer_banner_storage_type': offerBannerStorageType,
    'bottom_banner': bottomBanner,
    'bottom_banner_storage_type': bottomBannerStorageType,
    'vacation_duration_type': vacationDurationType,
    'vacation_start_date': vacationStartDate,
    'vacation_end_date': vacationEndDate,
    'vacation_note': vacationNote,
    'vacation_status': vacationStatus,
    'temporary_close': temporaryClose,
    'updated_at': updatedAt,
    'created_at': createdAt,
    'image_full_url': imageFullUrl?.toJson(),
    'banner_full_url': bannerFullUrl?.toJson(),
    'offer_banner_full_url': offerBannerFullUrl?.toJson(),
    'bottom_banner_full_url': bottomBannerFullUrl?.toJson(),
    'tin_certificate_full_url': tinCertificateFullUrl?.toJson(),
  };
}

class CompanyReliability {
  String? item;
  String? title;
  int? status;
  ImageFullUrl? imageFullUrl;

  CompanyReliability({this.item, this.title, this.status, this.imageFullUrl});

  CompanyReliability.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    title = json['title'];
    status = _flag(json['status']);
    imageFullUrl = json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null;
  }
}

class AuctionConfig {
  bool? status;
  bool? activeForVendor;
  bool? activeForCustomer;
  double? commissionPercentage;
  AuctionEntryFee? entryFee;
  AuctionDurationSetting? expiredVisibilityDuration;
  AuctionDurationSetting? upcomingVisibilityDuration;
  AuctionDurationSetting? winnerClaimTimeLimit;
  AuctionHomePage? homePage;
  List<AuctionCommitment>? commitments;

  AuctionConfig({
    this.status,
    this.activeForVendor,
    this.activeForCustomer,
    this.commissionPercentage,
    this.entryFee,
    this.expiredVisibilityDuration,
    this.upcomingVisibilityDuration,
    this.winnerClaimTimeLimit,
    this.homePage,
    this.commitments,
  });

  AuctionConfig.fromJson(Map<String, dynamic> json) {
    status = _flag(json['status']) == 1;
    activeForVendor = _flag(json['active_for_vendor']) == 1;
    activeForCustomer = _flag(json['active_for_customer']) == 1;
    commissionPercentage = double.tryParse('${json['commission_percentage']}');
    entryFee = AuctionEntryFee.fromJson(_map(json['entry_fee']));
    expiredVisibilityDuration = _durationSetting(json['expired_visibility_duration']);
    upcomingVisibilityDuration = _durationSetting(json['upcoming_visibility_duration']);
    winnerClaimTimeLimit = _durationSetting(json['winner_claim_time_limit']);
    homePage = json['home_page'] is Map ? AuctionHomePage.fromJson(_map(json['home_page'])) : null;
    commitments = _listOf(json['commitments'], AuctionCommitment.fromJson);
  }

  bool get isEntryFeeEnabled => (entryFee?.status ?? false) && (entryFee?.amount ?? 0) > 0;
}

class AuctionEntryFee {
  bool? status;
  double? amount;

  AuctionEntryFee({this.status, this.amount});

  AuctionEntryFee.fromJson(Map<String, dynamic> json) {
    status = _flag(json['status']) == 1;
    amount = double.tryParse('${json['amount']}');
  }
}

class AuctionHomePage {
  String? title;
  String? subtitle;
  ImageFullUrl? bgImageFullUrl;

  AuctionHomePage({this.title, this.subtitle, this.bgImageFullUrl});

  AuctionHomePage.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    bgImageFullUrl = _imageFullUrl(json['bg_image_full_url']);
  }
}

class AuctionDurationSetting {
  int? status;
  int? value;
  String? unit;

  AuctionDurationSetting({this.status, this.value, this.unit});

  AuctionDurationSetting.fromJson(Map<String, dynamic> json) {
    status = _flag(json['status']);
    value = int.tryParse(json['value'].toString());
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'value': value,
      'unit': unit,
    };
  }

  bool get isEnabled => status == 1;

  Duration? get asDuration {
    if (value == null || unit == null) return null;
    return switch (unit!) {
      'hour' => Duration(hours: value!),
      'day'  => Duration(days: value!),
      'week' => Duration(days: value! * 7),
      'month' => Duration(days: value! * 30),
      _      => null,
    };
  }
}

class AuctionCommitment {
  String? item;
  String? title;
  int? status;
  ImageFullUrl? imageFullUrl;

  AuctionCommitment({this.item, this.title, this.status, this.imageFullUrl});

  AuctionCommitment.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    title = json['title'];
    status = _flag(json['status']);
    imageFullUrl = json['image_full_url'] != null
        ? ImageFullUrl.fromJson(json['image_full_url'])
        : null;
  }

  Map<String, dynamic> toJson() => {
    'item': item,
    'title': title,
    'status': status,
    'image_full_url': imageFullUrl?.toJson(),
  };

  bool get isEnabled => status == 1;
}


class WholesaleConfig {
  bool? status;
  WholesaleCommission? commission;
  WholesaleVendorSettings? vendor;
  WholesaleProductSettings? product;
  WholesaleOrderSettings? order;
  WholesaleRefund? refund;
  WholesaleShipping? shipping;
  String? taxType;
  bool? taxIncluded;
  WholesaleInHouseShop? inHouseShop;
  List<WholesaleTrustPolicy>? trustPolicy;
  WholesaleHeroSections? heroSections;
  bool? aiShoppingAssistantStatus;

  WholesaleConfig({
    this.status,
    this.commission,
    this.vendor,
    this.product,
    this.order,
    this.refund,
    this.shipping,
    this.taxType,
    this.taxIncluded,
    this.inHouseShop,
    this.trustPolicy,
    this.heroSections,
    this.aiShoppingAssistantStatus,
  });

  WholesaleConfig.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> tax = _map(json['tax']);
    final Map<String, dynamic> ai = _map(json['ai']);

    status = _flag(json['status']) == 1;
    commission = WholesaleCommission.fromJson(_map(json['commission']));
    vendor = WholesaleVendorSettings.fromJson(_map(json['vendor']));
    product = WholesaleProductSettings.fromJson(_map(json['product']));
    order = WholesaleOrderSettings.fromJson(_map(json['order']));
    refund = WholesaleRefund.fromJson(_map(json['refund']));
    shipping = WholesaleShipping.fromJson(_map(json['shipping']));
    taxType = tax['type'];
    taxIncluded = _flag(tax['is_included']) == 1;
    inHouseShop = json['in_house_shop'] is Map ? WholesaleInHouseShop.fromJson(_map(json['in_house_shop'])) : null;
    trustPolicy = _listOf(json['trust_policy'], WholesaleTrustPolicy.fromJson);
    heroSections = json['hero_sections'] is Map ? WholesaleHeroSections.fromJson(_map(json['hero_sections'])) : null;
    aiShoppingAssistantStatus = _flag(ai['shopping_assistant']) == 1;
  }
}

class WholesaleCommission {
  double? percentage;
  bool? vendorWise;

  WholesaleCommission({this.percentage, this.vendorWise});

  WholesaleCommission.fromJson(Map<String, dynamic> json) {
    percentage = double.tryParse('${json['percentage']}');
    vendorWise = _flag(json['vendor_wise']) == 1;
  }
}

class WholesaleVendorSettings {
  bool? reviewReply;
  bool? canEditOrder;

  WholesaleVendorSettings({this.reviewReply, this.canEditOrder});

  WholesaleVendorSettings.fromJson(Map<String, dynamic> json) {
    reviewReply = _flag(json['review_reply']) == 1;
    canEditOrder = _flag(json['can_edit_order']) == 1;
  }
}

class WholesaleProductSettings {
  bool? brandEnabled;
  bool? newProductApproval;
  bool? shippingCostApproval;

  WholesaleProductSettings({this.brandEnabled, this.newProductApproval, this.shippingCostApproval});

  WholesaleProductSettings.fromJson(Map<String, dynamic> json) {
    brandEnabled = _flag(json['brand_enabled']) == 1;
    newProductApproval = _flag(json['new_product_approval']) == 1;
    shippingCostApproval = _flag(json['shipping_cost_approval']) == 1;
  }
}

class WholesaleOrderSettings {
  bool? deliveryVerification;
  bool? billingAddress;
  WholesaleMinimumOrderAmount? minimumOrderAmount;

  WholesaleOrderSettings({this.deliveryVerification, this.billingAddress, this.minimumOrderAmount});

  WholesaleOrderSettings.fromJson(Map<String, dynamic> json) {
    deliveryVerification = _flag(json['delivery_verification']) == 1;
    billingAddress = _flag(json['billing_address']) == 1;
    minimumOrderAmount = WholesaleMinimumOrderAmount.fromJson(_map(json['minimum_order_amount']));
  }
}

class WholesaleMinimumOrderAmount {
  bool? status;
  bool? setByVendor;
  double? inHouseAmount;

  WholesaleMinimumOrderAmount({this.status, this.setByVendor, this.inHouseAmount});

  WholesaleMinimumOrderAmount.fromJson(Map<String, dynamic> json) {
    status = _flag(json['status']) == 1;
    setByVendor = _flag(json['set_by_vendor']) == 1;
    inHouseAmount = double.tryParse('${json['in_house_amount']}');
  }
}

class WholesaleRefund {
  int? dayLimit;
  bool? addToWallet;

  WholesaleRefund({this.dayLimit, this.addToWallet});

  WholesaleRefund.fromJson(Map<String, dynamic> json) {
    dayLimit = int.tryParse('${json['day_limit']}');
    addToWallet = _flag(json['add_to_wallet']) == 1;
  }
}

class WholesaleShipping {
  String? method;
  String? inHouseShippingType;
  List<WholesaleShippingMethod>? inHouseMethods;
  WholesaleFreeDelivery? freeDelivery;

  WholesaleShipping({this.method, this.inHouseShippingType, this.inHouseMethods, this.freeDelivery});

  WholesaleShipping.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    inHouseShippingType = json['in_house_shipping_type'];
    inHouseMethods = _listOf(json['in_house_methods'], WholesaleShippingMethod.fromJson);
    freeDelivery = WholesaleFreeDelivery.fromJson(_map(json['free_delivery']));
  }
}

class WholesaleShippingMethod {
  int? id;
  String? title;
  String? duration;
  double? cost;

  WholesaleShippingMethod({this.id, this.title, this.duration, this.cost});

  WholesaleShippingMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    cost = double.tryParse('${json['cost']}');
  }
}

class WholesaleFreeDelivery {
  bool? status;
  String? responsibility;
  double? overAmountVendor;
  bool? inHouseStatus;
  double? inHouseOverAmount;

  WholesaleFreeDelivery({
    this.status,
    this.responsibility,
    this.overAmountVendor,
    this.inHouseStatus,
    this.inHouseOverAmount,
  });

  WholesaleFreeDelivery.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> inHouse = _map(json['in_house']);

    status = _flag(json['status']) == 1;
    responsibility = json['responsibility'];
    overAmountVendor = double.tryParse('${json['over_amount_vendor']}');
    inHouseStatus = _flag(inHouse['status']) == 1;
    inHouseOverAmount = double.tryParse('${inHouse['over_amount']}');
  }
}

class WholesaleInHouseShop {
  int? id;
  String? name;
  String? slug;
  ImageFullUrl? imageFullUrl;
  ImageFullUrl? bannerFullUrl;
  bool? temporaryClose;
  WholesaleVacation? vacation;

  WholesaleInHouseShop({
    this.id,
    this.name,
    this.slug,
    this.imageFullUrl,
    this.bannerFullUrl,
    this.temporaryClose,
    this.vacation,
  });

  WholesaleInHouseShop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    imageFullUrl = _imageFullUrl(json['image_full_url']);
    bannerFullUrl = _imageFullUrl(json['banner_full_url']);
    temporaryClose = _flag(json['temporary_close']) == 1;
    vacation = json['vacation'] is Map ? WholesaleVacation.fromJson(_map(json['vacation'])) : null;
  }
}

class WholesaleVacation {
  bool? status;
  String? durationType;
  String? startDate;
  String? endDate;
  String? note;

  WholesaleVacation({this.status, this.durationType, this.startDate, this.endDate, this.note});

  WholesaleVacation.fromJson(Map<String, dynamic> json) {
    status = _flag(json['status']) == 1;
    durationType = json['duration_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    note = json['note'];
  }
}

class WholesaleTrustPolicy {
  String? title;
  ImageFullUrl? iconFullUrl;

  WholesaleTrustPolicy({this.title, this.iconFullUrl});

  WholesaleTrustPolicy.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    iconFullUrl = ImageFullUrl.parse(json['icon_full_url']);
  }
}

class WholesaleHeroSections {
  WholesaleHeroSection? products;
  WholesaleHeroSection? manufacturers;

  WholesaleHeroSections({this.products, this.manufacturers});

  WholesaleHeroSections.fromJson(Map<String, dynamic> json) {
    products = json['products'] is Map ? WholesaleHeroSection.fromJson(_map(json['products'])) : null;
    manufacturers = json['manufacturers'] is Map ? WholesaleHeroSection.fromJson(_map(json['manufacturers'])) : null;
  }
}

class WholesaleHeroSection {
  String? title;
  String? subTitle;
  String? trustText;
  ImageFullUrl? imageFullUrl;

  WholesaleHeroSection({this.title, this.subTitle, this.trustText, this.imageFullUrl});

  WholesaleHeroSection.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['sub_title'];
    trustText = json['trust_text'];
    imageFullUrl = ImageFullUrl.parse(json['image_full_url']);
  }
}

int? _flag(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value ? 1 : 0;
  if (value is num) return value == 0 ? 0 : 1;
  final String text = value.toString().toLowerCase();
  return text == 'true' || text == '1' ? 1 : 0;
}

String? _flagString(dynamic value) => _flag(value)?.toString();

Map<String, dynamic> _map(dynamic value) => value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

List<Map<String, dynamic>> _maps(dynamic value) => value is List
    ? [for (final dynamic item in value) if (item is Map) Map<String, dynamic>.from(item)] : <Map<String, dynamic>>[];

List<T>? _listOf<T>(dynamic value, T Function(Map<String, dynamic> json) parse) =>
    value is List ? [for (final Map<String, dynamic> item in _maps(value)) parse(item)] : null;

ImageFullUrl? _imageFullUrl(dynamic value) => value is Map ? ImageFullUrl.fromJson(_map(value)) : null;

AuctionDurationSetting? _durationSetting(dynamic value) =>
    value is Map ? AuctionDurationSetting.fromJson(_map(value)) : null;

String? _urlDirectory(dynamic url) {
  final String text = url?.toString() ?? '';
  final int slash = text.lastIndexOf('/');
  return slash < 0 ? null : text.substring(0, slash);
}

String? _urlFileName(dynamic url) {
  final String text = url?.toString() ?? '';
  return text.isEmpty ? null : text.substring(text.lastIndexOf('/') + 1);
}
