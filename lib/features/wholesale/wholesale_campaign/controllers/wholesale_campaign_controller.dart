import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/domain/models/wholesale_campaign_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/domain/services/wholesale_campaign_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_home/domain/models/wholesale_product_model.dart';

class WholesaleCampaignController extends ChangeNotifier {
  final WholesaleCampaignServiceInterface wholesaleCampaignServiceInterface;
  WholesaleCampaignController({required this.wholesaleCampaignServiceInterface});

  static const int _productPageSize = 10;

  List<WholesaleCampaign>? _campaigns;
  List<WholesaleCampaign>? get campaigns => _campaigns;

  bool _isListLoading = false;
  bool get isListLoading => _isListLoading;

  String _slug = '';
  String get slug => _slug;

  WholesaleCampaign? _campaign;
  WholesaleCampaign? get campaign => _campaign;

  bool _isCampaignLoading = false;
  bool get isCampaignLoading => _isCampaignLoading;

  bool _campaignNotFound = false;
  bool get campaignNotFound => _campaignNotFound;

  String? _campaignErrorMessage;
  String? get campaignErrorMessage => _campaignErrorMessage;

  List<WholesaleProduct>? _products;
  List<WholesaleProduct>? get products => _products;

  int _productOffset = 1;
  int? _productTotalSize;
  int? get productTotalSize => _productTotalSize;

  bool _isProductLoading = false;
  bool get isProductLoading => _isProductLoading;

  bool get hasMoreProducts {
    if (_products == null || _productTotalSize == null) return false;
    return _products!.length < _productTotalSize!;
  }

  Future<void> getCampaignList({bool reload = false}) async {
    if (_isListLoading) return;
    if (_campaigns != null && !reload) return;

    _isListLoading = true;
    if (reload) _campaigns = null;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCampaignServiceInterface.getCampaignList();

    _campaigns = apiResponse.response?.statusCode == 200
        ? (WholesaleCampaignListModel.fromJson(apiResponse.response?.data).campaigns ?? []) : [];

    _isListLoading = false;
    notifyListeners();
  }

  Future<void> bind({String? slug}) async {
    String? resolved = slug;

    if (resolved == null || resolved.isEmpty) {
      await getCampaignList();
      resolved = _campaigns?.isNotEmpty == true ? _campaigns!.first.slug : null;

      if (resolved == null || resolved.isEmpty) {
        _campaignNotFound = true;
        _isCampaignLoading = false;
        notifyListeners();
        return;
      }
    }

    _slug = resolved;
    _campaign = null;
    _products = null;
    _productOffset = 1;
    _productTotalSize = null;

    await Future.wait([_loadCampaignDetails(), _loadProducts(offset: 1)]);
  }

  Future<void> retry() => bind(slug: _slug.isEmpty ? null : _slug);

  Future<void> loadMoreProducts() async {
    if (_isProductLoading || !hasMoreProducts) return;
    await _loadProducts(offset: _productOffset + 1);
  }

  Future<void> _loadCampaignDetails() async {
    _isCampaignLoading = true;
    _campaignNotFound = false;
    _campaignErrorMessage = null;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCampaignServiceInterface.getCampaignDetails(_slug);

    if (apiResponse.response?.statusCode == 200) {
      _campaign = WholesaleCampaign.parse(apiResponse.response?.data);
      if (_campaign == null) _campaignNotFound = true;
    } else if (apiResponse.response?.statusCode == 404) {
      _campaignNotFound = true;
    } else {
      _campaignErrorMessage = _messageOf(apiResponse);
    }

    _isCampaignLoading = false;
    notifyListeners();
  }

  Future<void> _loadProducts({required int offset}) async {
    _isProductLoading = true;
    notifyListeners();

    final ApiResponseModel apiResponse = await wholesaleCampaignServiceInterface.getCampaignProducts(
      _slug, offset: offset, limit: _productPageSize,
    );

    if (apiResponse.response?.statusCode == 200) {
      final WholesaleProductListModel parsed = WholesaleProductListModel.fromJson(apiResponse.response?.data);

      _products = offset == 1 ? (parsed.products ?? []) : [...?_products, ...?parsed.products];
      _productTotalSize = parsed.totalSize;
      _productOffset = offset;
    } else {
      _products ??= [];
    }

    _isProductLoading = false;
    notifyListeners();
  }

  String _messageOf(ApiResponseModel apiResponse) {
    final dynamic error = apiResponse.error;
    if (error is String && error.isNotEmpty) return error;
    return 'something_went_wrong';
  }
}
