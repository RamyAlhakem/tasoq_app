import 'dart:developer';

import 'package:flutter/material.dart';

import 'card_swiper.dart';

class FractionPaginationBuilder extends SwiperPlugin {
  const FractionPaginationBuilder({
    this.color,
    this.fontSize = 20.0,
    this.key,
    this.activeColor,
    this.activeFontSize = 35.0,
  });

  final Color? color;

  final Color? activeColor;

  final double fontSize;

  final double activeFontSize;

  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig? config) {
    final themeData = Theme.of(context);
    final activeColor = this.activeColor ?? themeData.primaryColor;
    final color = this.color ?? themeData.scaffoldBackgroundColor;

    if (Axis.vertical == config!.scrollDirection) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${config.activeIndex + 1}',
            style: TextStyle(color: activeColor, fontSize: activeFontSize),
          ),
          Text(
            '/',
            style: TextStyle(color: color, fontSize: fontSize),
          ),
          Text(
            '${config.itemCount}',
            style: TextStyle(color: color, fontSize: fontSize),
          )
        ],
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${config.activeIndex + 1}',
            style: TextStyle(color: activeColor, fontSize: activeFontSize),
          ),
          Text(
            ' / ${config.itemCount}',
            style: TextStyle(color: color, fontSize: fontSize),
          )
        ],
      );
    }
  }
}

class RectSwiperPaginationBuilder extends SwiperPlugin {
  const RectSwiperPaginationBuilder({
    this.activeColor,
    this.color,
    this.key,
    this.size = const Size(10.0, 2.0),
    this.activeSize = const Size(10.0, 2.0),
    this.space = 3.0,
  });

  final Color? activeColor;

  final Color? color;

  final Size activeSize;

  final Size size;

  final double space;

  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    final themeData = Theme.of(context);
    final activeColor = this.activeColor ?? themeData.primaryColor;
    final color = this.color ?? themeData.scaffoldBackgroundColor;

    final list = <Widget>[];

    final itemCount = config.itemCount;
    final activeIndex = config.activeIndex;
    if (itemCount > 20) {
      log(
        'The itemCount is too big, we suggest use FractionPaginationBuilder '
        'instead of DotSwiperPaginationBuilder in this situation',
      );
    }

    for (var i = 0; i < itemCount; ++i) {
      final active = i == activeIndex;
      final size = active ? activeSize : this.size;
      list.add(SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          color: active ? activeColor : color,
          key: Key('pagination_$i'),
          margin: EdgeInsets.all(space),
        ),
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}

class DotSwiperPaginationBuilder extends SwiperPlugin {
  const DotSwiperPaginationBuilder({
    this.activeColor,
    this.color,
    this.key,
    this.size = 10.0,
    this.activeSize = 10.0,
    this.space = 3.0,
  });

  final Color? activeColor;

  final Color? color;

  final double activeSize;

  final double size;

  final double space;

  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    if (config.itemCount > 20) {
      log(
        'The itemCount is too big, we suggest use FractionPaginationBuilder '
        'instead of DotSwiperPaginationBuilder in this situation',
      );
    }
    var activeColor = this.activeColor;
    var color = this.color;

    if (activeColor == null || color == null) {
      final themeData = Theme.of(context);
      activeColor = this.activeColor ?? themeData.primaryColor;
      color = this.color ?? themeData.scaffoldBackgroundColor;
    }

    if (config.indicatorLayout != PageIndicatorLayout.NONE &&
        config.layout == SwiperLayout.DEFAULT) {
      return PageIndicator(
        count: config.itemCount,
        controller: config.pageController!,
        layout: config.indicatorLayout,
        size: size,
        activeColor: activeColor,
        color: color,
        space: space,
      );
    }

    final list = <Widget>[];

    final itemCount = config.itemCount;
    final activeIndex = config.activeIndex;

    for (var i = 0; i < itemCount; ++i) {
      final active = i == activeIndex;
      list.add(Container(
        key: Key('pagination_$i'),
        margin: EdgeInsets.all(space),
        child: ClipOval(
          child: Container(
            color: active ? activeColor : color,
            width: active ? activeSize : size,
            height: active ? activeSize : size,
          ),
        ),
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}

typedef SwiperPaginationBuilder = Widget Function(
  BuildContext context,
  SwiperPluginConfig config,
);

class SwiperCustomPagination extends SwiperPlugin {
  const SwiperCustomPagination({required this.builder});

  final SwiperPaginationBuilder builder;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    return builder(context, config);
  }
}

class SwiperPagination extends SwiperPlugin {
  const SwiperPagination({
    this.alignment,
    this.key,
    this.margin = const EdgeInsets.all(10.0),
    this.builder = SwiperPagination.dots,
  });

  static const SwiperPlugin dots = DotSwiperPaginationBuilder();

  static const SwiperPlugin fraction = FractionPaginationBuilder();

  static const SwiperPlugin rect = RectSwiperPaginationBuilder();

  final Alignment? alignment;

  final EdgeInsetsGeometry margin;

  final SwiperPlugin builder;

  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    final defaultAlignment = config.scrollDirection == Axis.horizontal
        ? Alignment.bottomCenter
        : Alignment.centerRight;
    Widget child = Container(
      margin: margin,
      child: builder.build(context, config),
    );
    if (!config.outer!) {
      child = Align(
        key: key,
        alignment: alignment ?? defaultAlignment,
        child: child,
      );
    }
    return child;
  }
}
