import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/repositories/wholesale_refund_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class WholesaleRefundRepository implements WholesaleRefundRepositoryInterface {
  final DioClient? dioClient;
  WholesaleRefundRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> submitRefundRequest({required int orderDetailsId, required String refundReason, List<XFile?> images = const []}) async {
    try {
      final Map<String, dynamic> fields = {
        'order_details_id': orderDetailsId,
        'refund_reason': refundReason,
      };

      final List<MultipartWithKey> files = [];
      for (final image in images) {
        if (image == null) continue;
        files.add(MultipartWithKey(
          key: 'images[]',
          multipartFile: MultipartFile.fromBytes(await image.readAsBytes(), filename: basename(image.path)),
        ));
      }

      final response = await dioClient!.postMultipart(AppConstants.wholesaleRefundRequestUri, data: fields, files: files);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getRefundEligibility(int orderDetailsId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleRefundEligibilityUri}$orderDetailsId');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getRefundResult(int orderDetailsId) async {
    try {
      final response = await dioClient!.get('${AppConstants.wholesaleRefundResultUri}$orderDetailsId');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
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
