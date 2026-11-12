import 'package:flutter/foundation.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_wishlist/domain/models/wholesale_wishlist_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_wishlist/domain/services/wholesale_wishlist_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';

class WholesaleWishlistController extends ChangeNotifier {
  final WholesaleWishlistServiceInterface? wholesaleWishlistServiceInterface;
  WholesaleWishlistController({required this.wholesaleWishlistServiceInterface});

  final bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<WholesaleProduct>? _wishList;
  List<WholesaleProduct>? get wishList => _wishList;
  int? _totalSize;
  int? get totalSize => _totalSize;
  int? _offset;
  int? get offset => _offset;
  List<int> addedIntoWish = [];


  void addWishList(int? productID) async {
    addedIntoWish.add(productID!);
    ApiResponseModel apiResponse = await wholesaleWishlistServiceInterface!.add(productID);
    if (apiResponse.response != null && (apiResponse.response!.statusCode == 200 || apiResponse.response!.statusCode == 201)) {
      showCustomSnackBarWidget(getTranslated("successfully_added_to_wishlist", Get.context!), Get.context!, snackBarType: SnackBarType.success);
    } else {
      showCustomSnackBarWidget(apiResponse.error.toString(), Get.context!, snackBarType: SnackBarType.warning);
    }
    notifyListeners();
  }

  void removeWishList(int? productID, {int? index}) async {
    addedIntoWish.remove(productID!);
    ApiResponseModel apiResponse = await wholesaleWishlistServiceInterface!.delete(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getWishList('');
      showCustomSnackBarWidget(getTranslated("successfully_removed_from_wishlist", Get.context!), Get.context!, snackBarType: SnackBarType.success);
    } else {
      showCustomSnackBarWidget(apiResponse.error.toString(), Get.context!, snackBarType: SnackBarType.warning);
    }
    notifyListeners();
  }

  Future<void> getWishList(String searchText, {bool clearSearch = false, int offset = 1}) async {
    if(clearSearch) {
      _wishList = null;
      notifyListeners();
    }
    ApiResponseModel apiResponse = await wholesaleWishlistServiceInterface!.getWishList(offset: offset, search: searchText);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final WholesaleWishlistPageModel page = WholesaleWishlistPageModel.fromJson(apiResponse.response?.data);
      final List<int> pageProductIds = page.wishList.map((product) => product.id).whereType<int>().toList();

      if (offset == 1) {
        _wishList = page.wishList;
      } else {
        _wishList = [...?_wishList, ...page.wishList];
      }
      _totalSize = page.totalSize;
      _offset = page.offset;

      if (offset == 1 && searchText.isEmpty) {
        addedIntoWish = pageProductIds;
      } else {
        addedIntoWish.addAll(pageProductIds.where((id) => !addedIntoWish.contains(id)));
      }
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  void emptyWishList() {
    _wishList = [];
    _totalSize = null;
    _offset = null;
    addedIntoWish = [];
    notifyListeners();
  }

}
