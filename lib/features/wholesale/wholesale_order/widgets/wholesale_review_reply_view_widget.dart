import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_product_review_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleReviewReplyViewWidget extends StatelessWidget {
  final WholesaleProductReviewModel? review;
  const WholesaleReviewReplyViewWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final WholesaleProductReviewModel? review = this.review;
    if (review == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
        child: Text(getTranslated('no_review_found', context)!, style: titleRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault).copyWith(top: 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          review.createdAt != null
              ? Text(DateConverter.dateTimeStringToMonthDateAndTime(review.createdAt!), textDirection: TextDirection.ltr,
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor))
              : const SizedBox(),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.star_rate_rounded, color: Colors.orange, size: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text('(${review.rating.toDouble().toStringAsFixed(1)})',
                style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
            ),
          ]),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        ReadMoreText(
          review.comment,
          trimMode: TrimMode.Line,
          trimLines: 3,
          textAlign: TextAlign.justify,
          preDataTextStyle: const TextStyle(fontWeight: FontWeight.w500),
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          colorClickableText: isDark ? Colors.white : Theme.of(context).primaryColor,
          trimCollapsedText: getTranslated('view_moree', context)!,
          trimExpandedText: '   ${getTranslated('view_less', context)!}',
        ),

        if (review.attachmentFullUrl.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
            child: SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.attachmentFullUrl.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeSmall),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                    child: CustomImageWidget(height: 40, width: 40, image: review.attachmentFullUrl[index]),
                  ),
                ),
              ),
            ),
          ),

        if (review.reply != null) ...[
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Row(children: [
            Image.asset(Images.sellerReplyIcon, height: 20, width: 20),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Text(getTranslated('reply_by_seller', context)!, style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null)),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          if (review.reply!.createdAt != null) ...[
            Text(DateConverter.dateTimeStringToMonthDateAndTime(review.reply!.createdAt!), textDirection: TextDirection.ltr,
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          ],

          ReadMoreText(
            review.reply!.replyText,
            trimMode: TrimMode.Line,
            trimLines: 3,
            textAlign: TextAlign.justify,
            preDataTextStyle: const TextStyle(fontWeight: FontWeight.w500),
            colorClickableText: isDark ? Colors.white : Theme.of(context).primaryColor,
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
            trimCollapsedText: getTranslated('view_moree', context)!,
            trimExpandedText: getTranslated('view_less', context)!,
          ),
        ],
      ]),
    );
  }
}
