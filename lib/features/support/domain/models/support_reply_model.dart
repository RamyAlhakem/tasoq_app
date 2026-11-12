import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_ticket_model.dart';

class SupportReplyList {
  int? totalSize;
  int? limit;
  int? offset;
  int? lastPage;

  SupportTicketModel? ticket;
  List<SupportReplyModel> replies;

  SupportReplyList({this.totalSize, this.limit, this.offset, this.lastPage, this.ticket, List<SupportReplyModel>? replies})
      : replies = replies ?? <SupportReplyModel>[];

  SupportReplyList.fromJson(Map<String, dynamic> json) : replies = <SupportReplyModel>[] {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: const ['conversations']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    lastPage = envelope.lastPage;

    final dynamic ticketJson = envelope.read('ticket');
    if (ticketJson is Map) {
      ticket = SupportTicketModel.fromJson(Map<String, dynamic>.from(ticketJson));
    }

    for (final dynamic reply in envelope.data ?? const []) {
      if (reply is Map) {
        replies.add(SupportReplyModel.fromJson(Map<String, dynamic>.from(reply)));
      }
    }
  }

  bool get hasNextPage => lastPage != null && offset != null && offset! < lastPage!;
}

class SupportReplyModel {
  int? id;
  int? supportTicketId;

  String? message;

  String? sentBy;
  String? customerMessage;
  String? adminMessage;
  String? createdAt;
  String? updatedAt;
  List<String>? attachment;
  List<ImageFullUrl>? attachmentFullUrl;
  String? adminId;

  SupportReplyModel(
      {this.id,
        this.supportTicketId,
        this.message,
        this.sentBy,
        this.customerMessage,
        this.adminMessage,
        this.createdAt,
        this.updatedAt,
        this.attachment,
        this.adminId,
        this.attachmentFullUrl
      });

  SupportReplyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supportTicketId = json['support_ticket_id'];
    customerMessage = json['customer_message'];
    adminMessage = json['admin_message'];
    message = json['message'] ?? customerMessage ?? adminMessage;
    sentBy = json['sent_by']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminId = json['admin_id']?.toString();
    if(json['attachment'] != null && json['attachment'] is !String){
      attachment = json['attachment'].cast<String>();
    }else{
      attachment = [];
    }
    if (json['attachment_full_url'] is List) {
      attachmentFullUrl = <ImageFullUrl>[];
      json['attachment_full_url'].forEach((v) {
        attachmentFullUrl!.add(ImageFullUrl.fromJson(v));
      });
    }
  }

  bool get isSentByCustomer {
    final String? by = sentBy?.toLowerCase();
    if (by != null && by.isNotEmpty) return by != 'admin';
    return customerMessage != null;
  }
}
