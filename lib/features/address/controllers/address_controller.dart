import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/label_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/restricted_country_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/restricted_zip_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/services/address_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';

class AddressController with ChangeNotifier {
  final AddressServiceInterface addressServiceInterface;
  AddressController({required this.addressServiceInterface});

  List<String> _restrictedCountryList = [];
  List<String> get restrictedCountryList =>_restrictedCountryList;
  List<RestrictedCountryModel> _restrictedCountries = [];
  List<RestrictedCountryModel> get restrictedCountries => _restrictedCountries;
  bool _isDeliveryCountryRestricted = false;
  bool get isDeliveryCountryRestricted => _isDeliveryCountryRestricted;
  List<RestrictedZipModel> _restrictedZipList =[];
  List<RestrictedZipModel> get restrictedZipList => _restrictedZipList;
  bool _isDeliveryZipRestricted = false;
  bool get isDeliveryZipRestricted => _isDeliveryZipRestricted;
  final List<String> _zipNameList = [];
  List<String> get zipNameList => _zipNameList;
  final TextEditingController _searchZipController = TextEditingController();
  TextEditingController get searchZipController => _searchZipController;
  final TextEditingController _searchCountryController = TextEditingController();
  TextEditingController get searchCountryController => _searchCountryController;
  List<AddressModel>? _addressList;
  List<AddressModel>? get addressList => _addressList;

  @override
  void dispose() {
    _searchZipController.dispose();
    _searchCountryController.dispose();
    super.dispose();
  }

  Future<void> getRestrictedDeliveryCountryList() async {
    ApiResponseModel apiResponse = await addressServiceInterface.getDeliveryRestrictedCountryList();
    if (apiResponse.response != null && _isSuccess(apiResponse.response!.statusCode)) {
      _setRestrictedCountries(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  void _setRestrictedCountries(dynamic data) {
    final RestrictedCountryList restricted = RestrictedCountryList.fromJson(Map<String, dynamic>.from(data is Map ? data : {'data': data}));
    _restrictedCountries = restricted.countries;
    _restrictedCountryList = restricted.names;
    _isDeliveryCountryRestricted = restricted.isRestricted;
  }


  Future<void> getRestrictedDeliveryZipList() async {
    ApiResponseModel apiResponse = await addressServiceInterface.getDeliveryRestrictedZipList();
    if (apiResponse.response != null && _isSuccess(apiResponse.response!.statusCode)) {
      _setRestrictedZips(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  void _setRestrictedZips(dynamic data) {
    final RestrictedZipList restricted = RestrictedZipList.fromJson(Map<String, dynamic>.from(data is Map ? data : {'data': data}));
    _restrictedZipList = restricted.zipCodes;
    _isDeliveryZipRestricted = restricted.isRestricted;
  }


  Future<void> getDeliveryRestrictedZipBySearch(String searchName) async {
    _restrictedZipList = [];
    ApiResponseModel response = await addressServiceInterface.getDeliveryRestrictedZipBySearch(searchName);
    if(response.response != null && _isSuccess(response.response!.statusCode)) {
      _setRestrictedZips(response.response!.data);
    }else {
      ApiChecker.checkApi(response);
    }
   notifyListeners();
  }


  Future<void> getDeliveryRestrictedCountryBySearch( String searchName) async {
    _restrictedCountryList = [];
    ApiResponseModel response = await addressServiceInterface.getDeliveryRestrictedCountryBySearch(searchName);
    if(response.response != null && _isSuccess(response.response!.statusCode)) {
      _setRestrictedCountries(response.response!.data);
    }else {
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  static const int addressPageLimit = 10;

  int _addressTotalSize = 0;
  int get addressTotalSize => _addressTotalSize;

  int _currentAddressOffset = 1;
  int get currentAddressOffset => _currentAddressOffset;

  bool _hasMoreAddress = false;
  bool get hasMoreAddress => _hasMoreAddress;

  bool _isLoadingAddressPage = false;
  bool get isLoadingAddressPage => _isLoadingAddressPage;

  Future<List<AddressModel>?> getAddressList({bool fromRemove = false, bool isShipping = false, bool isBilling = false, bool all = false, int? offset}) async {
    final int page = offset ?? 1;
    final bool isFirstPage = page == 1;

    if (isFirstPage) {
      _addressList = null;
      _hasMoreAddress = false;
    } else if (_isLoadingAddressPage || !_hasMoreAddress) {
      return _addressList;
    }

    _isLoadingAddressPage = true;

    final AddressListModel addressPage = await addressServiceInterface.getList(
      isShipping: isShipping, isBilling: isBilling, fromRemove: fromRemove, all: all, offset: page,
    );

    _addressList = isFirstPage ? addressPage.addresses : [...?_addressList, ...addressPage.addresses];
    _addressTotalSize = addressPage.totalSize ?? _addressList!.length;
    _currentAddressOffset = addressPage.offset ?? page;
    _hasMoreAddress = addressPage.hasMoreAfter(_addressList!.length);

    _isLoadingAddressPage = false;
    notifyListeners();
    return _addressList;
  }




  Future<void> deleteAddress(int id) async {
    ApiResponseModel apiResponse = await addressServiceInterface.delete(id);
    if (apiResponse.response != null && _isSuccess(apiResponse.response!.statusCode)) {
      showCustomSnackBarWidget(ApiEnvelope.message(apiResponse.response!.data), Get.context!, snackBarType: SnackBarType.success);
      getAddressList(fromRemove: true);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  static bool _isSuccess(int? statusCode) => statusCode == 200 || statusCode == 201 || statusCode == 204;

  Future<ApiResponseModel> addAddress(AddressModel addressModel) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await addressServiceInterface.add(addressModel);
    _isLoading = false;
    if (apiResponse.response != null && _isSuccess(apiResponse.response!.statusCode)) {
      showCustomSnackBarWidget(ApiEnvelope.message(apiResponse.response!.data), Get.context!, snackBarType: SnackBarType.success);
      getAddressList();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<void> updateAddress(BuildContext context, {required AddressModel addressModel, int? addressId}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await addressServiceInterface.update(addressModel.toJson(), addressId!);
    _isLoading = false;
    if (apiResponse.response != null && _isSuccess(apiResponse.response!.statusCode)) {
      Navigator.pop(Get.context!);
      getAddressList();
      showCustomSnackBarWidget(ApiEnvelope.message(apiResponse.response!.data), Get.context!, snackBarType: SnackBarType.success);
    }else {
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
  }

  void setZip(String zip){
    _searchZipController.text = zip;
    notifyListeners();
  }
  
  void setCountry(String country){
    _searchCountryController.text = country;
    notifyListeners();
  }

  


  List<LabelAsModel> addressTypeList = [];
  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;

  void updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  Future<List<LabelAsModel>> getAddressType() async {
    if (addressTypeList.isEmpty) {
      addressTypeList = [];
      addressTypeList = addressServiceInterface.getAddressType();
    }
    return addressTypeList;
  }

  void resetAddressList({bool isUpdate = true}) {
    _addressList = [];
    _addressTotalSize = 0;
    _currentAddressOffset = 1;
    _hasMoreAddress = false;
    if(isUpdate){
      notifyListeners();
    }
  }


}
