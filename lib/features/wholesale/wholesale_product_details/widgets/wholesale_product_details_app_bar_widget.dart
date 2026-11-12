import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleProductDetailsAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const WholesaleProductDetailsAppBarWidget({super.key, required this.title, this.onBackPressed});

  static const double _height = 50;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      toolbarHeight: _height,
      iconTheme: IconThemeData(color: Theme.of(context).textTheme.bodyLarge?.color),
      automaticallyImplyLeading: false,
      centerTitle: true,
      excludeHeaderSemantics: true,
      titleSpacing: 0,
      elevation: 1,
      clipBehavior: Clip.none,
      shadowColor: Theme.of(context).primaryColor.withValues(alpha: .1),
      leadingWidth: 50,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: .75),
        ),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      title: Text(
        title,
        maxLines: 1,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: textBold.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_height);
}
