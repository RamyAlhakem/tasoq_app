import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleBannerRepositoryInterface extends RepositoryInterface {

  Future<dynamic> getBannerList({int offset = 1, int limit = 25, String? bannerType});
}
