import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/ai_shopping/domain/models/ai_shopping_cart_selection_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/ai_shopping/domain/models/ai_shopping_send_message_response_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/ai_shopping/domain/models/ai_shopping_session_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/ai_shopping/domain/repository/ai_shopping_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class AiShoppingRepository implements AiShoppingRepositoryInterface {
  final DioClient? dioClient;

  AiShoppingRepository({required this.dioClient});

  @override
  Future<AiShoppingSessionModel> startSession({String? guestId}) async {
    final Map<String, dynamic> body = {};
    if (guestId != null) body['guest_id'] = guestId;
    final response = await dioClient!.post(AppConstants.aiShoppingSessions, data: body);
    return AiShoppingSessionModel.fromJson(_session(response.data));
  }

  static Map<String, dynamic> _session(dynamic body) {
    final dynamic session = ApiEnvelope.content(body)['session'];
    return session is Map ? Map<String, dynamic>.from(session) : <String, dynamic>{};
  }

  @override
  Future<List<AiShoppingSessionModel>> listSessions({String? guestId}) async {
    final Map<String, dynamic> params = {};
    if (guestId != null) params['guest_id'] = guestId;
    final response = await dioClient!.get(AppConstants.aiShoppingSessions, queryParameters: params);
    final dynamic sessions = ApiEnvelope.content(response.data)['sessions'];

    return [
      for (final Map session in (sessions is List ? sessions : const []).whereType<Map>())
        AiShoppingSessionModel.fromJson(Map<String, dynamic>.from(session)),
    ];
  }

  @override
  Future<AiShoppingSessionModel> getSession(int id, {String? guestId}) async {
    final Map<String, dynamic> params = {};
    if (guestId != null) params['guest_id'] = guestId;
    final response = await dioClient!.get('${AppConstants.aiShoppingSessions}/$id', queryParameters: params);

    return AiShoppingSessionModel.fromJson(_session(response.data));
  }

  @override
  Future<void> deleteSession(int id, {String? guestId}) async {
    final Map<String, dynamic> params = {};
    if (guestId != null) params['guest_id'] = guestId;
    await dioClient!.delete('${AppConstants.aiShoppingSessions}/$id', data: params);
  }

  @override
  Future<AiShoppingSendMessageResponse> sendMessage(
    int sessionId, {
    required String message,
    String? guestId,
    String? imageUrl,
    List<AiShoppingCartSelection>? cartSelections,
  }) async {
    final Map<String, dynamic> body = {'message': message};
    if (guestId != null) body['guest_id'] = guestId;
    if (imageUrl != null) body['image_url'] = imageUrl;
    if (cartSelections != null && cartSelections.isNotEmpty) {
      body['cart_selections'] = cartSelections.map((e) => e.toJson()).toList();
    }
    final response = await dioClient!.post('${AppConstants.aiShoppingSessions}/$sessionId/message', data: body);
    return AiShoppingSendMessageResponse.fromJson(Map<String, dynamic>.from(ApiEnvelope.content(response.data)));
  }

  @override
  Future<String> uploadImage(File image, {String? guestId}) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path),
      if (guestId != null) 'guest_id': guestId,
    });
    final response = await dioClient!.post(AppConstants.aiShoppingUploadImage, data: formData);
    return ApiEnvelope.content(response.data)['url']?.toString() ?? '';
  }
}
