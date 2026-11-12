import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/domain/repositories/wholesale_offers_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_offers/domain/services/wholesale_offers_service_interface.dart';

class WholesaleOffersService implements WholesaleOffersServiceInterface {
  final WholesaleOffersRepositoryInterface wholesaleOffersRepositoryInterface;

  WholesaleOffersService({required this.wholesaleOffersRepositoryInterface});

  @override
  Future getDiscountedProducts({required int offset, int limit = 10}) {
    return wholesaleOffersRepositoryInterface.getDiscountedProducts(offset: offset, limit: limit);
  }

  @override
  Future getPriceDropProducts({required int offset, int limit = 10}) {
    return wholesaleOffersRepositoryInterface.getPriceDropProducts(offset: offset, limit: limit);
  }

  @override
  Future getReducedMoqProducts({required int offset, int limit = 10}) {
    return wholesaleOffersRepositoryInterface.getReducedMoqProducts(offset: offset, limit: limit);
  }

  @override
  Future getTopDiscountedManufacturers({required int offset, int limit = 10, String search = ''}) {
    return wholesaleOffersRepositoryInterface.getTopDiscountedManufacturers(offset: offset, limit: limit, search: search);
  }

  @override
  Future getManufacturers({
    required String type,
    required int offset,
    int limit = 10,
    String search = '',
    int? categoryId,
    int? subCategoryId,
    int? subSubCategoryId,
    String? sortBy,
  }) {
    return wholesaleOffersRepositoryInterface.getManufacturers(
      type: type, offset: offset, limit: limit, search: search,
      categoryId: categoryId, subCategoryId: subCategoryId, subSubCategoryId: subSubCategoryId, sortBy: sortBy,
    );
  }
}
