import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_campaign/domain/models/wholesale_campaign_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCampaignBannerSection extends StatefulWidget {
  final List<WholesaleCampaign>? campaigns;

  const WholesaleCampaignBannerSection({super.key, required this.campaigns});

  @override
  State<WholesaleCampaignBannerSection> createState() => _WholesaleCampaignBannerSectionState();
}

class _WholesaleCampaignBannerSectionState extends State<WholesaleCampaignBannerSection> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<WholesaleCampaign>? campaigns = widget.campaigns;
    if (campaigns != null && campaigns.isEmpty) return const SizedBox.shrink();

    final double width = MediaQuery.sizeOf(context).width;
    final double height = width * 0.37;

    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.homePagePadding,
        right: Dimensions.homePagePadding,
        top: Dimensions.homePagePadding,
        bottom: Dimensions.paddingSizeSmall,
      ),
      child: campaigns == null
          ? WholesaleShimmerBoxWidget(height: height)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                    initialPage: _currentIndex < campaigns.length ? _currentIndex : 0,
                    height: height,
                    viewportFraction: 1,
                    autoPlay: campaigns.length > 1,
                    pauseAutoPlayOnTouch: true,
                    pauseAutoPlayOnManualNavigate: true,
                    enlargeCenterPage: true,
                    disableCenter: true,
                    onPageChanged: (index, _) => setState(() => _currentIndex = index),
                  ),
                  itemCount: campaigns.length,
                  itemBuilder: (context, index, _) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: _CampaignBannerCard(
                      campaign: campaigns[index],
                      onTap: () => _openCampaign(campaigns[index]),
                    ),
                  ),
                ),

                if (campaigns.length > 1) ...[
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  SizedBox(
                    height: Dimensions.paddingSizeExtraSmall,
                    child: ListView.separated(
                      separatorBuilder: (_, __) => const SizedBox(width: 3),
                      itemCount: campaigns.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Container(
                        width: _currentIndex == index ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraSmall,
                        height: Dimensions.paddingSizeExtraSmall,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: _currentIndex == index ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  void _openCampaign(WholesaleCampaign campaign) {
    final String? slug = campaign.slug;
    if (slug == null || slug.isEmpty) return;
    RouterHelper.getWholesaleCampaignScreenRoute(action: RouteAction.push, slug: slug);
  }
}

class _CampaignBannerCard extends StatelessWidget {
  final WholesaleCampaign campaign;
  final VoidCallback onTap;

  const _CampaignBannerCard({required this.campaign, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String? discount = campaign.maxDiscountLabel;
    final String? description = campaign.description;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomImageWidget(image: campaign.image),

            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                  colors: [Colors.black.withValues(alpha: 0.75), Colors.black.withValues(alpha: 0.15)],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (discount != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeExtraExtraSmall,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Text(
                            '${getTranslated('up_to', context) ?? 'Up To'} $discount ${getTranslated('off', context) ?? 'Off'}',
                            style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white),
                          ),
                        ),
                      if (discount != null && campaign.isRunning)
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      if (campaign.isRunning)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeExtraExtraSmall,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Text(
                            getTranslated('running', context) ?? 'Running',
                            style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          campaign.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: titilliumBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),

                        if (description != null && description.isNotEmpty) ...[
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: titilliumRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
