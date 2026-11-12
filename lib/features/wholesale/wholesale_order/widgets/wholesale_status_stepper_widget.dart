import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/tracking/widgets/line_dashed_widget.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleStatusStepperWidget extends StatelessWidget {
  final String title;
  final bool isLastItem;
  final String icon;
  final bool checked;
  final String? dateTimeLabel;
  final bool isCanceled;
  final bool isNextTrue;
  final bool isStatusCanceled;

  const WholesaleStatusStepperWidget({super.key,
    required this.title, this.isLastItem = false, required this.icon,
    this.checked = false, this.dateTimeLabel, this.isCanceled = false,
    this.isNextTrue = false, this.isStatusCanceled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    final Color myColor = (checked && !isStatusCanceled)
        ? (isDark ? Colors.white : Theme.of(context).primaryColor)
        : (isDark ? Theme.of(context).hintColor.withValues(alpha: .75) : Theme.of(context).hintColor);

    return Container(height: 100,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [

            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Container(padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  color: Theme.of(context).primaryColor.withValues(alpha: .075)),
                child: SizedBox(height: 30, child: CustomAssetImageWidget(icon, color: (checked || isStatusCanceled) ? (isDark ? Colors.white : Theme.of(context).primaryColor) : Theme.of(context).hintColor)),
              ),
            ),

            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              checked ?
              Text(title, style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)) :
              Text(title, style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),

              if (dateTimeLabel != null)
                Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                  child: Text(dateTimeLabel!, textDirection: TextDirection.ltr,
                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleMedium?.color?.withValues(alpha: 0.85))),
                ),
            ]),
          ]),

          isLastItem ? const SizedBox.shrink() :
          isNextTrue || (!isNextTrue && isCanceled && !isStatusCanceled) ?
          Padding(padding: const EdgeInsetsDirectional.only(
            top: Dimensions.paddingSizeExtraExtraSmall,
            bottom: Dimensions.paddingSizeExtraExtraSmall, start: 35,
          ),
            child: CustomPaint(painter: LineSolidWidget(Theme.of(context).primaryColor)),
          ) :
          Padding(padding: const EdgeInsetsDirectional.only(top: Dimensions.paddingSizeExtraSmall, start: 35),
            child: CustomPaint(painter: LineDashedWidget(myColor)),
          ),
        ])),

        if ((checked || isStatusCanceled))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(isStatusCanceled ? Icons.cancel : CupertinoIcons.checkmark_alt_circle_fill,
              color: isStatusCanceled ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onTertiaryContainer),
          ),
      ]),
    );
  }
}
