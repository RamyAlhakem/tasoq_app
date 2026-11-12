import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_price_quote_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_purchase_options_model.dart';

class WholesaleProductDetailsModel {
  final int? id;
  final String? productName;
  final String? slug;
  final String? details;
  final String? productShareLink;
  final String? unit;
  final int? minimumOrderQuantity;
  final int? currentStock;
  final ImageFullUrl? thumbnailFullUrl;
  final List<ImageFullUrl>? images;
  final WholesaleProductVideo? video;
  final String? taxModel;
  final WholesaleProductShop? shop;
  final double? rating;
  final int? reviewCount;
  final int? soldCount;
  final WholesalePurchaseOptions? purchaseOptions;
  final WholesalePriceQuote? defaultQuote;
  final List<WholesaleProductFaq> faqs;
  final List<WholesaleTrustPolicy> trustPolicy;
  final bool isWishlisted;

  const WholesaleProductDetailsModel({
    this.id,
    this.productName,
    this.slug,
    this.details,
    this.productShareLink,
    this.unit,
    this.minimumOrderQuantity,
    this.currentStock,
    this.thumbnailFullUrl,
    this.images,
    this.video,
    this.taxModel,
    this.shop,
    this.rating,
    this.reviewCount,
    this.soldCount,
    this.purchaseOptions,
    this.defaultQuote,
    this.faqs = const [],
    this.trustPolicy = const [],
    this.isWishlisted = false,
  });

  List<ImageFullUrl> get allImages {
    final Set<String> seenPaths = {};
    return [
      if (thumbnailFullUrl != null) thumbnailFullUrl!,
      ...?images,
    ].where((image) => (image.path?.isNotEmpty ?? false) && seenPaths.add(image.path!)).toList();
  }

  bool get isShopClosed => shop?.isClosed ?? false;

  double? get lowestDiscountedUnitPrice => _discountedUnitPrices().fold<double?>(
        null, (lowest, price) => lowest == null || price < lowest ? price : lowest);

  double? get highestDiscountedUnitPrice => _discountedUnitPrices().fold<double?>(
        null, (highest, price) => highest == null || price > highest ? price : highest);

  Iterable<double> _discountedUnitPrices() sync* {
    for (final WholesalePriceRow row in purchaseOptions?.priceRows ?? const []) {
      if (row.tiers.isEmpty) {
        final double? price = row.unitPrice;
        if (price != null) yield price;
        continue;
      }
      for (final WholesalePriceTier tier in row.tiers) {
        final double? price = tier.discountedUnitPrice ?? tier.unitPrice;
        if (price != null) yield price;
      }
    }
  }

  factory WholesaleProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? rating = json['rating'] is Map ? Map<String, dynamic>.from(json['rating']) : null;

    return WholesaleProductDetailsModel(
      id: _toInt(json['id']),
      productName: json['name'] as String?,
      slug: json['slug'] as String?,
      details: json['details'] as String?,
      productShareLink: json['product_share_link'] as String?,
      unit: json['unit'] as String?,
      minimumOrderQuantity: _toInt(json['minimum_order_qty']),
      currentStock: _toInt(json['current_stock']),
      thumbnailFullUrl: ImageFullUrl.parse(json['thumbnail_full_url']),
      images: (json['images_full_url'] as List<dynamic>?)?.map(ImageFullUrl.parse).whereType<ImageFullUrl>().toList(),
      video: json['video'] is Map ? WholesaleProductVideo.fromJson(Map<String, dynamic>.from(json['video'])) : null,
      taxModel: json['tax_model'] as String?,
      shop: json['shop'] is Map ? WholesaleProductShop.fromJson(Map<String, dynamic>.from(json['shop'])) : null,
      rating: _toDouble(rating?['average']),
      reviewCount: _toInt(rating?['count']),
      soldCount: _toInt(json['sold_quantity']),
      purchaseOptions: json['purchase_options'] is Map
          ? WholesalePurchaseOptions.fromJson(Map<String, dynamic>.from(json['purchase_options'])) : null,
      defaultQuote: json['default_quote'] is Map
          ? WholesalePriceQuote.fromJson(Map<String, dynamic>.from(json['default_quote'])) : null,
      faqs: _listOf(json['faqs'], WholesaleProductFaq.fromJson),
      trustPolicy: _listOf(json['trust_policy'], WholesaleTrustPolicy.fromJson),
      isWishlisted: json['is_wishlisted'] == true,
    );
  }

  static List<T> _listOf<T>(dynamic value, T Function(Map<String, dynamic>) parse) {
    if (value is! List) return const [];
    return [
      for (final Map row in value.whereType<Map>()) parse(Map<String, dynamic>.from(row)),
    ];
  }

  static double? _toDouble(dynamic value) => value == null ? null : double.tryParse('$value');

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value') ?? double.tryParse('$value')?.toInt();
  }
}

class WholesaleProductShop {
  final int? id;
  final int? sellerId;
  final String? name;
  final String? slug;
  final ImageFullUrl? imageFullUrl;
  final int? productCount;
  final int? reviewCount;
  final bool isClosed;
  final bool isVerified;
  final bool isShopOnVacation;
  final bool isShopTemporaryClosed;

  const WholesaleProductShop({
    this.id,
    this.sellerId,
    this.name,
    this.slug,
    this.imageFullUrl,
    this.productCount,
    this.reviewCount,
    this.isClosed = false,
    this.isVerified = false,
    this.isShopOnVacation = false,
    this.isShopTemporaryClosed = false,
  });

  factory WholesaleProductShop.fromJson(Map<String, dynamic> json) {
    return WholesaleProductShop(
      id: WholesaleProductDetailsModel._toInt(json['id']),
      sellerId: WholesaleProductDetailsModel._toInt(json['seller_id']),
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      imageFullUrl: ImageFullUrl.parse(json['image_full_url']),
      productCount: WholesaleProductDetailsModel._toInt(json['product_count']),
      reviewCount: WholesaleProductDetailsModel._toInt(json['review_count']),
      isClosed: json['is_closed'] == true,
      isVerified: json['is_verified'] == true,
      isShopOnVacation: json['vacation_status'] == true,
      isShopTemporaryClosed: json['temporary_close'] == true,
    );
  }
}

class WholesaleProductVideo {
  final String? provider;
  final String? url;

  const WholesaleProductVideo({this.provider, this.url});

  factory WholesaleProductVideo.fromJson(Map<String, dynamic> json) {
    return WholesaleProductVideo(provider: json['provider'] as String?, url: json['url'] as String?);
  }

  bool get isFile => provider == 'file' && (url?.isNotEmpty ?? false);

  bool get isValidYouTubeUrl => url != null && RegExp(
    r'^https?:\/\/(?:www\.)?(youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
  ).hasMatch(url!);
}

class WholesaleProductFaq {
  final String? question;
  final String? answer;

  const WholesaleProductFaq({this.question, this.answer});

  factory WholesaleProductFaq.fromJson(Map<String, dynamic> json) {
    return WholesaleProductFaq(question: json['question'] as String?, answer: json['answer'] as String?);
  }
}

class WholesaleTrustPolicy {
  final String? title;
  final String? icon;

  const WholesaleTrustPolicy({this.title, this.icon});

  factory WholesaleTrustPolicy.fromJson(Map<String, dynamic> json) {
    return WholesaleTrustPolicy(title: json['title'] as String?, icon: json['icon'] as String?);
  }
}
