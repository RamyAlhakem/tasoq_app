

class NotificationBody {
  int? orderId;
  int? orderDetailsId;
  String? type;
  String? status;
  String? messageKey;
  String? title;
  String? productId;
  String? slug;
  String? image;
  int? auctionId;
  String? auctionSlug;
  String? businessModule;


  NotificationBody({
    this.orderId,
    this.orderDetailsId,
    this.type,
    this.status,
    this.messageKey,
    this.title,
    this.productId,
    this.slug,
    this.image,
    this.auctionId,
    this.auctionSlug,
    this.businessModule,
  });

  NotificationBody.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderDetailsId = json['order_details_id'] != null ? int.tryParse(json['order_details_id'].toString()) : null;
    type = json['type'];
    messageKey = json['message_key'];
    title = json['title'];
    productId = json['product_id'];
    slug = json['slug'];
    image = json['image'];
    status = json['status'];
    auctionId = json['auction_id'] != null ? int.tryParse(json['auction_id'].toString()) : null;
    auctionSlug = json['auction_slug'];
    businessModule = json['business_module'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_details_id'] = orderDetailsId;
    data['type'] = type;
    data['message_key'] = messageKey;
    data['title'] = title;
    data['product_id'] = productId;
    data['slug'] = slug;
    data['image'] = image;
    data['status'] = status;
    data['auction_id'] = auctionId;
    data['auction_slug'] = auctionSlug;
    data['business_module'] = businessModule;
    return data;
  }


}
