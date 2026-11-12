import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleCartImageGalleryWidget extends StatefulWidget {
  final List<String> images;
  final List<String> tabLabels;
  final int selectedTabIndex;
  final ValueChanged<int>? onTabChanged;

  const WholesaleCartImageGalleryWidget({
    super.key,
    required this.images,
    this.tabLabels = const [],
    this.selectedTabIndex = 0,
    this.onTabChanged,
  });

  @override
  State<WholesaleCartImageGalleryWidget> createState() => _WholesaleCartImageGalleryWidgetState();
}

class _WholesaleCartImageGalleryWidgetState extends State<WholesaleCartImageGalleryWidget> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    setState(() => _pageIndex = index);
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final int totalImages = widget.images.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.tabLabels.isNotEmpty)
          _WholesaleCartImageGalleryTabBar(
            labels: widget.tabLabels,
            selectedIndex: widget.selectedTabIndex,
            onChanged: widget.onTabChanged,
          ),
        if (widget.tabLabels.isNotEmpty) const SizedBox(height: Dimensions.paddingSizeSmall),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.25)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(children: [
              totalImages > 0
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: totalImages,
                      onPageChanged: (index) => setState(() => _pageIndex = index),
                      itemBuilder: (context, index) => CustomImageWidget(image: widget.images[index], fit: BoxFit.contain),
                    )
                  : const SizedBox(),
              if (totalImages > 1)
                PositionedDirectional(
                  bottom: Dimensions.paddingSizeSmall,
                  end: Dimensions.paddingSizeSmall,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraExtraSmall),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(Dimensions.radiusThirty),
                    ),
                    child: Text('${_pageIndex + 1}/$totalImages', style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white)),
                  ),
                ),
            ]),
          ),
        ),
        if (totalImages > 1) ...[
          const SizedBox(height: Dimensions.paddingSizeSmall),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: totalImages,
              separatorBuilder: (_, __) => const SizedBox(width: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) => _WholesaleCartImageGalleryThumbnail(
                image: widget.images[index],
                isSelected: index == _pageIndex,
                onTap: () => _goToPage(index),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _WholesaleCartImageGalleryTabBar extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const _WholesaleCartImageGalleryTabBar({required this.labels, required this.selectedIndex, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final bool isSelected = index == selectedIndex;
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeLarge),
          child: InkWell(
            onTap: () => onChanged?.call(index),
            child: Container(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent, width: 2)),
              ),
              child: Text(
                labels[index],
                style: (isSelected ? titilliumSemiBold : titilliumRegular).copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _WholesaleCartImageGalleryThumbnail extends StatelessWidget {
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const _WholesaleCartImageGalleryThumbnail({required this.image, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.25), width: isSelected ? 2 : 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: CustomImageWidget(image: image, fit: BoxFit.cover),
      ),
    );
  }
}
