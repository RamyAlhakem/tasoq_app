import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCampaignBannerWidget extends StatelessWidget {
  final ImageFullUrl? image;

  const WholesaleCampaignBannerWidget({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.homePagePadding,
        vertical: Dimensions.paddingSizeSmall,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: SizedBox(
          height: 109,
          width: double.infinity,
          child: CustomImageWidget(image: image?.path ?? ''),
        ),
      ),
    );
  }
}
