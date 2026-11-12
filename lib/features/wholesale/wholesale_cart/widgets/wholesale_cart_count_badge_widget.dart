import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_cart/controllers/wholesale_cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleCartCountBadgeWidget extends StatelessWidget {
  const WholesaleCartCountBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final int count = context.select<WholesaleCartController, int>((cart) => cart.cart?.cartCount ?? 0);
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: textBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall, height: 1),
      ),
    );
  }
}
