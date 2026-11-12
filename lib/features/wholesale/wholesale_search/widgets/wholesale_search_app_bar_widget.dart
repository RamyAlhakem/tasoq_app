import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_search/widgets/wholesale_search_suggestion_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController queryController;
  final FocusNode focusNode;
  final VoidCallback? onBackPressed;

  const WholesaleSearchAppBar({
    super.key,
    required this.queryController,
    required this.focusNode,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      titleSpacing: 0,
      elevation: 0,
      scrolledUnderElevation: 0,
      clipBehavior: Clip.none,
      shadowColor: Colors.transparent,
      title: Row(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18,
                color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: .75)),
            onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeDefault),
            child: WholesaleSearchSuggestionWidget(queryController: queryController, focusNode: focusNode),
          ),
        ),
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
