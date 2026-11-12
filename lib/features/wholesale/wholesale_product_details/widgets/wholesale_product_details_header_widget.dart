import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/domain/models/wholesale_product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_wishlist/widgets/wholesale_favourite_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:share_plus/share_plus.dart';

class WholesaleProductDetailsHeaderWidget extends StatefulWidget {
  final WholesaleProductDetailsModel product;
  final String? sharableLink;

  const WholesaleProductDetailsHeaderWidget({super.key, required this.product, this.sharableLink});

  @override
  State<WholesaleProductDetailsHeaderWidget> createState() => _WholesaleProductDetailsHeaderWidgetState();
}

class _WholesaleProductDetailsHeaderWidgetState extends State<WholesaleProductDetailsHeaderWidget> {
  int _currentIndex = 0;
  late final PageController _pageController;
  Timer? _shareDebounce;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _shareDebounce?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<ImageFullUrl> get _images => widget.product.allImages;

  void _onShareTap() {
    if (widget.sharableLink == null || (_shareDebounce?.isActive ?? false)) return;
    _shareDebounce = Timer(const Duration(seconds: 1), () {});
    SharePlus.instance.share(ShareParams(text: widget.sharableLink!));
  }

  void _goToPage(int index) {
    _pageController.jumpToPage(index);
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final images = _images;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageCarousel(context, isDark, images),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        _buildThumbnails(context, isDark, images),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        _buildProductName(context),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        _buildStatsRow(context, isDark),
      ],
    );
  }

  Widget _buildImageCarousel(BuildContext context, bool isDark, List<ImageFullUrl> images) {
    return Container(
      color: Colors.transparent,
      child: AspectRatio(
        aspectRatio: 1,
        child: images.isEmpty
            ? const SizedBox.shrink()
            : Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentIndex = i),
                    itemCount: images.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: const Color(0x0D000000), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 1),
                          child: CustomImageWidget(
                            image: images[i].path ?? '',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: Dimensions.paddingSizeSmall,
                      left: Dimensions.paddingSizeSmall,
                      right: Dimensions.paddingSizeSmall,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(images.length, (i) {
                              final bool selected = i == _currentIndex;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: selected ? 16 : 6,
                                height: 6,
                                margin: const EdgeInsetsDirectional.only(end: 4),
                                decoration: BoxDecoration(
                                  color: selected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: Text('${_currentIndex + 1}/${images.length}',
                                style: titilliumRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  PositionedDirectional(
                    top: Dimensions.paddingSizeSmall,
                    end: Dimensions.paddingSizeSmall,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(
                        children: [
                          WholesaleFavouriteButtonWidget(
                            backgroundColor: isDark ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                            productId: widget.product.id,
                            fromProductDetails: true,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          InkWell(
                            onTap: _onShareTap,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.circle,
                                boxShadow: isDark ? null : [
                                  BoxShadow(
                                    color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.10),
                                    spreadRadius: 0,
                                    blurRadius: 15,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Image.asset(Images.share, color: isDark ? Colors.white : Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildThumbnails(BuildContext context, bool isDark, List<ImageFullUrl> images) {
    if (images.length <= 1) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: Dimensions.paddingSizeSmall),
        itemBuilder: (context, i) {
          final bool selected = i == _currentIndex;
          return GestureDetector(
            onTap: () => _goToPage(i),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: selected ? Theme.of(context).primaryColor : (isDark ? Theme.of(context).hintColor.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3)),
                  width: selected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall - 1),
                child: CustomImageWidget(
                  image: images[i].path ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      child: Text(
        widget.product.productName ?? '',
        style: titilliumBold.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: isDark ? Theme.of(context).hintColor.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(child: _buildStatItem(context,
                icon: Icons.star_rounded,
                iconColor: Colors.amber,
                value: (widget.product.rating ?? 0).toStringAsFixed(1),
                subValue: '(${_formatCount(widget.product.reviewCount ?? 0)})',
                label: getTranslated('reviews', context) ?? 'Reviews',
              )),
              _buildDivider(context),
              Expanded(child: _buildStatItem(context,
                value: _formatCount(widget.product.soldCount ?? 0),
                label: getTranslated('sold', context) ?? 'Sold',
              )),
              _buildDivider(context),
              Expanded(child: _buildStatItem(context,
                value: _formatCount(widget.product.currentStock ?? 0),
                label: getTranslated('in_stock', context) ?? 'In Stock',
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    IconData? icon,
    Color? iconColor,
    required String value,
    String? subValue,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeSmall,
        horizontal: Dimensions.paddingSizeExtraSmall,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor, size: Dimensions.iconSizeSmall),
                const SizedBox(width: 2),
              ],
              Text(
                value,
                style: titilliumBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              if (subValue != null) ...[
                const SizedBox(width: 2),
                Text(
                  subValue,
                  style: titilliumBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: titilliumRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Center(child: Container(width: 1, height: 28, color: Theme.of(context).hintColor.withValues(alpha: 0.2)));
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
