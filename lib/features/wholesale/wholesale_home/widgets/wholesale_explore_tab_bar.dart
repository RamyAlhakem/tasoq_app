import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class WholesaleExploreTabBar extends StatefulWidget {
  final List<String> tabNames;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const WholesaleExploreTabBar({
    super.key,
    required this.tabNames,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  State<WholesaleExploreTabBar> createState() => _WholesaleExploreTabBarState();
}

class _WholesaleExploreTabBarState extends State<WholesaleExploreTabBar> {
  final ScrollController _scrollController = ScrollController();

  final List<GlobalKey> _tabKeys = [];

  int? _centeredIndex;

  static const Duration _scrollDuration = Duration(milliseconds: 300);

  @override
  void didUpdateWidget(covariant WholesaleExploreTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedIndex != oldWidget.selectedIndex ||
        widget.tabNames.length != oldWidget.tabNames.length) {
      _centerSelectedTab();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _centerSelectedTab() {
    final int index = widget.selectedIndex;
    if (_centeredIndex == index) return;
    _centeredIndex = index;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      if (index < 0 || index >= _tabKeys.length) return;

      final RenderObject? tab = _tabKeys[index].currentContext?.findRenderObject();
      if (tab == null || !tab.attached) return;

      _scrollController.position.ensureVisible(
        tab,
        alignment: 0.5,
        duration: _scrollDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    while (_tabKeys.length < widget.tabNames.length) {
      _tabKeys.add(GlobalKey());
    }

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
      child: Row(
        children: List.generate(widget.tabNames.length, (index) {
          final bool isSelected = widget.selectedIndex == index;
          return GestureDetector(
            key: _tabKeys[index],
            onTap: () => widget.onTabSelected(index),
            child: Container(
              margin: const EdgeInsetsDirectional.only(end: Dimensions.paddingSizeExtraSmall),
              padding: const EdgeInsets.fromLTRB(
                Dimensions.paddingSizeSmall,
                0,
                Dimensions.paddingSizeSmall,
                Dimensions.paddingSizeExtraSmall,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                widget.tabNames[index],
                style: isSelected
                  ? titilliumSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).primaryColor,
                    )
                  : titilliumRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
