import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/domain/models/wholesale_product_review_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_review_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_review_reply_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';

class WholesaleReviewButtonWidget extends StatefulWidget {
  final int orderId;
  final WholesaleOrderProductItemModel product;

  const WholesaleReviewButtonWidget({super.key, required this.orderId, required this.product});

  @override
  State<WholesaleReviewButtonWidget> createState() => _WholesaleReviewButtonWidgetState();
}

class _WholesaleReviewButtonWidgetState extends State<WholesaleReviewButtonWidget> {
  int get _productId => widget.product.productId!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleReviewController>(context, listen: false).getReview(widget.orderId, _productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Consumer<WholesaleReviewController>(
      builder: (context, reviewController, _) {
        final WholesaleProductReviewModel? review = reviewController.reviewFor(widget.orderId, _productId);
        final bool isExpanded = review != null && reviewController.isExpanded(widget.orderId, _productId);
        final bool isLoading = !reviewController.isReviewLoaded(widget.orderId, _productId) && reviewController.isReviewLoadingFor(widget.orderId, _productId);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.10),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(children: [
                const CustomAssetImageWidget(Images.myReviewIcon, height: 30, width: 30),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text('${getTranslated('my_review', context)}', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                if (review != null)
                  WholesaleReviewExpandToggle(
                    isExpanded: isExpanded,
                    onTap: () => reviewController.toggleExpanded(widget.orderId, _productId),
                  ),

                const Spacer(),

                if (isLoading)
                  SizedBox(
                    height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).primaryColor),
                  )
                else
                  InkWell(
                    onTap: () {
                      if (isExpanded) reviewController.toggleExpanded(widget.orderId, _productId);
                      showDialog(context: context, builder: (_) => Dialog(
                        insetPadding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        child: WholesaleReviewDialogWidget(
                          orderId: widget.orderId,
                          product: widget.product,
                          onSubmitted: () => showCustomSnackBarWidget(getTranslated('review_submitted_successfully', context), context, snackBarType: SnackBarType.success),
                        ),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.70),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      child: Text(
                        review == null ? '${getTranslated('review_product', context)}' : '${getTranslated('update_review', context)}',
                        style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: isDark ? Colors.white : Theme.of(context).scaffoldBackgroundColor),
                      ),
                    ),
                  ),
              ]),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: isExpanded ? WholesaleReviewReplyViewWidget(review: review) : const SizedBox.shrink(),
            ),
          ]),
        );
      },
    );
  }
}

class WholesaleReviewExpandToggle extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const WholesaleReviewExpandToggle({super.key, required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Container(
      height: 25, width: 25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).cardColor,
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.15), offset: const Offset(0, 4), blurRadius: 4, spreadRadius: 0)],
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
      ),
    );
  }
}
