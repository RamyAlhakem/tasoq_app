import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleBrandRepositoryInterface extends RepositoryInterface {

  Future<dynamic> getBrandList({int offset = 1, int limit = 25});
}
