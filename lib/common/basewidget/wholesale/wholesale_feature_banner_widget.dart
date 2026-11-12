import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class WholesaleFeatureBannerWidget extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onGetItNow;

  const WholesaleFeatureBannerWidget({super.key, this.onClose, this.onGetItNow});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WholesaleFeatureBannerHeader(onClose: onClose),
          WholesaleFeatureBannerBody(onGetItNow: onGetItNow),
        ],
      ),
    );
  }
}

class WholesaleFeatureBannerHeader extends StatelessWidget {
  final VoidCallback? onClose;

  const WholesaleFeatureBannerHeader({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, const Color(0xFF2D6EC8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomAssetImageWidget(Images.circleBg, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 22, 12, 18),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: CustomAssetImageWidget(Images.wholesaleIcon, width: 26, height: 26)),
                ),
                const SizedBox(height: 15),
                Text(
                  getTranslated('new_business_opportunities_with_wholesale', context) ?? '',
                  textAlign: TextAlign.center,
                  style: titleHeader.copyWith(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    getTranslated('wholesale_banner_subtitle', context) ?? '',
                    textAlign: TextAlign.center,
                    style: titilliumRegular.copyWith(color: Colors.white.withValues(alpha: 0.85), fontSize: 12, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onClose ?? () => Navigator.of(context).pop(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WholesaleFeatureBannerBody extends StatelessWidget {
  final VoidCallback? onGetItNow;

  const WholesaleFeatureBannerBody({super.key, this.onGetItNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const WholesaleFeatureGrid(),
          const SizedBox(height: 10),
          const WholesaleRatingRow(),
          const SizedBox(height: 12),
          WholesaleGetItNowButton(onGetItNow: onGetItNow),
          const SizedBox(height: 12),
          const WholesaleWarningText(),
        ],
      ),
    );
  }
}

class WholesaleGetItNowButton extends StatelessWidget {
  final VoidCallback? onGetItNow;

  const WholesaleGetItNowButton({super.key, this.onGetItNow});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: onGetItNow,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).cardColor,
          disabledBackgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(getTranslated('get_it_now', context) ?? '', style: textBold.copyWith(color: Colors.white, fontSize: 14)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class WholesaleWarningText extends StatelessWidget {
  const WholesaleWarningText({super.key});

  @override
  Widget build(BuildContext context) {
    final fullText = getTranslated('wholesale_addon_warning', context) ?? '';
    const boldWord = 'Add-on';
    final splitIndex = fullText.indexOf(boldWord);
    final errorColor = Theme.of(context).colorScheme.error;
    final baseStyle = titilliumRegular.copyWith(color: errorColor, fontSize: 10, height: 1.3);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.warning, color: errorColor, size: 12),
        const SizedBox(width: 2),
        Expanded(
          child: splitIndex == -1
              ? Text(fullText, style: baseStyle)
              : Text.rich(
                  TextSpan(
                    style: baseStyle,
                    children: [
                      TextSpan(text: fullText.substring(0, splitIndex)),
                      TextSpan(text: boldWord, style: baseStyle.copyWith(fontWeight: FontWeight.bold)),
                      TextSpan(text: fullText.substring(splitIndex + boldWord.length)),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class WholesaleFeatureGrid extends StatelessWidget {
  const WholesaleFeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      _WholesaleFeatureItem(Images.moreTrafficIcon, getTranslated('wholesale_feature_reach_buyers', context) ?? ''),
      _WholesaleFeatureItem(Images.extraRevenueIcon, getTranslated('wholesale_feature_commission', context) ?? ''),
      _WholesaleFeatureItem(Images.wholesaleDiscountIcon, getTranslated('wholesale_feature_tiered_pricing', context) ?? ''),
      _WholesaleFeatureItem(Images.instantLunchIcon, getTranslated('wholesale_feature_launch_store', context) ?? ''),
    ];

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: WholesaleFeatureCard(feature: features[0])),
              const SizedBox(width: 8),
              Expanded(child: WholesaleFeatureCard(feature: features[1])),
            ],
          ),
        ),
        const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: WholesaleFeatureCard(feature: features[2])),
              const SizedBox(width: 8),
              Expanded(child: WholesaleFeatureCard(feature: features[3])),
            ],
          ),
        ),
      ],
    );
  }
}

class WholesaleFeatureCard extends StatelessWidget {
  final _WholesaleFeatureItem feature;

  const WholesaleFeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
            child: Center(child: CustomAssetImageWidget(feature.icon, width: 16, height: 16)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              feature.text,
              style: titilliumRegular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 10,
                height: 1.0,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class WholesaleRatingRow extends StatelessWidget {
  const WholesaleRatingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomAssetImageWidget(Images.fiveStarIcon, width: 72, height: 10),
        const SizedBox(width: 6),
        Text(
          getTranslated('trusted_by_sellers', context) ?? '',
          style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color, fontSize: 10),
        ),
      ],
    );
  }
}

class _WholesaleFeatureItem {
  final String icon;
  final String text;

  const _WholesaleFeatureItem(this.icon, this.text);
}
