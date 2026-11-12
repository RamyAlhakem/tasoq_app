import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';

class WholesaleWishlistPageModel {
  List<WholesaleProduct> wishList = [];
  int? totalSize;
  int? offset;

  WholesaleWishlistPageModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    wishList = [
      for (final Map row in (envelope.data ?? const []).whereType<Map>())
        WholesaleProduct.fromJson(Map<String, dynamic>.from(row)),
    ];
    totalSize = envelope.totalSize ?? wishList.length;
    offset = envelope.offset ?? 1;
  }
}
