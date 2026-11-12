import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_seller_card_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleSellerCardShimmerListWidget extends StatelessWidget {
  static const int _itemCount = 4;

  const WholesaleSellerCardShimmerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Dimensions.homePagePadding),
      itemCount: _itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: Dimensions.paddingSizeDefault),
      itemBuilder: (_, __) => const WholesaleSellerCardShimmerWidget(),
    );
  }
}
