import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_wishlist/domain/repositories/wholesale_wishlist_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_wishlist/domain/services/wholesale_wishlist_service_interface.dart';

class WholesaleWishlistService implements WholesaleWishlistServiceInterface{
  WholesaleWishlistRepositoryInterface wholesaleWishlistRepositoryInterface;

  WholesaleWishlistService({required this.wholesaleWishlistRepositoryInterface});

  @override
  Future add(int productID) async{
    return await wholesaleWishlistRepositoryInterface.add(productID);
  }

  @override
  Future delete(int productID) async{
    return await wholesaleWishlistRepositoryInterface.delete(productID);
  }

  @override
  Future getList({int? offset = 1}) async{
    return await wholesaleWishlistRepositoryInterface.getList(offset: offset);
  }

  @override
  Future getWishList({int? offset = 1, String? search = ''}) async{
    return await wholesaleWishlistRepositoryInterface.getWishList(offset: offset, search: search);
  }

}
