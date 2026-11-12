import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleShimmerBoxWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const WholesaleShimmerBoxWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius = Dimensions.radiusDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
