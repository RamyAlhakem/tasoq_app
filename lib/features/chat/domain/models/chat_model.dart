import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/enums/vacation_duration_type.dart';

class ChatModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Chat>? chat;

  ChatModel({this.totalSize, this.limit, this.offset, this.chat});

  ChatModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['chat']);
    totalSize = envelope.totalSize;
    limit = envelope.limit?.toString();
    offset = envelope.offset?.toString();
    if (envelope.data != null) {
      chat = <Chat>[];
      for (final dynamic v in envelope.data!) {
        if (v is Map) chat!.add(Chat.fromJson(Map<String, dynamic>.from(v)));
      }
    }
  }
}

class Chat {
  int? id;
  int? userId;
  int? sellerId;
  int? adminId;
  int? deliveryManId;
  String? message;
  bool? sentByCustomer;
  bool? sentBySeller;
  bool? sentByAdmin;
  bool? sentByDeliveryMan;
  bool? seenByCustomer;
  String? createdAt;
  String? updatedAt;
  SellerInfo? sellerInfo;
  DeliveryMan? deliveryMan;
  int? unseenMessageCount;

  Chat(
      {this.id,
        this.userId,
        this.sellerId,
        this.adminId,
        this.deliveryManId,
        this.message,
        this.sentByCustomer,
        this.sentBySeller,
        this.sentByAdmin,
        this.sentByDeliveryMan,
        this.seenByCustomer,
        this.createdAt,
        this.updatedAt,
        this.sellerInfo,
        this.deliveryMan,
        this.unseenMessageCount,
      });

  Chat.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? counterparty = json['counterparty'] is Map ? Map<String, dynamic>.from(json['counterparty']) : null;
    final String? counterpartyType = counterparty?['type']?.toString();
    final dynamic counterpartyId = counterparty == null ? null : counterparty['id'];

    id = json['id'];
    userId = json['user_id'];
    sellerId = json['seller_id'] ?? (counterpartyType == 'seller' ? counterpartyId : null);
    adminId = json['admin_id'] ?? (counterpartyType == 'admin' ? counterpartyId : null);
    final dynamic rawDeliveryManId = json['delivery_man_id'] ?? (counterpartyType == 'delivery-man' ? counterpartyId : null);
    if(rawDeliveryManId != null){
      deliveryManId = int.tryParse(rawDeliveryManId.toString());
    }

    message = json['message'] ?? json['last_message'];
    sentByCustomer = json['sent_by_customer'];
    sentBySeller = json['sent_by_seller'];
    sentByAdmin = json['sent_by_admin'];
    sentByDeliveryMan = json['sent_by_delivery_man'];
    seenByCustomer = json['seen_by_customer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sellerInfo = json['seller_info'] != null ? SellerInfo.fromJson(json['seller_info'])
        : (counterpartyType == 'seller' || counterpartyType == 'admin' ? SellerInfo.fromCounterparty(counterparty!) : null);
    deliveryMan = json['delivery_man'] != null ? DeliveryMan.fromJson(json['delivery_man'])
        : (counterpartyType == 'delivery-man' ? DeliveryMan.fromCounterparty(counterparty!) : null);
    unseenMessageCount = json['unseen_message_count'];

  }

}


class SellerInfo {
  List<Shops>? shops;

  SellerInfo(
      {this.shops});

  SellerInfo.fromJson(Map<String, dynamic> json) {
    if (json['shops'] != null) {
      shops = <Shops>[];
      json['shops'].forEach((v) {
        shops!.add(Shops.fromJson(v));
      });
    }
  }

  SellerInfo.fromCounterparty(Map<String, dynamic> counterparty) : shops = <Shops>[Shops.fromJson(counterparty)];

}

class Shops {
  int? id;
  int? sellerId;
  String? name;
  String? address;
  String? contact;
  String? image;
  ImageFullUrl? imageFullUrl;
  String? bottomBanner;
  String? offerBanner;
  String? vacationStartDate;
  String? vacationEndDate;
  String? vacationNote;
  bool? vacationStatus;
  bool? temporaryClose;
  String? createdAt;
  String? updatedAt;
  String? banner;
  VacationDurationType? vacationDurationType;

  Shops(
      {this.id,
        this.sellerId,
        this.name,
        this.address,
        this.contact,
        this.image,
        this.imageFullUrl,
        this.bottomBanner,
        this.offerBanner,
        this.vacationStartDate,
        this.vacationEndDate,
        this.vacationNote,
        this.vacationStatus,
        this.temporaryClose,
        this.createdAt,
        this.updatedAt,
        this.banner,
        this.vacationDurationType,
      });

  Shops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = int.tryParse(json['seller_id'].toString());
    name = json['name'];
    address = json['address'];
    contact = json['contact'];
    image = json['image'];
    if (json['image_full_url'] != null) {
      imageFullUrl = ImageFullUrl.fromJson(json['image_full_url']);
    }
    bottomBanner = json['bottom_banner'];
    offerBanner = json['offer_banner'];
    vacationStartDate = json['vacation_start_date'];
    vacationEndDate = json['vacation_end_date'];
    vacationNote = json['vacation_note'];
    if(json['vacation_status'] != null){
      vacationStatus = '${json['vacation_status']}'.contains('1') || json['vacation_status'] == true;
    }
    if(json['temporary_close'] != null){
      try{
        temporaryClose = json['temporary_close']??false;
      }catch(e){
        temporaryClose = json['temporary_close']== 1?true : false;
      }
    }

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    banner = json['banner'];
    if(json['vacation_duration_type'] != null) {
      vacationDurationType =  VacationDurationType.fromJson(json['vacation_duration_type']);
    }
  }

}

class DeliveryMan {
  int? id;
  String? fName;
  String? lName;
  String? image;
  String? phone;
  String? code;
  ImageFullUrl? imageFullUrl;



  DeliveryMan({this.id,
    this.fName,
    this.lName,
    this.image,
    this.code,
    this.phone,
    this.imageFullUrl
  });

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    image = json['image'];
    phone = json['phone'];
    code = json['country_code'];
    imageFullUrl = json['image_full_url'] != null ? ImageFullUrl.fromJson(json['image_full_url']) : null;

  }

  DeliveryMan.fromCounterparty(Map<String, dynamic> counterparty) {
    id = counterparty['id'];
    fName = counterparty['name'];
    lName = '';
    image = counterparty['image'];
    phone = counterparty['phone'];
    code = counterparty['country_code'];
    imageFullUrl = counterparty['image_full_url'] != null ? ImageFullUrl.fromJson(counterparty['image_full_url']) : null;
  }
}