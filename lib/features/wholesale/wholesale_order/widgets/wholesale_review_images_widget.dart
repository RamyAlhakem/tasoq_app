import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_product_review_model.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';

class WholesaleReviewExistingImagesWidget extends StatelessWidget {
  final int orderId;
  final int productId;
  final WholesaleProductReviewModel review;

  const WholesaleReviewExistingImagesWidget({super.key, required this.orderId, required this.productId, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: SizedBox(
        height: 75,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: review.attachmentFullUrl.length,
          itemBuilder: (context, index) => WholesaleReviewRemovableImage(
            image: CustomImageWidget(image: review.attachmentFullUrl[index], width: 75, height: 75),
            onRemove: index < review.attachment.length
                ? () => Provider.of<WholesaleReviewController>(context, listen: false)
                    .deleteReviewImage(orderId: orderId, productId: productId, name: review.attachment[index])
                : null,
          ),
        ),
      ),
    );
  }
}

class WholesaleReviewPickedImagesWidget extends StatelessWidget {
  const WholesaleReviewPickedImagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleReviewController>(
      builder: (context, reviewController, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: SizedBox(
            height: 75,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: reviewController.reviewImages.length + 1,
              itemBuilder: (context, index) {
                if (index == reviewController.reviewImages.length) {
                  return WholesaleReviewAddImageTile(onTap: reviewController.pickReviewImage);
                }
                return WholesaleReviewRemovableImage(
                  image: Image.file(File(reviewController.reviewImages[index].path), width: 75, height: 75, fit: BoxFit.cover),
                  onRemove: () => reviewController.removeReviewImage(index),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class WholesaleReviewRemovableImage extends StatelessWidget {
  final Widget image;
  final VoidCallback? onRemove;

  const WholesaleReviewRemovableImage({super.key, required this.image, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Stack(children: [
      Padding(
        padding: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeSmall),
        child: Container(
          decoration: BoxDecoration(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.1) : Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)), child: image),
        ),
      ),

      if (onRemove != null)
        PositionedDirectional(
          top: 0, end: 0,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              decoration: BoxDecoration(color: isDark ? Theme.of(context).cardColor : Colors.white, borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))),
              child: Padding(padding: const EdgeInsets.all(4.0), child: Icon(Icons.cancel, color: Theme.of(context).hintColor, size: 15)),
            ),
          ),
        ),
    ]);
  }
}

class WholesaleReviewAddImageTile extends StatelessWidget {
  final VoidCallback onTap;
  const WholesaleReviewAddImageTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeDefault),
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            strokeWidth: 2,
            dashPattern: const [10, 5],
            color: Theme.of(context).hintColor,
            radius: const Radius.circular(Dimensions.paddingSizeSmall),
          ),
          child: Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              child: SizedBox(height: 75, width: 75, child: Image.asset(Images.placeholder, fit: BoxFit.cover)),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
