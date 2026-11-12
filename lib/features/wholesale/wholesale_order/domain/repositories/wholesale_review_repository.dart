import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/repositories/wholesale_review_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class WholesaleReviewRepository implements WholesaleReviewRepositoryInterface {
  final DioClient? dioClient;
  WholesaleReviewRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getOrderProductReview({required int orderId, required int productId}) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleOrderProductReviewUri}$orderId/products/$productId/review');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> submitReview({required int orderId, required int productId, required int rating, required String comment, List<XFile> images = const []}) async {
    try {
      final FormData formData = await _reviewFormData(orderId: orderId, productId: productId, rating: rating, comment: comment, images: images);
      final response = await dioClient!.post(AppConstants.wholesaleReviewUri, data: formData);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> updateReview({required int reviewId, required int orderId, required int productId, required int rating, required String comment, List<XFile> images = const []}) async {
    try {
      final FormData formData = await _reviewFormData(orderId: orderId, productId: productId, rating: rating, comment: comment, images: images);
      final response = await dioClient!.post('${AppConstants.wholesaleReviewUri}/$reviewId', data: formData);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> deleteReviewImage({required int reviewId, required String name}) async {
    try {
      final response = await dioClient!.post('${AppConstants.wholesaleReviewUri}/$reviewId/images', queryParameters: {'name': name});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<FormData> _reviewFormData({required int orderId, required int productId, required int rating, required String comment, required List<XFile> images}) async {
    final FormData formData = FormData.fromMap({
      'order_id': orderId,
      'product_id': productId,
      'rating': rating,
      'comment': comment,
    });
    for (final XFile image in images) {
      formData.files.add(MapEntry('fileUpload[]', MultipartFile.fromBytes(await image.readAsBytes(), filename: basename(image.path))));
    }
    return formData;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    throw UnimplementedError();
  }
}
