import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class FlashDealRepositoryInterface implements RepositoryInterface{

  Future<dynamic> getFlashDeal({int offset = 1, int limit = 25});
  @override
  Future<dynamic> get(String dealId, {int offset = 1, int limit = 10});
}