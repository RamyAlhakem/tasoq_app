import 'dart:convert';

import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_reply_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_ticket_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_ticket_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/services/support_ticket_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/helper/image_size_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SupportTicketController extends ChangeNotifier {
  final SupportTicketServiceInterface supportTicketServiceInterface;
  SupportTicketController({required this.supportTicketServiceInterface});

  List<SupportTicketModel>? _supportTicketList;
  List<SupportReplyModel>? _supportReplyList;
  bool _isLoading = false;

  int? _ticketTotalSize;
  int? _ticketOffset;
  int? _ticketLimit;

  List<SupportTicketModel>? get supportTicketList => _supportTicketList;

  int? get ticketTotalSize => _ticketTotalSize;
  int? get ticketOffset => _ticketOffset;
  int? get ticketLimit => _ticketLimit;

  int? _replyTotalSize;
  int? _replyOffset;
  int? _replyLimit;
  SupportTicketModel? _conversationTicket;

  int? get replyTotalSize => _replyTotalSize;
  int? get replyOffset => _replyOffset;
  int? get replyLimit => _replyLimit;

  SupportTicketModel? get conversationTicket => _conversationTicket;
  List<SupportReplyModel>? get supportReplyList => _supportReplyList != null ? _supportReplyList!.reversed.toList() : _supportReplyList;
  bool get isLoading => _isLoading;



  Future<http.StreamedResponse> createSupportTicket(SupportTicketBody supportTicketBody) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await supportTicketServiceInterface.createNewSupportTicket(supportTicketBody ,pickedImageFileStored);
    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBarWidget(getTranslated('support_ticket_created_successfully', Get.context!), Get.context!, snackBarType: SnackBarType.success);
      Navigator.pop(Get.context!);
      getSupportTicketList();
      _pickedImageFiles = [];
      pickedImageFileStored = [];
      _isLoading = false;
    } else {
      showCustomSnackBarWidget(await _errorMessage(response), Get.context!, snackBarType: SnackBarType.error);
      _isLoading = false;

    }
    _pickedImageFiles = [];
    pickedImageFileStored = [];
    _isLoading = false;
    notifyListeners();
    return response;
  }

  Future<String> _errorMessage(http.StreamedResponse response) async {
    try {
      final dynamic body = jsonDecode(await response.stream.bytesToString());
      final dynamic errors = body is Map ? body['errors'] : null;
      if (errors is List && errors.isNotEmpty) {
        return '${errors.first['message']}';
      }
      return ApiEnvelope.message(body) ?? response.reasonPhrase ?? '';
    } catch (_) {
      return response.reasonPhrase ?? '';
    }
  }

  Future<void> getSupportTicketList({int offset = 1}) async {
    ApiResponseModel apiResponse = await supportTicketServiceInterface.getList(offset: offset);
    final int? statusCode = apiResponse.response?.statusCode;
    if (statusCode != null && (statusCode == 200 || statusCode == 201)) {
      final SupportTicketList tickets = SupportTicketList.fromJson(
          Map<String, dynamic>.from(apiResponse.response!.data is Map ? apiResponse.response!.data : {'data': apiResponse.response!.data}));
      _supportTicketList = offset > 1 ? [...?_supportTicketList, ...tickets.tickets] : tickets.tickets;
      _ticketTotalSize = tickets.totalSize;
      _ticketOffset = tickets.offset ?? offset;
      _ticketLimit = tickets.limit;
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  Future<void> getSupportTicketReplyList(BuildContext context, int? ticketID, {int offset = 1, bool reload = true}) async {
    if (offset == 1 && reload) {
      _supportReplyList = null;
      notifyListeners();
    }
    ApiResponseModel apiResponse = await supportTicketServiceInterface.getSupportReplyList(ticketID.toString(), offset: offset);
    final int? statusCode = apiResponse.response?.statusCode;
    if (statusCode != null && (statusCode == 200 || statusCode == 201)) {
      final SupportReplyList replies = SupportReplyList.fromJson(
          Map<String, dynamic>.from(apiResponse.response!.data is Map ? apiResponse.response!.data : {'data': apiResponse.response!.data}));
      _supportReplyList = offset > 1 ? _mergeReplies(_supportReplyList, replies.replies) : replies.replies;
      _conversationTicket = replies.ticket ?? _conversationTicket;
      _replyTotalSize = replies.totalSize;
      _replyOffset = replies.offset ?? offset;
      _replyLimit = replies.limit;
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  List<SupportReplyModel> _mergeReplies(List<SupportReplyModel>? existing, List<SupportReplyModel> incoming) {
    final Map<int, SupportReplyModel> byId = <int, SupportReplyModel>{};
    final List<SupportReplyModel> withoutId = <SupportReplyModel>[];
    for (final SupportReplyModel reply in [...?existing, ...incoming]) {
      if (reply.id != null) {
        byId[reply.id!] = reply;
      } else {
        withoutId.add(reply);
      }
    }
    final List<SupportReplyModel> merged = byId.values.toList()
      ..sort((SupportReplyModel a, SupportReplyModel b) => a.id!.compareTo(b.id!));
    return merged..addAll(withoutId);
  }




  Future<http.StreamedResponse> sendReply(int? ticketID, String message) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await supportTicketServiceInterface.sendReply(ticketID.toString(), message, pickedImageFileStored);
    if (response.statusCode == 200 || response.statusCode == 201) {
      getSupportTicketReplyList(Get.context!, ticketID, reload: false);
      _pickedImageFiles = [];
      pickedImageFileStored = [];
      _isLoading = false;
    } else {
      showCustomSnackBarWidget(await _errorMessage(response), Get.context!, snackBarType: SnackBarType.error);
      _isLoading = false;
    }
    _pickedImageFiles = [];
    pickedImageFileStored = [];
    _isLoading = false;
    notifyListeners();
    return response;
  }


  Future<void> closeSupportTicket(int? ticketID) async {
    ApiResponseModel apiResponse = await supportTicketServiceInterface.closeSupportTicket(ticketID.toString());
    final int? statusCode = apiResponse.response?.statusCode;
    if (statusCode != null && (statusCode == 200 || statusCode == 201)) {
      getSupportTicketList();
      showCustomSnackBarWidget(getTranslated('ticket_closed_successfully', Get.context!), Get.context!, snackBarType: SnackBarType.success);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }



  List<String> priority = ['urgent', 'high', 'medium', 'low'];
  int selectedPriorityIndex = -1;
  String selectedPriority = getTranslated('select_priority', Get.context!) ?? '';
  String selectedPriorityEn = '';

  void setInitialSelectedPriority(){
    selectedPriority = getTranslated('select_priority', Get.context!) ?? '';
    selectedPriorityIndex = -1;
    selectedPriorityEn = '';
  }

  void setSelectedPriority(int index, {bool reload = true}){
    selectedPriorityIndex = index;
    selectedPriority = getTranslated(priority[selectedPriorityIndex], Get.context!) ?? 'High';
    selectedPriorityEn = priority[selectedPriorityIndex];
    notifyListeners();
  }

  List <XFile> _pickedImageFiles =[];
  List <XFile>? get pickedImageFile => _pickedImageFiles;
  List <XFile>  pickedImageFileStored = [];
  void pickMultipleImage(bool isRemove,{int? index}) async {
    if(isRemove) {
      if(index != null){
        pickedImageFileStored.removeAt(index);
      }
    }else {
      _pickedImageFiles = await ImageValidationHelper.validateAndPickMultipleImages(
        context: Get.context!,
      );


      for(XFile image in _pickedImageFiles){
        pickedImageFileStored.add(image);
      }
    }
    notifyListeners();
  }
}
