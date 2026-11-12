import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';

class WholesaleCampaignListModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? lastPage;
  List<WholesaleCampaign>? campaigns;

  WholesaleCampaignListModel({this.totalSize, this.limit, this.offset, this.lastPage, this.campaigns});

  WholesaleCampaignListModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json);
    totalSize = envelope.totalSize;
    limit = envelope.limit;
    offset = envelope.offset;
    lastPage = envelope.lastPage;
    if (envelope.data != null) {
      campaigns = [
        for (final Map row in envelope.data!.whereType<Map>())
          WholesaleCampaign.fromJson(Map<String, dynamic>.from(row)),
      ];
    }
  }
}

class WholesaleCampaign {
  final int? id;
  final String? title;
  final String? slug;
  final String? description;
  final ImageFullUrl? imageFullUrl;
  final double? minDiscount;
  final double? maxDiscount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? dailyStartTime;
  final String? dailyEndTime;
  final String? scheduleStatus;
  final int? manufacturerCount;
  final int? productCount;

  const WholesaleCampaign({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.imageFullUrl,
    this.minDiscount,
    this.maxDiscount,
    this.startDate,
    this.endDate,
    this.dailyStartTime,
    this.dailyEndTime,
    this.scheduleStatus,
    this.manufacturerCount,
    this.productCount,
  });

  factory WholesaleCampaign.fromJson(Map<String, dynamic> json) {
    return WholesaleCampaign(
      id: _toInt(json['id']),
      title: json['title']?.toString(),
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      imageFullUrl: ImageFullUrl.parse(json['image_full_url'] ?? json['image']),
      minDiscount: _toDouble(json['min_discount']),
      maxDiscount: _toDouble(json['max_discount']),
      startDate: _toDate(json['start_date']),
      endDate: _toDate(json['end_date']),
      dailyStartTime: json['daily_start_time']?.toString(),
      dailyEndTime: json['daily_end_time']?.toString(),
      scheduleStatus: json['schedule_status']?.toString(),
      manufacturerCount: _toInt(json['total_joined']),
      productCount: _toInt(json['total_products']),
    );
  }

  static WholesaleCampaign? parse(dynamic json) {
    final dynamic data = ApiEnvelope.content(json)['data'];
    if (data is! Map) return null;
    return WholesaleCampaign.fromJson(Map<String, dynamic>.from(data));
  }

  String get image => imageFullUrl?.path ?? '';

  String? get manufacturerCountLabel => _plusLabel(manufacturerCount);

  String? get productCountLabel => _plusLabel(productCount);

  static String? _plusLabel(int? total) {
    if (total == null) return null;
    return total > 1 ? '${total - 1}+' : '$total';
  }

  bool get isRunning => scheduleStatus == 'running';

  String? get discountRangeLabel {
    if (minDiscount == null && maxDiscount == null) return null;
    final String min = _percent(minDiscount ?? maxDiscount);
    final String max = _percent(maxDiscount ?? minDiscount);
    return min == max ? min : '$min - $max';
  }

  String? get maxDiscountLabel {
    final double? discount = maxDiscount ?? minDiscount;
    return discount == null ? null : _percent(discount);
  }

  static String _percent(double? value) {
    if (value == null) return '';
    final String text = value == value.roundToDouble() ? value.toInt().toString() : '$value';
    return '$text%';
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse('$value')?.toLocal();
  }

  static double? _toDouble(dynamic value) => value == null ? null : double.tryParse('$value');

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value') ?? double.tryParse('$value')?.toInt();
  }
}
