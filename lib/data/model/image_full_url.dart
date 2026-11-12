class ImageFullUrl {
  String? key;
  String? path;
  int? status;

  ImageFullUrl({this.key, this.path, this.status});

  ImageFullUrl.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    path = json['path'];
    status = json['status'];
    if(status != 200){
      path = '';
    }
  }

  static ImageFullUrl? parse(dynamic value) {
    if (value is Map) {
      return ImageFullUrl.fromJson(Map<String, dynamic>.from(value));
    }
    final String url = value?.toString() ?? '';
    return url.isEmpty ? null : ImageFullUrl(path: url, status: 200);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['path'] = path;
    data['status'] = status;
    return data;
  }
}