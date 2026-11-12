import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_product_review_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_review_images_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_review_product_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';

class WholesaleReviewDialogWidget extends StatefulWidget {
  final int orderId;
  final WholesaleOrderProductItemModel product;
  final VoidCallback? onSubmitted;

  const WholesaleReviewDialogWidget({super.key, required this.orderId, required this.product, this.onSubmitted});

  @override
  State<WholesaleReviewDialogWidget> createState() => _WholesaleReviewDialogWidgetState();
}

class _WholesaleReviewDialogWidgetState extends State<WholesaleReviewDialogWidget> {
  final TextEditingController _commentController = TextEditingController();

  int get _productId => widget.product.productId!;

  @override
  void initState() {
    super.initState();
    final WholesaleReviewController reviewController = Provider.of<WholesaleReviewController>(context, listen: false);
    final WholesaleProductReviewModel? review = reviewController.reviewFor(widget.orderId, _productId);
    reviewController.initReviewForm(review);
    _commentController.text = review?.comment ?? '';
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool _isReviewUnchanged(WholesaleReviewController reviewController, WholesaleProductReviewModel? review) {
    return review != null && review.rating == reviewController.rating && review.comment == _commentController.text.trim() && reviewController.reviewImages.isEmpty;
  }

  void _onSubmit(WholesaleReviewController reviewController) {
    final WholesaleProductReviewModel? review = reviewController.reviewFor(widget.orderId, _productId);
    final String comment = _commentController.text.trim();

    if (reviewController.rating == 0) {
      reviewController.setErrorText('${getTranslated('add_a_rating', context)}');
    } else if (comment.isEmpty) {
      reviewController.setErrorText('${getTranslated('write_a_review', context)}');
    } else if (_isReviewUnchanged(reviewController, review)) {
      reviewController.setErrorText('${getTranslated('modify_review_before_resubmitting', context)}');
    } else {
      reviewController.setErrorText(null);
      reviewController.submitReview(orderId: widget.orderId, productId: _productId, comment: comment).then((value) {
        if (!mounted) return;
        if (value.isSuccess) {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
          widget.onSubmitted?.call();
        } else {
          reviewController.setErrorText(value.message);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleReviewController>(
      builder: (context, reviewController, _) {
        final WholesaleProductReviewModel? review = reviewController.reviewFor(widget.orderId, _productId);

        return SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.all(3),
                    child: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault), color: Theme.of(context).cardColor),
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(Dimensions.homePagePadding),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  WholesaleReviewProductCardWidget(product: widget.product),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Center(child: Text(getTranslated('rate_the_quality', context) ?? '',
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color))),

                  Center(child: WholesaleReviewRatingBarWidget(rating: reviewController.rating, onRatingChanged: reviewController.setRating)),

                  Text(getTranslated('have_thoughts_to_share', context)!,
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomTextFieldWidget(
                    maxLines: 4,
                    hintText: getTranslated('write_your_experience_here', context),
                    controller: _commentController,
                    inputAction: TextInputAction.done,
                  ),

                  if (review != null && review.attachmentFullUrl.isNotEmpty)
                    WholesaleReviewExistingImagesWidget(orderId: widget.orderId, productId: _productId, review: review),

                  const WholesaleReviewPickedImagesWidget(),

                  if (reviewController.errorText != null && reviewController.errorText!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(reviewController.errorText!, style: textRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                    ),

                  CustomButton(
                    isLoading: reviewController.isSubmitting,
                    buttonText: getTranslated('submit', context),
                    onTap: () => _onSubmit(reviewController),
                  ),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class WholesaleReviewRatingBarWidget extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const WholesaleReviewRatingBarWidget({super.key, required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return SizedBox(
      height: 45,
      child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (index) {
        final bool isFilled = rating >= index + 1;
        return InkWell(
          onTap: () => onRatingChanged(index + 1),
          child: Icon(
            isFilled ? Icons.star_rate_rounded : Icons.star_outline_rounded,
            size: 30,
            color: isFilled ? (isDark ? Colors.white : Theme.of(context).primaryColor) : Theme.of(context).primaryColor.withValues(alpha: 0.125),
          ),
        );
      })),
    );
  }
}
