import 'package:image_picker/image_picker.dart';

abstract class WholesaleRefundServiceInterface {
  Future<dynamic> submitRefundRequest({required int orderDetailsId, required String refundReason, List<XFile?> images = const []});

  Future<dynamic> getRefundEligibility(int orderDetailsId);

  Future<dynamic> getRefundResult(int orderDetailsId);
}
