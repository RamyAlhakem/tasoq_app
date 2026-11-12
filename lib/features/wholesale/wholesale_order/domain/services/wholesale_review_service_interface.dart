import 'package:image_picker/image_picker.dart';

abstract class WholesaleReviewServiceInterface {
  Future<dynamic> getOrderProductReview({required int orderId, required int productId});

  Future<dynamic> submitReview({required int orderId, required int productId, required int rating, required String comment, List<XFile> images = const []});

  Future<dynamic> updateReview({required int reviewId, required int orderId, required int productId, required int rating, required String comment, List<XFile> images = const []});

  Future<dynamic> deleteReviewImage({required int reviewId, required String name});
}
