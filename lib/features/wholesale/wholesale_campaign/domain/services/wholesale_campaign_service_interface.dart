abstract class WholesaleCampaignServiceInterface {
  Future<dynamic> getCampaignList({int offset = 1, int limit = 25});
  Future<dynamic> getCampaignDetails(String slug);
  Future<dynamic> getCampaignProducts(String slug, {int offset = 1, int limit = 10});
}
