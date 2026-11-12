import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleMostDemandedProductCardShimmerWidget extends StatelessWidget {
  const WholesaleMostDemandedProductCardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WholesaleShimmerBoxWidget(
              width: 108,
              height: 107,
              borderRadius: 0,
            ),
            Container(width: 2, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WholesaleShimmerBoxWidget(height: 10, width: constraints.maxWidth),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        WholesaleShimmerBoxWidget(height: 10, width: constraints.maxWidth * 0.7),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        WholesaleShimmerBoxWidget(height: 12, width: constraints.maxWidth * 0.5),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        WholesaleShimmerBoxWidget(height: 10, width: constraints.maxWidth * 0.4),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
