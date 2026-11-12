import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';

class WholesaleRefundImageSelectionWidget extends StatelessWidget {
  const WholesaleRefundImageSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Consumer<WholesaleRefundController>(
      builder: (context, refundController, _) {
        return Column(children: [
          refundController.refundImages.isNotEmpty
              ? SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: refundController.refundImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.1) : Colors.white, borderRadius: const BorderRadius.all(Radius.circular(20))),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                              child: Image.file(File(refundController.refundImages[index]!.path), width: 100, height: 100, fit: BoxFit.cover),
                            ),
                          ),
                          PositionedDirectional(
                            top: 0,
                            end: 0,
                            child: InkWell(
                              onTap: () => refundController.removeRefundImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.clear, color: Colors.white, size: Dimensions.iconSizeExtraSmall),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      );
                    },
                  ),
                )
              : const SizedBox(),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: InkWell(
              onTap: () => refundController.pickRefundImage(false),
              child: SizedBox(
                height: 30,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(getTranslated('upload_image', context)!, style: textRegular.copyWith(color: isDark ? Colors.white : Theme.of(context).primaryColor)),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Image.asset(Images.uploadImage, color: isDark ? Colors.white : Theme.of(context).primaryColor),
                ]),
              ),
            ),
          ),
        ]);
      },
    );
  }
}
