import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleCampaignRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getCampaignList({int offset = 1, int limit = 25});
  Future<dynamic> getCampaignDetails(String slug);
  Future<dynamic> getCampaignProducts(String slug, {int offset = 1, int limit = 10});
}
