import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleOffersRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getDiscountedProducts({required int offset, int limit = 10});

  Future<dynamic> getPriceDropProducts({required int offset, int limit = 10});

  Future<dynamic> getReducedMoqProducts({required int offset, int limit = 10});

  Future<dynamic> getTopDiscountedManufacturers({required int offset, int limit = 10, String search = ''});

  Future<dynamic> getManufacturers({
    required String type,
    required int offset,
    int limit = 10,
    String search = '',
    int? categoryId,
    int? subCategoryId,
    int? subSubCategoryId,
    String? sortBy,
  });
}
