import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleAttributeRepositoryInterface extends RepositoryInterface {

  Future<dynamic> getAttributeList({int offset = 1, int limit = 25});
}
