import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/models/wholesale_brand_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleBrandItemWidget extends StatelessWidget {
  final WholesaleBrand brand;
  const WholesaleBrandItemWidget({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: brand.id == null ? null : () => RouterHelper.getWholesaleBrandProductsScreenRoute(
        action: RouteAction.push,
        brandId: brand.id!,
        brandName: brand.name,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
            child: CustomImageWidget(image: brand.imageFullUrl?.path ?? ''),
          ),
        )),

        SizedBox(height: (MediaQuery.of(context).size.width / 4) * 0.3, child: Center(
          child: Text(
            brand.name ?? '',
            maxLines: 1, overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        )),
      ]),
    );
  }
}
