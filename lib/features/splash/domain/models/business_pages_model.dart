class BusinessPageModel {
  int? id;
  String? title;
  String? slug;
  String? description;

  bool? status;

  bool? isDefault;

  String? createdAt;
  String? updatedAt;
  Banner? banner;

  BannerFullUrl? bannerFullUrl;

  BusinessPageModel(
      {this.id,
        this.title,
        this.slug,
        this.description,
        this.status,
        this.isDefault,
        this.createdAt,
        this.updatedAt,
        this.bannerFullUrl,
        this.banner});

  BusinessPageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    status = _asBool(json['status']);
    isDefault = _asBool(json['is_default'] ?? json['default_status']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bannerFullUrl = json['banner_full_url'] != null
        ? BannerFullUrl.fromJson(json['banner_full_url'])
        : null;
    banner =
    json['banner'] != null ? Banner.fromJson(json['banner']) : null;
  }

  static bool? _asBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    return bool.tryParse('$value') ?? (int.tryParse('$value') ?? 0) != 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['status'] = status;
    data['is_default'] = isDefault;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (bannerFullUrl != null) {
      data['banner_full_url'] = bannerFullUrl!.toJson();
    }
    if (banner != null) {
      data['banner'] = banner!.toJson();
    }
    return data;
  }
}

class BannerFullUrl {
  String? key;
  String? path;
  int? status;

  BannerFullUrl({this.key, this.path, this.status});

  BannerFullUrl.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    path = json['path'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['path'] = path;
    data['status'] = status;
    return data;
  }
}

class Banner {
  int? id;
  String? attachableType;
  int? attachableId;
  String? fileType;
  String? fileName;
  String? storageDisk;
  String? createdAt;
  String? updatedAt;

  Banner(
      {this.id,
        this.attachableType,
        this.attachableId,
        this.fileType,
        this.fileName,
        this.storageDisk,
        this.createdAt,
        this.updatedAt});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attachableType = json['attachable_type'];
    attachableId = json['attachable_id'];
    fileType = json['file_type'];
    fileName = json['file_name'];
    storageDisk = json['storage_disk'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attachable_type'] = attachableType;
    data['attachable_id'] = attachableId;
    data['file_type'] = fileType;
    data['file_name'] = fileName;
    data['storage_disk'] = storageDisk;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
