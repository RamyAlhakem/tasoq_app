import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';
import 'package:image_picker/image_picker.dart';

abstract class WholesaleRefundRepositoryInterface extends RepositoryInterface {
  Future<dynamic> submitRefundRequest({required int orderDetailsId, required String refundReason, List<XFile?> images = const []});

  Future<dynamic> getRefundEligibility(int orderDetailsId);

  Future<dynamic> getRefundResult(int orderDetailsId);
}
