abstract class WholesaleBannerServiceInterface {

  Future<dynamic> getBannerList({int offset = 1, int limit = 25, String? bannerType});
}
