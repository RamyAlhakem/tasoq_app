import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_product_review_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/services/wholesale_review_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/image_size_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:image_picker/image_picker.dart';

class WholesaleReviewController with ChangeNotifier {
  final WholesaleReviewServiceInterface wholesaleReviewServiceInterface;
  WholesaleReviewController({required this.wholesaleReviewServiceInterface});

  final Map<String, WholesaleProductReviewModel?> _reviews = {};
  final Set<String> _loadingKeys = {};
  final Set<String> _expandedKeys = {};

  int _rating = 0;
  int get rating => _rating;

  String? _errorText;
  String? get errorText => _errorText;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  List<XFile> reviewImages = [];

  static String _key(int orderId, int productId) => '$orderId-$productId';

  bool isReviewLoaded(int orderId, int productId) => _reviews.containsKey(_key(orderId, productId));

  bool isReviewLoadingFor(int orderId, int productId) => _loadingKeys.contains(_key(orderId, productId));

  WholesaleProductReviewModel? reviewFor(int orderId, int productId) => _reviews[_key(orderId, productId)];

  bool isExpanded(int orderId, int productId) => _expandedKeys.contains(_key(orderId, productId));

  void toggleExpanded(int orderId, int productId) {
    final String key = _key(orderId, productId);
    if (!_expandedKeys.remove(key)) _expandedKeys.add(key);
    notifyListeners();
  }

  Future<void> getReview(int orderId, int productId) async {
    final String key = _key(orderId, productId);
    _loadingKeys.add(key);
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleReviewServiceInterface.getOrderProductReview(orderId: orderId, productId: productId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic data = ApiEnvelope.content(apiResponse.response!.data)['data'];
      _reviews[key] = data is Map<String, dynamic> ? WholesaleProductReviewModel.fromJson(data) : null;
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _loadingKeys.remove(key);
    notifyListeners();
  }

  void initReviewForm(WholesaleProductReviewModel? review) {
    _rating = review?.rating ?? 0;
    _errorText = null;
    reviewImages = [];
  }

  void setRating(int rating) {
    _rating = rating;
    notifyListeners();
  }

  void setErrorText(String? error) {
    _errorText = error;
    notifyListeners();
  }

  void pickReviewImage() async {
    final XFile? image = await ImageValidationHelper.validateAndPickImage(source: ImageSource.gallery, context: Get.context!);
    if (image != null && File(image.path).existsSync()) {
      reviewImages.add(image);
    }
    notifyListeners();
  }

  void removeReviewImage(int index) {
    if (index >= 0 && index < reviewImages.length) {
      reviewImages.removeAt(index);
    }
    notifyListeners();
  }

  Future<ResponseModel> submitReview({required int orderId, required int productId, required String comment}) async {
    _isSubmitting = true;
    notifyListeners();

    final String key = _key(orderId, productId);
    final WholesaleProductReviewModel? existing = _reviews[key];
    final ApiResponseModel apiResponse = existing != null
        ? await wholesaleReviewServiceInterface.updateReview(reviewId: existing.id, orderId: orderId, productId: productId, rating: _rating, comment: comment, images: reviewImages)
        : await wholesaleReviewServiceInterface.submitReview(orderId: orderId, productId: productId, rating: _rating, comment: comment, images: reviewImages);

    final ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic data = ApiEnvelope.content(apiResponse.response!.data)['data'];
      if (data is Map<String, dynamic>) {
        _reviews[key] = WholesaleProductReviewModel.fromJson(data);
      }
      reviewImages = [];
      _rating = 0;
      _errorText = null;
      responseModel = ResponseModel(getTranslated('review_submitted_successfully', Get.context!), true);
    } else {
      responseModel = ResponseModel(apiResponse.error?.toString(), false);
    }

    _isSubmitting = false;
    notifyListeners();

    if (responseModel.isSuccess) getReview(orderId, productId);
    return responseModel;
  }

  Future<void> deleteReviewImage({required int orderId, required int productId, required String name}) async {
    final WholesaleProductReviewModel? review = _reviews[_key(orderId, productId)];
    if (review == null) return;

    final ApiResponseModel apiResponse = await wholesaleReviewServiceInterface.deleteReviewImage(reviewId: review.id, name: name);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      await getReview(orderId, productId);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }
}
