
abstract class FlashDealServiceInterface {

  Future<dynamic> getFlashDeal({int offset = 1, int limit = 25});
  Future<dynamic> get(String dealId, {int offset = 1, int limit = 10});

}