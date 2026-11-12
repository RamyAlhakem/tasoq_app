import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/auction/auction_feature_banner_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/wholesale/wholesale_feature_banner_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

String getAppModeLabel(BuildContext context, AppMode mode) {
  switch (mode) {
    case AppMode.main:
      return getTranslated('retail', context) ?? 'Retail';
    case AppMode.wholesale:
      return getTranslated('wholesale', context) ?? 'Wholesale';
    case AppMode.auction:
      return getTranslated('auction', context) ?? 'Auction';
  }
}

Future<void> _openPromotionalLink(String? link) async {
  final Uri? uri = Uri.tryParse(link ?? '');
  if (uri != null && uri.hasScheme && await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

void switchAppMode(BuildContext context, SplashController splashController, AppMode targetMode) {
  final AppMode fromMode = splashController.currentMode;
  if (fromMode == targetMode) return;

  switch (targetMode) {
    case AppMode.main:
      splashController.selectMainTab(0);
      break;
    case AppMode.wholesale:
      splashController.enterWholesaleTab();
      break;
    case AppMode.auction:
      splashController.enterAuctionTab();
      break;
  }

  if (targetMode == AppMode.auction && splashController.consumeAuctionBannerEligibility()) {
    showDialog(
      context: context,
      builder: (_) => AuctionFeatureBannerWidget(
        onGetItNow: () => _openPromotionalLink(splashController.configModel?.staticUrls?.auctionPromotionalPopup),
      ),
    );
    return;
  }

  if (targetMode == AppMode.wholesale && splashController.consumeWholesaleBannerEligibility()) {
    showDialog(
      context: context,
      builder: (_) => WholesaleFeatureBannerWidget(
        onGetItNow: () => _openPromotionalLink(splashController.configModel?.staticUrls?.wholesalePromotionalPopup),
      ),
    );
    return;
  }

  showCustomSnackBarWidget(
    getTranslated('module_switch_successfully', context)
      ?.replaceAll('{from}', getAppModeLabel(context, fromMode))
      .replaceAll('{to}', getAppModeLabel(context, targetMode)),
    context,
    snackBarType: SnackBarType.success,
  );
}

class AppModeSelectorWidget extends StatelessWidget {
  const AppModeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashController>(
      builder: (context, splashController, _) {
        final AppMode currentMode = splashController.currentMode;
        return Row(
          children: [
            Expanded(
              child: _ModeSelectorChip(
                icon: Images.retailIcon,
                label: getTranslated('retail', context) ?? 'Retail',
                isSelected: currentMode == AppMode.main,
                onTap: () => switchAppMode(context, splashController, AppMode.main),
              ),
            ),
            if (splashController.isWholesaleEnabled) ...[
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: _ModeSelectorChip(
                  icon: Images.wholesaleIcon,
                  label: getTranslated('wholesale', context) ?? 'Wholesale',
                  isSelected: currentMode == AppMode.wholesale,
                  onTap: () => switchAppMode(context, splashController, AppMode.wholesale),
                ),
              ),
            ],
            if (splashController.isAuctionEnabled) ...[
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: _ModeSelectorChip(
                  icon: Images.auctionIcon,
                  label: getTranslated('auction', context) ?? 'Auction',
                  isSelected: currentMode == AppMode.auction,
                  onTap: () => switchAppMode(context, splashController, AppMode.auction),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ModeSelectorChip extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeSelectorChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).cardColor : Theme.of(context).cardColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          border: isSelected ? null : Border.all(color: Theme.of(context).cardColor.withValues(alpha: 0.30)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAssetImageWidget(icon, height: Dimensions.iconSizeSmall, width: Dimensions.iconSizeSmall),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isSelected
                      ? titleRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: isDark ? Colors.white : Theme.of(context).primaryColor)
                      : titleRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: isDark ? Colors.white : Theme.of(context).cardColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
