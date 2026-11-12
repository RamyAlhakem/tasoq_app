import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_details/domain/models/creator/creator_auction_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class AuctionWinnerInfoWidget extends StatelessWidget {
  final AuctionWinner winner;

  const AuctionWinnerInfoWidget({super.key, required this.winner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Row(children: [
        ClipOval(
          child: CustomImageWidget(
            image: winner.imageFullUrl?.path ?? '',
            placeholder: Images.user,
            height: 40,
            width: 40,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(
                child: Text(
                  winner.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              const CustomAssetImageWidget(Images.winner, height: Dimensions.iconSizeSmall, width: Dimensions.iconSizeSmall),
            ]),

            Text(
              getTranslated('auction_claimer', context) ?? 'Auction Claimer',
              style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
            ),
          ]),
        ),
      ]),
    );
  }
}
