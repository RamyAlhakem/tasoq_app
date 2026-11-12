import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'dart:io';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/repositories/review_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReviewRepository implements ReviewRepositoryInterface{
  final DioClient dioClient;
  ReviewRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> get(String productID, {int offset = 1, int limit = 10}) async {
    try {
      final response = await dioClient.get('${AppConstants.productReviewUri}$productID/reviews?limit=$limit&offset=$offset');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<http.StreamedResponse> submitReview(ReviewBody reviewBody, List<File> files, bool update) async {
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse(update
          ? '${AppConstants.baseUrl}${AppConstants.updateReviewUri}${reviewBody.id}' : '${AppConstants.baseUrl}${AppConstants.submitReviewUri}'),
    );
    request.headers.addAll(<String,String>{'Authorization': 'Bearer ${Provider.of<AuthController>(Get.context!, listen: false).getUserToken()}'});
    for(int index=0; index <files.length ; index++) {
      if(files[index].path.isNotEmpty) {
        request.files.add(http.MultipartFile(
          'fileUpload[$index]',
          files[index].readAsBytes().asStream(),
          files[index].lengthSync(),
          filename: files[index].path.split('/').last,
        ));
      }
    }
    if(update){
      request.fields.addAll(<String, String>{
        "order_id" : reviewBody.orderId!,
        'product_id': reviewBody.productId!,
        'comment': reviewBody.comment!,
        'rating': reviewBody.rating!});
    }else{
      request.fields.addAll(<String, String>{
        "order_id" : reviewBody.orderId?? "100264",
        'product_id': reviewBody.productId!,
        'comment': reviewBody.comment!,
        'rating': reviewBody.rating!});
    }

    http.StreamedResponse response = await request.send();
    return response;
  }

  @override
  Future<ApiResponseModel> getOrderWiseReview(String productID, String orderId) async {
    try {
      final response = await dioClient.get("${AppConstants.getOrderWiseReview}$orderId/products/$productID/review");
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e), responseValue: ApiErrorHandler.getResponse(e));
    }
  }

  @override
  Future<ApiResponseModel> deleteOrderWiseReviewImage(String id, String name) async {
    try {
      final response = await dioClient.post('${AppConstants.deleteOrderWiseReviewImage}$id/images', data: {'name': name});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getDeliveryManReview(String orderId) async {
    try {
      final response = await dioClient.get("${AppConstants.getDeliveryManReview}$orderId/deliveryman-review");
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> submitDeliveryManReview(String orderId, String comment, String rating) async {
    try {
      final response = await dioClient.post(
        '${AppConstants.submitDeliveryManReview}$orderId/deliveryman-review',
        data: {
          'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
          'comment': comment,
          'rating': rating,
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }


  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

}