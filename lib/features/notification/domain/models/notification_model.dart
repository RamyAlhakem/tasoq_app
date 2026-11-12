import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class NotificationItemModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? newNotificationItem;
  List<NotificationItem>? notification;

  NotificationItemModel(
      {this.totalSize,
        this.limit,
        this.offset,
        this.newNotificationItem,
        this.notification});

  NotificationItemModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['notification']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    newNotificationItem = envelope.read('new_notification');
    if (envelope.data != null) {
      notification = <NotificationItem>[];
      envelope.data!.forEach((v) {
        notification!.add(NotificationItem.fromJson(v));
      });
    }
  }
}

class NotificationItem {
  int? id;
  String? sentBy;
  String? sentTo;
  String? title;
  String? description;
  int? notificationCount;
  String? image;
  ImageFullUrl? imageFullUrl;
  int? status;
  String? createdAt;
  String? updatedAt;
  bool isSeen = false;
  NotificationSeenBy? seen;


  NotificationItem(
      {this.id,
        this.sentBy,
        this.sentTo,
        this.title,
        this.description,
        this.notificationCount,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.isSeen = false,
        this.seen,
        this.imageFullUrl
      });

  NotificationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sentBy = json['sent_by'];
    sentTo = json['sent_to'];
    title = json['title'];
    description = json['description'];
    notificationCount = int.tryParse('${json['notification_count']}');
    image = json['image'];
    imageFullUrl = json['image_full_url'] != null
      ? ImageFullUrl.fromJson(json['image_full_url'])
      : null;
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    seen = json['notification_seen_by'] != null ? NotificationSeenBy.fromJson(json['notification_seen_by']) : null;
    isSeen = json['is_seen'] == true || seen != null;
  }
}

class NotificationSeenBy {
  int? id;
  int? userId;
  int? notificationId;
  String? createdAt;


  NotificationSeenBy(
      {this.id,
        this.userId,
        this.notificationId,
        this.createdAt,
        });

  NotificationSeenBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = int.tryParse('${json['user_id']}');
    notificationId = int.tryParse('${json['notification_id']}');
    createdAt = json['created_at'];
  }
}

class AuctionNotificationListModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? newAuctionNotification;
  List<AuctionNotificationItem>? notifications;

  AuctionNotificationListModel({this.totalSize, this.limit, this.offset, this.newAuctionNotification, this.notifications});

  AuctionNotificationListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['notifications']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    newAuctionNotification = envelope.read('new_notification');
    if (envelope.data != null) {
      notifications = <AuctionNotificationItem>[];
      envelope.data!.forEach((v) {
        notifications!.add(AuctionNotificationItem.fromJson(v));
      });
    }
  }
}

class WholesaleNotificationListModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? newWholesaleNotification;
  List<WholesaleNotificationItem>? notifications;

  WholesaleNotificationListModel({this.totalSize, this.limit, this.offset, this.newWholesaleNotification, this.notifications});

  WholesaleNotificationListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['notifications']);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    newWholesaleNotification = envelope.read('new_notification');
    if (envelope.data != null) {
      notifications = <WholesaleNotificationItem>[];
      envelope.data!.forEach((v) {
        notifications!.add(WholesaleNotificationItem.fromJson(v));
      });
    }
  }
}

class WholesaleNotificationItem {
  int? id;
  String? title;
  String? description;
  String? image;

  String? imageFullUrl;
  String? sentTo;
  int? notificationCount;
  bool isSeen;
  String? createdAt;

  WholesaleNotificationItem({
    this.id,
    this.title,
    this.description,
    this.image,
    this.imageFullUrl,
    this.sentTo,
    this.notificationCount,
    this.isSeen = false,
    this.createdAt,
  });

  WholesaleNotificationItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] ?? json['type'],
        description = json['description'] ?? json['message'],
        image = json['image'],
        imageFullUrl = json['image_full_url']?.toString(),
        sentTo = json['sent_to'],
        notificationCount = int.tryParse('${json['notification_count']}'),
        isSeen = json['is_seen'] == true || json['is_read'] == true,
        createdAt = json['created_at'];
}

int totalNewNotification(
  NotificationItemModel? general,
  AuctionNotificationListModel? auction, {
  bool isAuctionEnabled = true,
  WholesaleNotificationListModel? wholesale,
}) {
  return (general?.newNotificationItem ?? 0) +
      (isAuctionEnabled ? (auction?.newAuctionNotification ?? 0) : 0) +
      (wholesale?.newWholesaleNotification ?? 0);
}

class AuctionNotificationItem {
  int? id;
  int? auctionProductId;
  String? slug;
  int? senderId;
  int? receiverId;
  String? senderType;
  String? receiverType;
  String? type;
  String? message;
  bool isRead;
  String? createdAt;
  String? updatedAt;
  String? auctionName;
  ImageFullUrl? imageFullUrl;

  AuctionNotificationItem({
    this.id,
    this.auctionProductId,
    this.slug,
    this.senderId,
    this.receiverId,
    this.senderType,
    this.receiverType,
    this.type,
    this.message,
    this.isRead = false,
    this.createdAt,
    this.updatedAt,
    this.auctionName,
    this.imageFullUrl,
  });

  String get typeLabel {
    if (type == null || type!.isEmpty) return '';
    return type!.split('_').map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase()).join(' ');
  }

  AuctionNotificationItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        auctionProductId = json['auction_product_id'],
        slug = json['slug'],
        senderId = json['sender_id'],
        receiverId = json['receiver_id'],
        senderType = json['sender_type'],
        receiverType = json['receiver_type'],
        type = json['type'],
        message = json['message'],
        isRead = json['is_read'] == true,
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        auctionName = json['auction_product_name'],
        imageFullUrl = json['auction_product_thumbnail_full_url'] != null ? ImageFullUrl(path: json['auction_product_thumbnail_full_url'] as String, status: 200) : null;
}