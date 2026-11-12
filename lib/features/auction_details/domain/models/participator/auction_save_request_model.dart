class AuctionSaveRequestModel {
  final int auctionProductId;

  AuctionSaveRequestModel({required this.auctionProductId});

  Map<String, dynamic> toJson() => {
    'auction_product_id': auctionProductId,
  };
}

class AuctionSaveResponseModel {
  String? identicalCode;
  String? message;
  AuctionSaveContent? content;
  List<dynamic>? errors;

  AuctionSaveResponseModel({this.identicalCode, this.message, this.content, this.errors});

  AuctionSaveResponseModel.fromJson(Map<String, dynamic> json) {
    identicalCode = json['identical_code'];
    message = json['message'];
    content = json['content'] != null ? AuctionSaveContent.fromJson(json['content']) : null;
    if (json['errors'] != null) {
      errors = List<dynamic>.from(json['errors']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identical_code'] = identicalCode;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    if (errors != null) {
      data['errors'] = errors;
    }
    return data;
  }
}

class AuctionSaveContent {
  bool? isSaved;

  AuctionSaveContent({this.isSaved});

  AuctionSaveContent.fromJson(Map<String, dynamic> json) {
    isSaved = json['is_saved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_saved'] = isSaved;
    return data;
  }
}
