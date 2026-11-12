import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_product_specification_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_product_details/widgets/wholesale_review_section_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleFaqItem {
  final String question;
  final String answer;

  const WholesaleFaqItem({required this.question, required this.answer});
}

enum WholesaleProductInfoTab { specification, reviews, faq }

class WholesaleProductSpecificationReviewFaqWidget extends StatefulWidget {
  final double? averageReview;
  final List<WholesaleFaqItem> faqItems;
  final String productSlug;
  final String? details;

  const WholesaleProductSpecificationReviewFaqWidget({
    super.key,
    this.averageReview,
    this.faqItems = const [],
    required this.productSlug,
    this.details,
  });

  @override
  State<WholesaleProductSpecificationReviewFaqWidget> createState() => _WholesaleProductSpecificationReviewFaqWidgetState();
}

class _WholesaleProductSpecificationReviewFaqWidgetState extends State<WholesaleProductSpecificationReviewFaqWidget> {
  late WholesaleProductInfoTab _selectedTab;

  bool get _hasSpecification => widget.details != null && widget.details!.trim().isNotEmpty;
  bool get _hasReviews => (widget.averageReview ?? 0) > 0;
  bool get _hasFaqs => widget.faqItems.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _selectedTab = _hasSpecification
        ? WholesaleProductInfoTab.specification : (_hasReviews ? WholesaleProductInfoTab.reviews : WholesaleProductInfoTab.faq);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasSpecification && !_hasReviews && !_hasFaqs) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WholesaleProductInfoTabRow(
            hasSpecification: _hasSpecification,
            hasReviews: _hasReviews,
            hasFaqs: _hasFaqs,
            selectedTab: _selectedTab,
            onSelect: (tab) => setState(() => _selectedTab = tab),
          ),
          WholesaleProductInfoTabContent(
            selectedTab: _selectedTab,
            details: _hasSpecification ? widget.details : null,
            productSlug: widget.productSlug,
            faqItems: widget.faqItems,
          ),
        ],
      ),
    );
  }
}

class WholesaleProductInfoTabRow extends StatelessWidget {
  final bool hasSpecification;
  final bool hasReviews;
  final bool hasFaqs;
  final WholesaleProductInfoTab selectedTab;
  final ValueChanged<WholesaleProductInfoTab> onSelect;

  const WholesaleProductInfoTabRow({
    super.key,
    required this.hasSpecification,
    required this.hasReviews,
    required this.hasFaqs,
    required this.selectedTab,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (hasSpecification) ...[
            WholesaleProductInfoTabButton(
              label: getTranslated('specification', context) ?? 'Specification',
              isSelected: selectedTab == WholesaleProductInfoTab.specification,
              onTap: () => onSelect(WholesaleProductInfoTab.specification),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
          ],
          if (hasReviews) ...[
            WholesaleProductInfoTabButton(
              label: getTranslated('reviews', context) ?? 'Reviews',
              isSelected: selectedTab == WholesaleProductInfoTab.reviews,
              onTap: () => onSelect(WholesaleProductInfoTab.reviews),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
          ],
          if (hasFaqs)
            WholesaleProductInfoTabButton(
              label: getTranslated('faq', context) ?? 'FAQ',
              isSelected: selectedTab == WholesaleProductInfoTab.faq,
              onTap: () => onSelect(WholesaleProductInfoTab.faq),
            ),
        ],
      ),
    );
  }
}

class WholesaleProductInfoTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const WholesaleProductInfoTabButton({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
              vertical: Dimensions.paddingSizeSmall,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              color: isSelected
                  ? (isDark ? Theme.of(context).hintColor.withValues(alpha: 0.25) : Theme.of(context).primaryColor.withValues(alpha: 0.05))
                  : Colors.transparent,
            ),
            child: Text(
              label,
              style: textMedium.copyWith(
                color: isDark
                    ? Theme.of(context).hintColor : isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
              ),
            ),
          ),
          if (isSelected)
            Container(width: 40, height: 2, color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}

class WholesaleProductInfoTabContent extends StatelessWidget {
  final WholesaleProductInfoTab selectedTab;

  final String? details;
  final String productSlug;
  final List<WholesaleFaqItem> faqItems;

  const WholesaleProductInfoTabContent({
    super.key,
    required this.selectedTab,
    this.details,
    required this.productSlug,
    this.faqItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case WholesaleProductInfoTab.faq:
        return WholesaleFaqContent(faqItems: faqItems);
      case WholesaleProductInfoTab.reviews:
        return WholesaleReviewSectionWidget(productSlug: productSlug);
      case WholesaleProductInfoTab.specification:
        if (details == null) return const SizedBox.shrink();
        return WholesaleProductSpecificationWidget(
          specification: ProductHelper.removeIframe(details!),
        );
    }
  }
}

class WholesaleFaqContent extends StatelessWidget {
  final List<WholesaleFaqItem> faqItems;

  const WholesaleFaqContent({super.key, required this.faqItems});

  @override
  Widget build(BuildContext context) {
    if (faqItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslated('frequently_asked_questions', context) ?? 'Frequently Asked Questions',
          style: titilliumBold.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        ...faqItems.map((item) => WholesaleFaqTile(item: item)),
      ],
    );
  }
}

class WholesaleFaqTile extends StatefulWidget {
  final WholesaleFaqItem item;

  const WholesaleFaqTile({super.key, required this.item});

  @override
  State<WholesaleFaqTile> createState() => _WholesaleFaqTileState();
}

class _WholesaleFaqTileState extends State<WholesaleFaqTile> {
  bool _expanded = false;

  static final RegExp _rtlCharacters = RegExp(r'[\u0590-\u08FF\uFB1D-\uFDFF\uFE70-\uFEFF]');

  static String _keepReadingOrder(String text) => _rtlCharacters.hasMatch(text) ? text : '\u200E$text\u200E';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _keepReadingOrder(widget.item.question),
                    style: titilliumBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                _keepReadingOrder(widget.item.answer),
                style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
        ],
        Divider(height: 1, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
      ],
    );
  }
}
