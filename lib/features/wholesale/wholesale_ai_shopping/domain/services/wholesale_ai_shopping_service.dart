import 'dart:io';

import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_cart_selection_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_send_message_response_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/models/wholesale_ai_shopping_session_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/repositories/wholesale_ai_shopping_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_ai_shopping/domain/services/wholesale_ai_shopping_service_interface.dart';

class WholesaleAiShoppingService implements WholesaleAiShoppingServiceInterface {
  final WholesaleAiShoppingRepositoryInterface wholesaleAiShoppingRepositoryInterface;

  WholesaleAiShoppingService({required this.wholesaleAiShoppingRepositoryInterface});

  @override
  Future<WholesaleAiShoppingSessionModel> startSession({String? guestId}) =>
      wholesaleAiShoppingRepositoryInterface.startSession(guestId: guestId);

  @override
  Future<List<WholesaleAiShoppingSessionModel>> listSessions({String? guestId}) =>
      wholesaleAiShoppingRepositoryInterface.listSessions(guestId: guestId);

  @override
  Future<WholesaleAiShoppingSessionModel> getSession(int id, {String? guestId}) =>
      wholesaleAiShoppingRepositoryInterface.getSession(id, guestId: guestId);

  @override
  Future<void> deleteSession(int id, {String? guestId}) =>
      wholesaleAiShoppingRepositoryInterface.deleteSession(id, guestId: guestId);

  @override
  Future<WholesaleAiShoppingSendMessageResponse> sendMessage(
    int sessionId, {
    required String message,
    String? guestId,
    String? imageUrl,
    List<WholesaleAiShoppingCartSelection>? cartSelections,
  }) =>
      wholesaleAiShoppingRepositoryInterface.sendMessage(
        sessionId,
        message: message,
        guestId: guestId,
        imageUrl: imageUrl,
        cartSelections: cartSelections,
      );

  @override
  Future<String> uploadImage(File image, {String? guestId}) =>
      wholesaleAiShoppingRepositoryInterface.uploadImage(image, guestId: guestId);
}
