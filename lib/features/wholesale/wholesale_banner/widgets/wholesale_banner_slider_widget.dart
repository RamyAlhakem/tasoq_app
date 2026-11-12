import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_shimmer_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/controllers/wholesale_banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/domain/models/wholesale_banner_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_banner/domain/wholesale_banner_enum.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleBannerSliderWidget extends StatefulWidget {
  final WholesaleBannerTypeEnum? bannerType;
  final EdgeInsetsGeometry? padding;
  final double aspectRatio;

  const WholesaleBannerSliderWidget({super.key, this.bannerType, this.padding, this.aspectRatio = 2});

  @override
  State<WholesaleBannerSliderWidget> createState() => _WholesaleBannerSliderWidgetState();
}

class _WholesaleBannerSliderWidgetState extends State<WholesaleBannerSliderWidget> {
  int _currentIndex = 0;

  String? get _bannerType => widget.bannerType?.value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<WholesaleBannerController>(context, listen: false).getBannerList(bannerType: _bannerType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry padding = widget.padding ?? const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding);
    final double width = MediaQuery.sizeOf(context).width - padding.horizontal;
    final double height = width / widget.aspectRatio;

    return Consumer<WholesaleBannerController>(
      builder: (context, bannerController, _) {
        final List<WholesaleBanner>? banners = bannerController.bannersOf(_bannerType);

        if (banners != null && banners.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: padding,
          child: banners == null
              ? WholesaleShimmerBoxWidget(height: height, borderRadius: Dimensions.paddingSizeExtraSmall)
              : Column(mainAxisSize: MainAxisSize.min, children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      initialPage: _currentIndex < banners.length ? _currentIndex : 0,
                      height: height,
                      viewportFraction: 1,
                      autoPlay: banners.length > 1,
                      pauseAutoPlayOnTouch: true,
                      pauseAutoPlayOnManualNavigate: true,
                      pauseAutoPlayInFiniteScroll: true,
                      enlargeFactor: 0,
                      enlargeCenterPage: true,
                      disableCenter: true,
                      onPageChanged: (index, _) => setState(() => _currentIndex = index),
                    ),
                    itemCount: banners.length,
                    itemBuilder: (context, index, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: InkWell(
                        onTap: () => bannerController.clickBannerRedirect(banners[index]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          child: CustomImageWidget(width: width, height: height, image: banners[index].image),
                        ),
                      ),
                    ),
                  ),

                  if (banners.length > 1) ...[
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    SizedBox(
                      height: Dimensions.paddingSizeExtraSmall,
                      child: ListView.separated(
                        separatorBuilder: (_, __) => const SizedBox(width: 3),
                        itemCount: banners.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Container(
                          width: _currentIndex == index ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraSmall,
                          height: Dimensions.paddingSizeExtraSmall,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: _currentIndex == index ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ]),
        );
      },
    );
  }
}
