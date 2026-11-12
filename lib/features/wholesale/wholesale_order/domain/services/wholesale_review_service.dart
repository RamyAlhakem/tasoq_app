import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/repositories/wholesale_review_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/services/wholesale_review_service_interface.dart';
import 'package:image_picker/image_picker.dart';

class WholesaleReviewService implements WholesaleReviewServiceInterface {
  final WholesaleReviewRepositoryInterface wholesaleReviewRepositoryInterface;
  WholesaleReviewService({required this.wholesaleReviewRepositoryInterface});

  @override
  Future getOrderProductReview({required int orderId, required int productId}) async {
    return await wholesaleReviewRepositoryInterface.getOrderProductReview(orderId: orderId, productId: productId);
  }

  @override
  Future submitReview({required int orderId, required int productId, required int rating, required String comment, List<XFile> images = const []}) async {
    return await wholesaleReviewRepositoryInterface.submitReview(orderId: orderId, productId: productId, rating: rating, comment: comment, images: images);
  }

  @override
  Future updateReview({required int reviewId, required int orderId, required int productId, required int rating, required String comment, List<XFile> images = const []}) async {
    return await wholesaleReviewRepositoryInterface.updateReview(reviewId: reviewId, orderId: orderId, productId: productId, rating: rating, comment: comment, images: images);
  }

  @override
  Future deleteReviewImage({required int reviewId, required String name}) async {
    return await wholesaleReviewRepositoryInterface.deleteReviewImage(reviewId: reviewId, name: name);
  }
}
