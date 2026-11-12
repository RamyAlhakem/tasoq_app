import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/app_mode_selector_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class ShoppingModeSelectionScreen extends StatefulWidget {
  const ShoppingModeSelectionScreen({super.key});

  @override
  State<ShoppingModeSelectionScreen> createState() => _ShoppingModeSelectionScreenState();
}

class _ShoppingModeSelectionScreenState extends State<ShoppingModeSelectionScreen> {
  // No module is preselected; only set once the user taps a card.
  AppMode? _selectedMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
                  child: ConstrainedBox(
                    // Fills the viewport so the content centers vertically,
                    // while still scrolling if it outgrows small screens.
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - (Dimensions.paddingSizeExtraLarge * 2)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header: title + subtitle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              Text(
                                getTranslated('choose_your_shopping_mode', context) ?? '',
                                textAlign: TextAlign.center,
                                style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              Text(
                                getTranslated('choose_shopping_mode_subtitle', context) ?? '',
                                textAlign: TextAlign.center,
                                style: titleRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.headlineLarge?.color,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Consumer<SplashController>(
                          builder: (context, splashController, _) {
                            final List<AppMode> modes = [
                              AppMode.main,
                              if (splashController.isWholesaleEnabled) AppMode.wholesale,
                              if (splashController.isAuctionEnabled) AppMode.auction,
                            ];

                            return Column(
                              children: modes.map((mode) => _ModeCard(
                                mode: mode,
                                isSelected: _selectedMode == mode,
                                onTap: () => _onSelectMode(splashController, mode),
                              )).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),

            // Note
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '#${getTranslated('note', context) ?? 'Note'} : ',
                      style: titleRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: getTranslated('switch_modules_note', context) ?? '',
                      style: titleRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectMode(SplashController splashController, AppMode mode) {
    if (_selectedMode != null) return;
    setState(() => _selectedMode = mode);

    // The dashboard keeps the controller's current mode when opened on the
    // home page, so setting it here is enough to land in the chosen module.
    switch (mode) {
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

    RouterHelper.getDashboardRoute(action: RouteAction.pushNamedAndRemoveUntil);
  }
}

class _ModeCard extends StatelessWidget {
  final AppMode mode;
  final bool isSelected;
  final VoidCallback onTap;
  const _ModeCard({required this.mode, required this.isSelected, required this.onTap});

  String get _icon {
    switch (mode) {
      case AppMode.main:
        return Images.retailIcon;
      case AppMode.wholesale:
        return Images.wholesaleIcon;
      case AppMode.auction:
        return Images.auctionIcon;
    }
  }

  String get _descriptionKey {
    switch (mode) {
      case AppMode.main:
        return 'retail_mode_description';
      case AppMode.wholesale:
        return 'wholesale_mode_description';
      case AppMode.auction:
        return 'auction_mode_description';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.03)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.4)
                  : Theme.of(context).hintColor.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              CustomAssetImageWidget(_icon, height: Dimensions.iconSizeLarge, width: Dimensions.iconSizeLarge),

              const SizedBox(width: Dimensions.paddingSizeTwelve),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getAppModeLabel(context, mode),
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      getTranslated(_descriptionKey, context) ?? '',
                      style: titleRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: Dimensions.paddingSizeSmall),
              isSelected
                  ? CircleAvatar(
                      radius: 9,
                      backgroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                      child: const Icon(Icons.check, color: Colors.white, size: Dimensions.iconSizeSmall),
                    )
                  : Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
