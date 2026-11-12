import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_section_header.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/controllers/wholesale_brand_list_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/domain/models/wholesale_brand_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleHomeBrandSectionWidget extends StatefulWidget {
  const WholesaleHomeBrandSectionWidget({super.key});

  @override
  State<WholesaleHomeBrandSectionWidget> createState() => _WholesaleHomeBrandSectionWidgetState();
}

class _WholesaleHomeBrandSectionWidgetState extends State<WholesaleHomeBrandSectionWidget> {
  static const int _maxBrands = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleBrandListController>(context, listen: false).getBrandList(offset: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleBrandListController>(
      builder: (context, brandController, _) {
        final List<WholesaleBrand>? brands = brandController.brands;

        if (brands != null && brands.isEmpty) return const SizedBox.shrink();

        final List<WholesaleBrand> displayBrands = (brands ?? []).take(_maxBrands).toList();
        final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

        return Container(
          color: isDark ? Theme.of(context).cardColor : Theme.of(context).colorScheme.onTertiary,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WholesaleSectionHeader(
                titleKey: 'brand',
                titleFallback: 'Brand',
                onViewAll: () => RouterHelper.getWholesaleBrandScreenRoute(action: RouteAction.push),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if (brands == null)
                const _WholesaleHomeBrandShimmer()
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                  child: Row(
                    children: [
                      for (int i = 0; i < displayBrands.length; i++)
                        Padding(
                          padding: EdgeInsetsDirectional.only(end: i == displayBrands.length - 1 ? 0 : Dimensions.paddingSizeDefault),
                          child: _WholesaleHomeBrandItem(brand: displayBrands[i]),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],
          ),
        );
      },
    );
  }
}

class _WholesaleHomeBrandItem extends StatelessWidget {
  final WholesaleBrand brand;
  const _WholesaleHomeBrandItem({required this.brand});

  @override
  Widget build(BuildContext context) {
    final double size = ResponsiveHelper.isTab(context) ? 120 : 50;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: brand.id == null ? null : () => RouterHelper.getWholesaleBrandProductsScreenRoute(
        action: RouteAction.push,
        brandId: brand.id!,
        brandName: brand.name,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).highlightColor,
          boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme
              ? null
              : [BoxShadow(color: Colors.grey.withValues(alpha: 0.12), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 1))],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: CustomImageWidget(image: brand.imageFullUrl?.path ?? ''),
        ),
      ),
    );
  }
}

class _WholesaleHomeBrandShimmer extends StatelessWidget {
  const _WholesaleHomeBrandShimmer();

  @override
  Widget build(BuildContext context) {
    final double size = ResponsiveHelper.isTab(context) ? 120 : 50;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      child: Row(
        children: List.generate(
          6,
          (index) => Padding(
            padding: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeDefault),
            child: WholesaleShimmerBoxWidget(width: size, height: size, borderRadius: 5),
          ),
        ),
      ),
    );
  }
}
