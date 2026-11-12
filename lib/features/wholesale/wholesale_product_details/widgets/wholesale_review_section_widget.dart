import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/widgets/overall_rating_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/widgets/review_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/controllers/wholesale_product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleReviewSectionWidget extends StatefulWidget {
  final String productSlug;

  const WholesaleReviewSectionWidget({super.key, required this.productSlug});

  @override
  State<WholesaleReviewSectionWidget> createState() => _WholesaleReviewSectionWidgetState();
}

class _WholesaleReviewSectionWidgetState extends State<WholesaleReviewSectionWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final WholesaleProductDetailsController controller = Provider.of<WholesaleProductDetailsController>(context, listen: false);
      if (!controller.hasReviewsFor(widget.productSlug)) controller.getProductReviews(widget.productSlug);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleProductDetailsController>(
      builder: (context, controller, _) {
        final List<ReviewModel>? reviews = controller.reviews;

        if (reviews == null) return const ReviewShimmer();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OverallRatingWidget(
              averageRating: controller.averageRating,
              totalReviews: controller.totalReviews,
              fiveStar: controller.reviewCountFor(5),
              fourStar: controller.reviewCountFor(4),
              threeStar: controller.reviewCountFor(3),
              twoStar: controller.reviewCountFor(2),
              oneStar: controller.reviewCountFor(1),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            ...reviews.map((review) => ReviewWidget(reviewModel: review)),

            if (controller.hasMoreReviews)
              Center(
                child: controller.isReviewLoading
                    ? const Padding(
                        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: CircularProgressIndicator(),
                      )
                    : InkWell(
                        onTap: controller.loadMoreReviews,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                          child: Text(
                            getTranslated('see_more_reviews', context)!,
                            style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
              ),
          ],
        );
      },
    );
  }
}
