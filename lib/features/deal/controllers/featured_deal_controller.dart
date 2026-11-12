import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/domain/services/featured_deal_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/common/enums/data_source_enum.dart';
import 'package:flutter_sixvalley_ecommerce/helper/data_sync_helper.dart';

class FeaturedDealController extends ChangeNotifier {
  final FeaturedDealServiceInterface featuredDealServiceInterface;
  FeaturedDealController({required this.featuredDealServiceInterface});

  int? _featuredDealSelectedIndex;
  List<Product>? _featuredDealProductList;
  List<Product>? get featuredDealProductList => _featuredDealProductList;
  int? get featuredDealSelectedIndex => _featuredDealSelectedIndex;

  int? _requestedDealId;

  Future<void> fetchWithCache() async {
    if (_featuredDealProductList != null) return;
    await getFeaturedDealList();
  }


  Future<void> getFeaturedDealList() async {
    _requestedDealId = null;

    DataSyncHelper.fetchAndSyncData(
      fetchFromLocal: () => featuredDealServiceInterface.getFeaturedDeal(source: DataSourceEnum.local),
      fetchFromClient: () => featuredDealServiceInterface.getFeaturedDeal(source: DataSourceEnum.client),
      onResponse: (data, source) {
        final int? dealId = firstFeaturedDealId(data);

        if (dealId == null) {
          _requestedDealId = null;
          _featuredDealProductList = [];
          _featuredDealSelectedIndex = 0;
          notifyListeners();
          return;
        }

        if (dealId == _requestedDealId) return;
        _requestedDealId = dealId;
        _getFeaturedDealProducts(dealId);
      },
    );
  }

  void _getFeaturedDealProducts(int dealId) {
    DataSyncHelper.fetchAndSyncData(
      fetchFromLocal: () => featuredDealServiceInterface.getFeaturedDealProducts(dealId: dealId, source: DataSourceEnum.local),
      fetchFromClient: () => featuredDealServiceInterface.getFeaturedDealProducts(dealId: dealId, source: DataSourceEnum.client),
      onResponse: (data, source) {
        if (dealId != _requestedDealId) return;

        try {
          _featuredDealProductList = featuredDealProductsFromJson(data);
        } catch (_) {
          _featuredDealProductList = [];
        }
        _featuredDealSelectedIndex = 0;
        notifyListeners();
      },
    );
  }

  static int? firstFeaturedDealId(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final Map? first = ApiListEnvelope.fromJson(data).data?.whereType<Map>().firstOrNull;
    return int.tryParse('${first?['id']}');
  }

  static List<Product> featuredDealProductsFromJson(dynamic data) {
    if (data is! Map<String, dynamic>) return [];
    return [
      for (final Map row in ApiListEnvelope.fromJson(data).data?.whereType<Map>() ?? const <Map>[])
        Product.fromDealJson(Map<String, dynamic>.from(row)),
    ];
  }


  void changeSelectedIndex(int selectedIndex) {
    _featuredDealSelectedIndex = selectedIndex;
    notifyListeners();
  }
}
