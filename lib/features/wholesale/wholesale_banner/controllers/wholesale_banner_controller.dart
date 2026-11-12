import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/domain/models/wholesale_banner_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/domain/services/wholesale_banner_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:url_launcher/url_launcher.dart';

class WholesaleBannerController extends ChangeNotifier {
  final WholesaleBannerServiceInterface wholesaleBannerServiceInterface;

  WholesaleBannerController({required this.wholesaleBannerServiceInterface});

  static const String _allTypesKey = '';

  final Map<String, List<WholesaleBanner>> _bannersByType = {};
  final Map<String, WholesaleBannerResponseModel> _responseByType = {};
  final Set<String> _loadingTypes = {};

  List<WholesaleBanner>? get banners => bannersOf(null);
  WholesaleBannerResponseModel? get bannerResponseModel => _responseByType[_allTypesKey];
  bool get isLoading => isLoadingOf(null);

  List<WholesaleBanner>? bannersOf(String? bannerType) => _bannersByType[bannerType ?? _allTypesKey];

  bool isLoadingOf(String? bannerType) => _loadingTypes.contains(bannerType ?? _allTypesKey);

  Future<void> getBannerList({bool reload = false, int offset = 1, int limit = 25, String? bannerType}) async {
    final String key = bannerType ?? _allTypesKey;
    if (_loadingTypes.contains(key)) return;
    if (offset == 1 && _bannersByType.containsKey(key) && !reload) return;

    _loadingTypes.add(key);
    if (offset == 1 && reload) {
      _bannersByType.remove(key);
    }
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleBannerServiceInterface.getBannerList(
      offset: offset, limit: limit, bannerType: bannerType,
    );

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleBannerResponseModel parsed = WholesaleBannerResponseModel.fromJson(apiResponse.response?.data);

      _bannersByType[key] = offset == 1 ? (parsed.banners ?? []) : [...?_bannersByType[key], ...?parsed.banners];
      _responseByType[key] = parsed;
    } else {
      _bannersByType[key] ??= [];
      ApiChecker.checkApi(apiResponse);
    }

    _loadingTypes.remove(key);
    notifyListeners();
  }

  void clickBannerRedirect(WholesaleBanner? banner) {
    if (banner == null) return;

    final String? type = banner.resourceType;
    final int? id = banner.resource?.id ?? banner.resourceId;
    final String? slug = banner.resource?.slug;

    if (type == 'custom') {
      final String? url = banner.url;
      if (url != null && url.isNotEmpty) {
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }

    } else if (type == 'product') {
      if (slug != null && slug.isNotEmpty) {
        RouterHelper.getWholesaleProductDetailsRoute(action: RouteAction.push, slug: slug);
      }

    } else if (type == 'shop') {
      if (slug != null && slug.isNotEmpty) {
        RouterHelper.getWholesaleShopRoute(action: RouteAction.push, slug: slug, shopId: id, shopName: banner.resource?.name);
      }

    } else if (type == 'category') {
      if (id != null) {
        RouterHelper.getWholesaleCategoryScreenRoute(action: RouteAction.push, initialCategoryId: id);
      }

    } else if (type == 'brand') {
      if (id != null) {
        RouterHelper.getWholesaleBrandProductsScreenRoute(action: RouteAction.push, brandId: id, brandName: banner.resource?.name);
      }
    }
  }
}
