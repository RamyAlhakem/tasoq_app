import 'dart:io';

import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_cart_selection_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_send_message_response_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_session_model.dart';

abstract class WholesaleAiShoppingRepositoryInterface {
  Future<WholesaleAiShoppingSessionModel> startSession({String? guestId});
  Future<List<WholesaleAiShoppingSessionModel>> listSessions({String? guestId});
  Future<WholesaleAiShoppingSessionModel> getSession(int id, {String? guestId});
  Future<void> deleteSession(int id, {String? guestId});
  Future<WholesaleAiShoppingSendMessageResponse> sendMessage(
    int sessionId, {
    required String message,
    String? guestId,
    String? imageUrl,
    List<WholesaleAiShoppingCartSelection>? cartSelections,
  });
  Future<String> uploadImage(File image, {String? guestId});
}
