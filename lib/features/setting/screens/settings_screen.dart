import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/setting/widgets/select_language_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/features/setting/widgets/select_currency_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Provider.of<SplashController>(context, listen: false).setFromSetting(true);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        Provider.of<SplashController>(context, listen: false).setFromSetting(false);
        return;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: getTranslated('settings', context)),

        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          children: const [
            _ChooseThemeTile(),
            _ChooseLanguageTile(),
            _SelectCurrencyTile(),
          ],
        )
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String icon;
  final String? label;
  final Widget trailing;
  final VoidCallback? onTap;
  const _SettingsTile({required this.icon, required this.label, required this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 3.5,
      onTap: onTap,
      leading: CustomAssetImageWidget(icon, width: 20, height: 20, color: Theme.of(context).hintColor),
      title: Text(label ?? '', style: titilliumRegular.copyWith(
        fontSize: Dimensions.fontSizeDefault,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      )),
      trailing: trailing,
    );
  }
}

class _ChooseThemeTile extends StatelessWidget {
  const _ChooseThemeTile();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, _) {
        return _SettingsTile(
          icon: Images.chooseThemeSettingsIcon,
          label: getTranslated('choose_theme', context),
          trailing: PopupMenuButton<bool>(
            offset: const Offset(0, 45),
            padding: EdgeInsets.zero,
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
            onSelected: (isDark) {
              if (isDark != themeController.darkTheme) {
                themeController.toggleTheme();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<bool>(
                value: false,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                child: _ThemeOptionItem(label: getTranslated('light_theme', context)!, isSelected: !themeController.darkTheme),
              ),
              PopupMenuItem<bool>(
                value: true,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                child: _ThemeOptionItem(label: getTranslated('dark_theme', context)!, isSelected: themeController.darkTheme),
              ),
            ],
            child: _SettingsDropdownChip(
              child: Text(themeController.darkTheme ? getTranslated('dark_theme', context)! : getTranslated('light_theme', context)!,
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOptionItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _ThemeOptionItem({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: .1) : Theme.of(context).cardColor,
      ),
      child: Text(label, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
    );
  }
}

class _ChooseLanguageTile extends StatelessWidget {
  const _ChooseLanguageTile();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationController>(
      builder: (context, localizationController, _) {
        final int languageIndex = localizationController.languageIndex ?? 0;
        return _SettingsTile(
          icon: Images.chooseLanguageSettingsIcon,
          label: getTranslated('choose_language', context),
          onTap: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (_) => const SelectLanguageBottomSheetWidget(),
          ),
          trailing: _SettingsDropdownChip(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: Image.asset(AppConstants.languages[languageIndex].imageUrl!, width: 18, height: 16, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}

class _SelectCurrencyTile extends StatelessWidget {
  const _SelectCurrencyTile();

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashController>(
      builder: (context, splashController, _) {
        return _SettingsTile(
          icon: Images.chooseCurrencySettingsIcon,
          label: getTranslated('select_currency', context),
          onTap: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (_) => const SelectCurrencyBottomSheetWidget(),
          ),
          trailing: _SettingsDropdownChip(
            child: Text(splashController.myCurrency?.name ?? '', style: textRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            )),
          ),
        );
      },
    );
  }
}

class _SettingsDropdownChip extends StatelessWidget {
  final Widget child;
  const _SettingsDropdownChip({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        child,
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Theme.of(context).primaryColor),
      ]),
    );
  }
}
