abstract class WholesaleRestockServiceInterface {
  Future<dynamic> getRestockRequestList({int? offset = 1});

  Future<dynamic> deleteRestockRequest({int? id, bool all = false});
}
