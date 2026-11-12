import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class WholesaleStoreWidget extends StatelessWidget {
  final String storeName;
  final String? storeLogoUrl;
  final bool isVerified;
  final bool isTemporaryClosed;
  final bool isOnVacation;
  final int reviewCount;
  final int productCount;
  final VoidCallback? onChat;
  final VoidCallback? onVisitStore;

  const WholesaleStoreWidget({
    super.key,
    required this.storeName,
    this.storeLogoUrl,
    this.isVerified = false,
    this.isTemporaryClosed = false,
    this.isOnVacation = false,
    this.reviewCount = 0,
    this.productCount = 0,
    this.onChat,
    this.onVisitStore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeTwelve),
      child: Column(
        children: [
          _buildStoreInfoRow(context),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          _buildStatsRow(context),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          _buildVisitStoreButton(context),
        ],
      ),
    );
  }

  Widget _buildStoreInfoRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onVisitStore,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: Row(children: [
              Stack(children: [
                ClipOval(
                  child: CustomImageWidget(
                    image: storeLogoUrl ?? '',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),

                if (isTemporaryClosed || isOnVacation)
                  ClipOval(
                    child: Container(width: 50, height: 50, color: Colors.black.withValues(alpha: .5)),
                  ),

                if (isTemporaryClosed || isOnVacation)
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Text(
                        isTemporaryClosed ? getTranslated('temporary_closed', context)! : getTranslated('close_for_now', context)!,
                        textAlign: TextAlign.center,
                        style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall),
                      ),
                    ),
                  ),
              ]),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(
                        child: Text(
                          storeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titilliumBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        const CustomAssetImageWidget(Images.varifiedBadge, width: 18, height: 18),
                      ],
                    ]),
                    const SizedBox(height: 2),
                    Text(
                      getTranslated('seller_info', context) ?? 'Seller info',
                      style: titilliumBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        InkWell(
          onTap: onChat,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: Container(
            width: 36,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            child: Center(
              child: CustomAssetImageWidget(
                Images.chatIcon,
                width: 16, height: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _buildStat(context, count: reviewCount, label: getTranslated('reviews', context) ?? 'Reviews')),
            Container(width: 1.5, height: 25, color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
            Expanded(child: _buildStat(context, count: productCount, label: getTranslated('products', context) ?? 'Products')),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, {required int count, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            style: titilliumBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: titilliumRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitStoreButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton.icon(
        onPressed: onVisitStore,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          elevation: 0,
        ),
        icon: CustomAssetImageWidget(
          Images.storeIcon,
          width: 20,
          height: 20, color: Colors.white,
        ),
        label: Text(
          getTranslated('visit_store', context) ?? 'Visit Store',
          style: titilliumBold.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
