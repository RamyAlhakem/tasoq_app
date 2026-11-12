import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WholesaleRestockRepositoryInterface implements RepositoryInterface<int> {
  Future<ApiResponseModel> getRestockRequestList({int? offset = 1});

  Future<ApiResponseModel> deleteRestockRequest({int? id, bool all = false});
}
