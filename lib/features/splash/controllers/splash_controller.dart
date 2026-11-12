import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/local/cache_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/business_pages_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/services/splash_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

enum AppMode { main, wholesale, auction }

class SplashController extends ChangeNotifier {
  final SplashServiceInterface? splashServiceInterface;
  SplashController({required this.splashServiceInterface});

  AppMode _currentMode = AppMode.main;
  AppMode get currentMode => _currentMode;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool get isAuctionEnabled => _configModel?.isAuctionActive ?? false;
  bool get canCustomerCreateAuction => (_configModel?.isAuctionActive == true) && (_configModel?.auctionConfig?.activeForCustomer == true);

  bool get isWholesaleEnabled => _configModel?.isWholesaleActive ?? false;

  bool get isWholesaleOrdersOnlyMode => !isWholesaleEnabled && (_configModel?.isWholesaleModuleInstalled ?? false);

  static const Duration _auctionBannerCooldown = Duration(minutes: 2);
  Timer? _auctionBannerCooldownTimer;
  bool _auctionBannerOnCooldown = false;

  static const Duration _wholesaleBannerCooldown = Duration(minutes: 2);
  Timer? _wholesaleBannerCooldownTimer;
  bool _wholesaleBannerOnCooldown = false;

  Timer? _maintenanceCheckTimer;

  void initDashboardTab(int? pageIndex, {required int mainTabCount, isUpdate = true}) {
    if (pageIndex == 5) {
      _currentMode = AppMode.auction;
      _selectedIndex = 0;
    } else if (pageIndex == 6) {
      _currentMode = AppMode.auction;
      _selectedIndex = 2;
    } else if (pageIndex != null && pageIndex < mainTabCount) {
      _selectedIndex = pageIndex;
    }
    if(isUpdate) {
      notifyListeners();
    }

  }

  void selectMainTab(int index) {
    _currentMode = AppMode.main;
    _selectedIndex = index;
    notifyListeners();
  }

  void enterAuctionTab() {
    _currentMode = AppMode.auction;
    _selectedIndex = 0;
    notifyListeners();
  }

  void selectAuctionTab(int index) {
    _currentMode = AppMode.auction;
    _selectedIndex = index;
    notifyListeners();
  }

  void enterWholesaleTab() {
    _currentMode = AppMode.wholesale;
    _selectedIndex = 0;
    notifyListeners();
  }

  void selectWholesaleTab(int index) {
    _currentMode = AppMode.wholesale;
    _selectedIndex = index;
    notifyListeners();
  }

  bool consumeAuctionBannerEligibility() {
    if (!AppConstants.demo || _auctionBannerOnCooldown) return false;
    _auctionBannerOnCooldown = true;
    _auctionBannerCooldownTimer?.cancel();
    _auctionBannerCooldownTimer = Timer(_auctionBannerCooldown, () {
      _auctionBannerOnCooldown = false;
    });
    return true;
  }

  bool consumeWholesaleBannerEligibility() {
    if (!AppConstants.demo || _wholesaleBannerOnCooldown) return false;
    _wholesaleBannerOnCooldown = true;
    _wholesaleBannerCooldownTimer?.cancel();
    _wholesaleBannerCooldownTimer = Timer(_wholesaleBannerCooldown, () {
      _wholesaleBannerOnCooldown = false;
    });
    return true;
  }

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;
  CurrencyList? _myCurrency;
  CurrencyList? _usdCurrency;
  CurrencyList? _defaultCurrency;
  int? _currencyIndex;
  bool _hasConnection = true;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool _onOff = true;
  bool get onOff => _onOff;
  bool isConfigCall = false;

  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;
  CurrencyList? get myCurrency => _myCurrency;
  CurrencyList? get usdCurrency => _usdCurrency;
  CurrencyList? get defaultCurrency => _defaultCurrency;
  int? get currencyIndex => _currencyIndex;
  bool get hasConnection => _hasConnection;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  BuildContext? _buildContext;

  List<BusinessPageModel>? _defaultBusinessPages;
  List<BusinessPageModel>? get defaultBusinessPages => _defaultBusinessPages;

  List<BusinessPageModel>? _businessPages;
  List<BusinessPageModel>? get businessPages => _businessPages;

  List<Faq>? _faqList;

  Future<void> getFaqList() async {
    final ApiResponseModel apiResponse = await splashServiceInterface!.getFaqList();
    if (apiResponse.response?.statusCode != 200) return;

    final dynamic data = apiResponse.response!.data;
    final List? rows = data is Map<String, dynamic> ? ApiListEnvelope.fromJson(data).data : null;
    if (rows == null) return;

    _faqList = <Faq>[
      for (final dynamic row in rows)
        if (row is Map) Faq.fromJson(Map<String, dynamic>.from(row)),
    ];
    _configModel?.faq = _faqList;
    notifyListeners();
  }

  Future<bool> initConfig(
    BuildContext context,
      Function(ConfigModel? configModel)? onLocalDataReceived,
      Function(ConfigModel? configModel)? onApiDataReceived,
      ) async {
    // final ThemeController themeController = Provider.of<ThemeController>(context, listen: false);

   var configLocalData =  await database.getCacheResponseById(AppConstants.configUri);

   bool localMaintainanceMode = false;

   isConfigCall = false;

   if(configLocalData != null) {
     _configModel = ConfigModel.fromJson(jsonDecode(configLocalData.response));
     _configModel?.faq ??= _faqList;

     localMaintainanceMode = (_configModel?.maintenanceModeData?.maintenanceStatus == 1 && _configModel?.maintenanceModeData?.selectedMaintenanceSystem?.customerApp == 1);

     String? currencyCode = splashServiceInterface!.getCurrency();

     for(CurrencyList currencyList in _configModel!.currencyList!) {
       if(currencyList.id == _configModel!.systemDefaultCurrency) {
         if(currencyCode == null || currencyCode.isEmpty) {
           currencyCode = currencyList.code;
         }
         _defaultCurrency = currencyList;
       }
       if(currencyList.code == 'USD') {
         _usdCurrency = currencyList;
       }
     }
     getCurrencyData(currencyCode);

     if(onLocalDataReceived != null) {
       onLocalDataReceived(configModel);
     }

   }

    _hasConnection = true;
    ApiResponseModel apiResponse = await splashServiceInterface!.getConfig();

    // _configModel = ConfigModel.fromJson(apiResponse.response!.data);
    bool isSuccess;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      isSuccess = true;
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      isConfigCall = true;

      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;

      _configModel?.hasLocaldb = configLocalData != null;

      _configModel?.localMaintenanceMode = localMaintainanceMode;

      if(onApiDataReceived != null) {
        onApiDataReceived(configModel);
      }


      String? currencyCode = splashServiceInterface!.getCurrency();

      try{
        await FirebaseMessaging.instance.getToken();
        await FirebaseMessaging.instance.subscribeToTopic(AppConstants.maintenanceModeTopic);
      }catch (e) {
        debugPrint("====FirebaseException===>>$e");
      }

      // themeController.setThemeColor(
      //   primaryColor: ColorHelper.hexCodeToColor(_configModel?.primaryColorCode),
      //   secondaryColor: ColorHelper.hexCodeToColor(_configModel?.secondaryColorCode),
      // );


      for(CurrencyList currencyList in _configModel!.currencyList!) {
        if(currencyList.id == _configModel!.systemDefaultCurrency) {
          if(currencyCode == null || currencyCode.isEmpty) {
            currencyCode = currencyList.code;
          }
          _defaultCurrency = currencyList;
        }
        if(currencyList.code == 'USD') {
          _usdCurrency = currencyList;
        }
      }
      getCurrencyData(currencyCode);

      if(_configModel?.maintenanceModeData?.maintenanceStatus == 0){
        if(_configModel?.maintenanceModeData?.selectedMaintenanceSystem?.customerApp == 1 ) {
          if(_configModel?.maintenanceModeData?.maintenanceTypeAndDuration?.maintenanceDuration == 'customize') {

            DateTime now = DateTime.now();
            DateTime specifiedDateTime = DateTime.parse(_configModel!.maintenanceModeData!.maintenanceTypeAndDuration!.startDate!);

            Duration difference = specifiedDateTime.difference(now);

            if(difference.inMinutes > 0 && (difference.inMinutes < 60 || difference.inMinutes == 60)){
              _startTimer(specifiedDateTime);
            }

          }
        }
      }

      if(configLocalData != null) {
        await database.updateCacheResponse(AppConstants.configUri, CacheResponseCompanion(
          endPoint: const Value(AppConstants.configUri),
          header: Value(jsonEncode(apiResponse.response!.headers.map)),
          response: Value(jsonEncode(apiResponse.response!.data)),
        ));
      } else {
        await database.insertCacheResponse(
          CacheResponseCompanion(
            endPoint: const Value(AppConstants.configUri),
            header: Value(jsonEncode(apiResponse.response!.headers.map)),
            response: Value(jsonEncode(apiResponse.response!.data)),
          ),
        );
      }
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);

      // v6 no longer embeds the FAQ in config. Every refresh above rebuilds the
      // model, so the list is carried over and fetched only the first time.
      _configModel?.faq ??= _faqList;
      if (_faqList == null) {
        getFaqList();
      }

      isSuccess = true;
    } else {
      isSuccess = false;
      if (apiResponse.response == null) {
        _hasConnection = false;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    }
    notifyListeners();

    return isSuccess;
  }


  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void getCurrencyData(String? currencyCode) {
    for (var currency in _configModel!.currencyList!) {
      if(currencyCode == currency.code) {
        _myCurrency = currency;
        _currencyIndex = _configModel!.currencyList!.indexOf(currency);
        continue;
      }
    }
  }

  Future<void> getBusinessPagesList(String type) async {
    ApiResponseModel apiResponse = await splashServiceInterface!.getBusinessPages(type);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      final List<BusinessPageModel> pages = _parseBusinessPages(apiResponse.response?.data);

      if(type == 'default') {
        _defaultBusinessPages = pages;
      } else {
        _businessPages = pages;
      }

    } else {
      ApiChecker.checkApi( apiResponse);
    }

    notifyListeners();
  }
  List<BusinessPageModel> _parseBusinessPages(dynamic data) {
    final List? rawPages = data is Map<String, dynamic>
        ? ApiListEnvelope.fromJson(data).data : (data is List ? data : null);

    return <BusinessPageModel>[
      ...?rawPages?.whereType<Map>().map((page) => BusinessPageModel.fromJson(Map<String, dynamic>.from(page))),
    ];
  }

  void setCurrency(int index) {
    splashServiceInterface!.setCurrency(_configModel!.currencyList![index].code!);
    getCurrencyData(_configModel!.currencyList![index].code);
    notifyListeners();
  }

  void initSharedPrefData() {
    splashServiceInterface!.initSharedData();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }

  bool? showIntro() {
    return splashServiceInterface!.showIntro();
  }

  void disableIntro() {
    splashServiceInterface!.disableIntro();
  }

  void changeAnnouncementOnOff(bool on){
    _onOff = !_onOff;
    notifyListeners();
  }


  void _startTimer (DateTime startTime) {
    _maintenanceCheckTimer?.cancel();
    _maintenanceCheckTimer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {

      DateTime now = DateTime.now();

      if (now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) {
        timer.cancel();
        RouterHelper.getMaintenanceRoute(action: RouteAction.pushReplacement);
      }

    });
  }

  void setMaintenanceContext(BuildContext context) {
    _buildContext = context;
  }

  void removeMaintenanceContext() {
    _buildContext = null;
  }

  bool isMaintenanceModeScreen() {
    if (_buildContext == null || configModel?.maintenanceModeData?.maintenanceStatus == 1) {
      return false;
    }
    return ModalRoute.of(_buildContext!)?.settings.name == 'MaintenanceScreen';
  }

  @override
  void dispose() {
    _auctionBannerCooldownTimer?.cancel();
    _wholesaleBannerCooldownTimer?.cancel();
    _maintenanceCheckTimer?.cancel();
    super.dispose();
  }

}
