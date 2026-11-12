import 'package:flutter_sixvalley_ecommerce/features/transaction/domain/models/commission_pay_request_model.dart';

abstract class TransactionServiceInterface {
  Future<dynamic> getWithdrawMethodList();

  Future<dynamic> payCommission({
    required CommissionPayRequestModel commissionPayRequest,
  });

  Future<dynamic> createWithdraw({
    required int auctionProductId,
    required int withdrawMethodId,
    double? amount,
    Map<String, dynamic>? methodInfo,
    String? transactionNote,
    String? currentCurrencyCode,
  });

  Future<dynamic> updateWithdraw({
    required int withdrawId,
    required int auctionProductId,
    required int withdrawMethodId,
    double? amount,
    Map<String, dynamic>? methodInfo,
    String? transactionNote,
    String? currentCurrencyCode,
  });
}