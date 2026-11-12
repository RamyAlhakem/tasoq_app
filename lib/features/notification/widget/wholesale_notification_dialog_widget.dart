import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/domain/models/notification_model.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleNotificationDialogWidget extends StatelessWidget {
  final WholesaleNotificationItem item;
  const WholesaleNotificationDialogWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final String imagePath = item.imageFullUrl ?? '';

    return Material(
      color: isDark ? Theme.of(context).cardColor : null,
      shape: isDark ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))) : null,
      child: Stack(
      children: [
        SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: Dimensions.paddingSizeDefault, width: double.infinity),

          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40, height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),

          if (imagePath.isNotEmpty)
            Container(
              height: MediaQuery.of(context).size.width - 130,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.20)),
              child: CustomImageWidget(
                image: imagePath,
                height: MediaQuery.of(context).size.width - 130,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(item.title ?? '',
              textAlign: TextAlign.center,
              style: titilliumSemiBold.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: Dimensions.fontSizeLarge,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(item.description ?? '',
              textAlign: TextAlign.center,
              style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),
        ])),

        PositionedDirectional(
          end: 0, top: 0,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, opticalSize: 3),
          ),
        ),
      ],
    ));
  }
}
