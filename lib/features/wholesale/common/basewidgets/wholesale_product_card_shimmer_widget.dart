import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleProductCardShimmerWidget extends StatelessWidget {
  const WholesaleProductCardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context).darkTheme;
    final Color shimmerColor = isDark
        ? Theme.of(context).primaryColor.withValues(alpha: .05)
        : Theme.of(context).cardColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            _ShimmerLine(color: shimmerColor, width: constraints.maxWidth),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            _ShimmerLine(color: shimmerColor, width: constraints.maxWidth * 0.7),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            _ShimmerLine(color: shimmerColor, width: constraints.maxWidth * 0.5),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            _ShimmerLine(color: shimmerColor, width: constraints.maxWidth * 0.35),
          ],
        );
      },
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  final Color color;
  final double width;

  const _ShimmerLine({required this.color, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: width,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
    );
  }
}
