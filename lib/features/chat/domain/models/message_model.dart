import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/domain/models/chat_model.dart';

class MessageModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Message>? message;

  MessageModel({this.totalSize, this.limit, this.offset, this.message});

  MessageModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['message']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      message = <Message>[];
      for (final dynamic v in envelope.data!) {
        if (v is Map) message!.add(Message.fromJson(Map<String, dynamic>.from(v)));
      }
    }
  }

}

class Message {
  int? id;
  String? message;
  bool? sentByCustomer;
  bool? sentBySeller;
  bool? sentByAdmin;
  bool? sentByDeliveryman;
  bool? seenByDeliveryMan;
  String? createdAt;
  DeliveryMan? deliveryMan;
  SellerInfo? sellerInfo;
  List<Attachment>? attachment;

  Message(
      {this.id,
        this.message,
        this.sentByCustomer,
        this.sentBySeller,
        this.sentByAdmin,
        this.sentByDeliveryman,
        this.seenByDeliveryMan,
        this.createdAt,
        this.deliveryMan,
        this.sellerInfo,
        this.attachment,
      });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    sentByCustomer = json['sent_by_customer'];
    sentBySeller = json['sent_by_seller'];
    sentByAdmin = json['sent_by_admin'];
    sentByDeliveryman = json['sent_by_delivery_man'];
    if(json['seen_by_delivery_man'] != null){
      seenByDeliveryMan = json['seen_by_delivery_man']??false;
    }

    createdAt = json['created_at'];
    deliveryMan = json['delivery_man'] != null ? DeliveryMan.fromJson(json['delivery_man']) : null;
    sellerInfo = json['seller_info'] != null ? SellerInfo.fromJson(json['seller_info']) : null;
    final dynamic attachments = json['attachment'] ?? json['attachment_full_url'];
    if (attachments is List) {
      attachment = <Attachment>[];
      for (final dynamic v in attachments) {
        if (v is Map) attachment!.add(Attachment.fromJson(Map<String, dynamic>.from(v)));
      }
    }
  }



}

class Attachment {
  String? type;
  String? key;
  String? path;
  String? size;

  Attachment({this.type, this.key, this.path, this.size});

  Attachment.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    path = json['path'];
    size = json['size']?.toString();
    type = json['type'] ?? _typeFromExtension(key ?? path);
  }

  static String? _typeFromExtension(String? name) {
    if (name == null || !name.contains('.')) return null;
    final String extension = name.split('?').first.split('.').last.toLowerCase();
    final bool isMedia = AppConstants.imageExtensions.contains(extension) || AppConstants.videoExtensions.contains(extension);
    return isMedia ? 'media' : 'file';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['key'] = key;
    data['path'] = path;
    data['size'] = size;
    return data;
  }
}


