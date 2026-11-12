import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_loader_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_discount_badge_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/controllers/wholesale_restock_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/domain/models/wholesale_restock_request_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleRestockListItemWidget extends StatelessWidget {
  final WholesaleRestockRequestItem item;
  const WholesaleRestockListItemWidget({super.key, required this.item});

  bool get _hasDiscount => (item.product?.discountedPercentage ?? 0) > 0;

  void _openDetails(BuildContext context) {
    final String? slug = item.product?.slug;
    if (slug == null || slug.isEmpty) return;
    RouterHelper.getWholesaleProductDetailsRoute(slug: slug, action: RouteAction.push);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final product = item.product;
    final double minDiscounted = product?.minDiscountedPrice ?? product?.minPrice ?? 0;
    final double maxDiscounted = product?.maxDiscountedPrice ?? product?.maxPrice ?? 0;
    final bool isRange = minDiscounted != maxDiscounted;

    return InkWell(
      onTap: () => _openDetails(context),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.homePagePadding),
        margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), spreadRadius: 0, blurRadius: 7, offset: const Offset(0, 1)),
          ],
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
        child: IntrinsicHeight(
          child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  border: Border.all(width: 1, color: Colors.black.withValues(alpha: 0.1)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  child: CustomImageWidget(width: 70, height: 70, image: '${product?.thumbnailFullUrl?.path}'),
                ),
              ),
              if (_hasDiscount) PositionedDirectional(top: 0, start: 0, child: WholesaleDiscountBadgeWidget(percentage: product!.discountedPercentage!, radius: Dimensions.paddingSizeExtraSmall)),
            ]),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(
                  product?.productName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                )),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                InkWell(
                  onTap: () async {
                    showDialog(context: context, builder: (ctx) => const CustomLoaderWidget());
                    await Provider.of<WholesaleRestockController>(context, listen: false).deleteRestockRequest(id: item.id);
                    if (Get.context != null) Navigator.of(Get.context!).pop();
                  },
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.error),
                    child: Center(child: Icon(Icons.close, color: isDark ? Colors.white : Theme.of(context).cardColor, weight: 15, size: 15)),
                  ),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              if (item.variant != null && item.variant!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                  child: Text(
                    '${getTranslated('variant', context) ?? 'Variant'} : ${item.variant}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                  ),
                ),

              Row(children: [
                _hasDiscount
                    ? CustomDirectionalityWidget(
                        child: Text(
                          isRange
                              ? '${PriceConverter.convertPrice(context, product?.minPrice)} – ${PriceConverter.convertPrice(context, product?.maxPrice)}'
                              : PriceConverter.convertPrice(context, product?.minPrice),
                          style: titilliumSemiBold.copyWith(
                            color: isDark ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                            decoration: TextDecoration.lineThrough,
                            decorationColor: isDark ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                          ),
                        ),
                      )
                    : const SizedBox(),
                _hasDiscount ? const SizedBox(width: Dimensions.paddingSizeSmall) : const SizedBox(),

                Flexible(child: CustomDirectionalityWidget(
                  child: Text(
                    isRange
                        ? '${PriceConverter.convertPrice(context, minDiscounted)}-${PriceConverter.convertPrice(context, maxDiscounted)}'
                        : PriceConverter.convertPrice(context, minDiscounted),
                    style: robotoBold.copyWith(color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).primaryColor),
                  ),
                )),
              ]),

              if (product?.minimumOrderQuantity != null && (product?.minimumOrderQuantity ?? 0) > 0) ...[
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text(
                  '${getTranslated('moq', context) ?? 'MOQ'} : ${product?.minimumOrderQuantity}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),
              ],

              const Spacer(),
            ])),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          ]),
        ),
      ),
    );
  }
}
