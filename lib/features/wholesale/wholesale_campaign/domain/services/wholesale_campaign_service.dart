import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/domain/repositories/wholesale_campaign_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/domain/services/wholesale_campaign_service_interface.dart';

class WholesaleCampaignService implements WholesaleCampaignServiceInterface {
  final WholesaleCampaignRepositoryInterface wholesaleCampaignRepositoryInterface;

  WholesaleCampaignService({required this.wholesaleCampaignRepositoryInterface});

  @override
  Future getCampaignList({int offset = 1, int limit = 25}) async {
    return await wholesaleCampaignRepositoryInterface.getCampaignList(offset: offset, limit: limit);
  }

  @override
  Future getCampaignDetails(String slug) async {
    return await wholesaleCampaignRepositoryInterface.getCampaignDetails(slug);
  }

  @override
  Future getCampaignProducts(String slug, {int offset = 1, int limit = 10}) async {
    return await wholesaleCampaignRepositoryInterface.getCampaignProducts(slug, offset: offset, limit: limit);
  }
}
