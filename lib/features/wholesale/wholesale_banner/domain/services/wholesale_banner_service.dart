import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/domain/repositories/wholesale_banner_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/domain/services/wholesale_banner_service_interface.dart';

class WholesaleBannerService implements WholesaleBannerServiceInterface {
  final WholesaleBannerRepositoryInterface wholesaleBannerRepositoryInterface;
  WholesaleBannerService({required this.wholesaleBannerRepositoryInterface});

  @override
  Future getBannerList({int offset = 1, int limit = 25, String? bannerType}) async {
    return await wholesaleBannerRepositoryInterface.getBannerList(offset: offset, limit: limit, bannerType: bannerType);
  }
}
