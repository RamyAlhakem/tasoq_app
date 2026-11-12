import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/repositories/wholesale_refund_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/services/wholesale_refund_service_interface.dart';
import 'package:image_picker/image_picker.dart';

class WholesaleRefundService implements WholesaleRefundServiceInterface {
  final WholesaleRefundRepositoryInterface wholesaleRefundRepositoryInterface;
  WholesaleRefundService({required this.wholesaleRefundRepositoryInterface});

  @override
  Future submitRefundRequest({required int orderDetailsId, required String refundReason, List<XFile?> images = const []}) async {
    return await wholesaleRefundRepositoryInterface.submitRefundRequest(orderDetailsId: orderDetailsId, refundReason: refundReason, images: images);
  }

  @override
  Future getRefundEligibility(int orderDetailsId) async {
    return await wholesaleRefundRepositoryInterface.getRefundEligibility(orderDetailsId);
  }

  @override
  Future getRefundResult(int orderDetailsId) async {
    return await wholesaleRefundRepositoryInterface.getRefundResult(orderDetailsId);
  }
}
