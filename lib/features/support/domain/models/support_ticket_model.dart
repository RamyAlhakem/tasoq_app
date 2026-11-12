import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class SupportTicketList {
  int? totalSize;
  int? limit;
  int? offset;
  int? lastPage;
  List<SupportTicketModel> tickets;

  SupportTicketList({this.totalSize, this.limit, this.offset, this.lastPage, List<SupportTicketModel>? tickets})
      : tickets = tickets ?? <SupportTicketModel>[];

  SupportTicketList.fromJson(Map<String, dynamic> json) : tickets = <SupportTicketModel>[] {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    lastPage = envelope.lastPage;
    for (final dynamic ticket in envelope.data ?? const []) {
      if (ticket is Map) {
        tickets.add(SupportTicketModel.fromJson(Map<String, dynamic>.from(ticket)));
      }
    }
  }

  bool get hasNextPage => lastPage != null && offset != null && offset! < lastPage!;
}

class SupportTicketModel {
  int? _id;
  int? _customerId;
  String? _subject;
  String? _type;
  String? _priority;
  String? _description;
  String? _reply;
  String? _status;
  int? _conversationsCount;
  List<ImageFullUrl>? _attachmentFullUrl;
  String? _createdAt;
  String? _updatedAt;

  SupportTicketModel(
      {int? id,
        int? customerId,
        String? subject,
        String? type,
        String? priority,
        String? description,
        String? reply,
        String? status,
        int? conversationsCount,
        List<ImageFullUrl>? attachmentFullUrl,
        String? createdAt,
        String? updatedAt}) {
    _id = id;
    _customerId = customerId;
    _subject = subject;
    _type = type;
    _priority = priority;
    _description = description;
    _reply = reply;
    _status = status;
    _conversationsCount = conversationsCount;
    _attachmentFullUrl = attachmentFullUrl;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get customerId => _customerId;
  String? get subject => _subject;
  String? get type => _type;
  String? get priority => _priority;
  String? get description => _description;
  String? get reply => _reply;
  String? get status => _status;

  int? get conversationsCount => _conversationsCount;

  List<ImageFullUrl>? get attachmentFullUrl => _attachmentFullUrl;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  SupportTicketModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _subject = json['subject'];
    _type = json['type'];
    _priority = json['priority'];
    _description = json['description'];
    _reply = json['reply'];
    _status = json['status'];
    _conversationsCount = json['conversations_count'] is int
        ? json['conversations_count']
        : int.tryParse('${json['conversations_count']}');
    if (json['attachment_full_url'] is List) {
      _attachmentFullUrl = <ImageFullUrl>[];
      for (final dynamic attachment in json['attachment_full_url']) {
        _attachmentFullUrl!.add(ImageFullUrl.fromJson(attachment));
      }
    }
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['customer_id'] = _customerId;
    data['subject'] = _subject;
    data['type'] = _type;
    data['priority'] = _priority;
    data['description'] = _description;
    data['reply'] = _reply;
    data['status'] = _status;
    data['conversations_count'] = _conversationsCount;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}
