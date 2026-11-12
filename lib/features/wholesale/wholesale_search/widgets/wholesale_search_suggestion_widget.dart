import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/common/basewidgets/wholesale_search_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/controllers/wholesale_search_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

class WholesaleSearchSuggestionWidget extends StatelessWidget {
  final TextEditingController queryController;
  final FocusNode focusNode;

  const WholesaleSearchSuggestionWidget({super.key, required this.queryController, required this.focusNode});

  void _submit(BuildContext context, String term) {
    final String value = term.trim();

    if (value.isEmpty) {
      showCustomSnackBarWidget(getTranslated('enter_somethings', context), context, snackBarType: SnackBarType.warning);
      return;
    }

    focusNode.unfocus();
    queryController.text = value;
    Provider.of<WholesaleSearchController>(context, listen: false).submitSearch(value);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final WholesaleSearchController searchController = context.watch<WholesaleSearchController>();

    return SizedBox(
      height: 56,
      child: RawAutocomplete<String>(
        textEditingController: queryController,
        focusNode: focusNode,
        optionsBuilder: (TextEditingValue value) => searchController.fetchSuggestions(value.text),
        onSelected: (String selected) => _submit(context, selected),
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: AlignmentDirectional.topStart,
          child: Material(
            color: isDark ? Theme.of(context).cardColor : null,
            elevation: 4,
            child: SizedBox(
              height: options.length > 5 ? 250 : options.length * 50,
              width: MediaQuery.sizeOf(context).width - 70,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                itemBuilder: (context, index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                        vertical: Dimensions.paddingSizeDefault,
                      ),
                      child: Row(children: [
                        Icon(Icons.search, size: 18, color: Theme.of(context).hintColor),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: SubstringHighlight(
                            text: option,
                            term: queryController.text,
                            textStyle: textRegular.copyWith(color: Theme.of(context).hintColor),
                            textStyleHighlight: textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                        ),
                        Icon(CupertinoIcons.arrow_up_right, size: 16, color: Theme.of(context).hintColor),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        fieldViewBuilder: (context, textEditingController, fieldFocusNode, onFieldSubmitted) => WholesaleSearchBarWidget(
          controller: textEditingController,
          focusNode: fieldFocusNode,
          hintText: getTranslated('search_products', context),
          onChanged: () => searchController.onQueryChanged(textEditingController.text),
          onSubmitted: (value) => _submit(context, value),
          onSearchPressed: () => _submit(context, textEditingController.text),
          onClearPressed: () {
            textEditingController.clear();
            searchController.cleanSearch(notify: true);
          },
        ),
      ),
    );
  }
}
