import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class WholesaleCategoryResponseModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<WholesaleCategoryNode>? categories;

  WholesaleCategoryResponseModel({this.totalSize, this.limit, this.offset, this.categories});

  WholesaleCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    if (envelope.data != null) {
      categories = <WholesaleCategoryNode>[];
      envelope.data!.forEach((v) {
        categories!.add(WholesaleCategoryNode.fromJson(v));
      });
    }
  }
}

class WholesaleCategoryNode {
  final int? id;
  final String? name;
  final ImageFullUrl? imageUrl;
  final int? productCount;

  List<WholesaleCategoryNode>? _children;

  int? childTotalSize;
  int? childLimit;
  int? childOffset;

  WholesaleCategoryNode({
    this.id,
    this.name,
    this.imageUrl,
    this.productCount,
    List<WholesaleCategoryNode>? children,
  }) : _children = children;

  WholesaleCategoryNode.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        productCount = json['product_count'],
        imageUrl = ImageFullUrl.parse(json['icon_full_url']);

  List<WholesaleCategoryNode>? get children => _children;

  bool get isChildrenLoaded => _children != null;

  void setChildren(List<WholesaleCategoryNode> categories, {bool append = false}) {
    if (append && _children != null) {
      _children!.addAll(categories);
    } else {
      _children = categories;
    }
  }
}
