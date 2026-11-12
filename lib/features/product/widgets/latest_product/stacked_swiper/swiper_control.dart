import 'card_swiper.dart';
import 'package:flutter/material.dart';

class SwiperControl extends SwiperPlugin {
  const SwiperControl({
    this.iconPrevious = Icons.arrow_back_ios,
    this.iconNext = Icons.arrow_forward_ios,
    this.color,
    this.disableColor,
    this.key,
    this.size = 30.0,
    this.padding = const EdgeInsets.all(5.0),
  });

  final IconData iconPrevious;

  final IconData iconNext;

  final double size;

  final Color? color;

  final Color? disableColor;

  final EdgeInsetsGeometry padding;

  final Key? key;

  Widget buildButton({
    required SwiperPluginConfig? config,
    required Color color,
    required IconData iconData,
    required int quarterTurns,
    required bool previous,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (previous) {
          await config!.controller.previous(animation: true);
        } else {
          await config!.controller.next(animation: true);
        }
      },
      child: Padding(
          padding: padding,
          child: RotatedBox(
              quarterTurns: quarterTurns,
              child: Icon(
                iconData,
                semanticLabel: previous ? 'Previous' : 'Next',
                size: size,
                color: color,
              ))),
    );
  }

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    final themeData = Theme.of(context);

    final color = this.color ?? themeData.primaryColor;
    final disableColor = this.disableColor ?? themeData.disabledColor;
    Color prevColor;
    Color nextColor;

    if (config.loop) {
      prevColor = nextColor = color;
    } else {
      final next = config.activeIndex < config.itemCount - 1;
      final prev = config.activeIndex > 0;
      prevColor = prev ? color : disableColor;
      nextColor = next ? color : disableColor;
    }

    Widget child;
    if (config.scrollDirection == Axis.horizontal) {
      child = Row(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildButton(
            config: config,
            color: prevColor,
            iconData: iconPrevious,
            quarterTurns: 0,
            previous: true,
          ),
          buildButton(
            config: config,
            color: nextColor,
            iconData: iconNext,
            quarterTurns: 0,
            previous: false,
          )
        ],
      );
    } else {
      child = Column(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildButton(
            config: config,
            color: prevColor,
            iconData: iconPrevious,
            quarterTurns: -3,
            previous: true,
          ),
          buildButton(
            config: config,
            color: nextColor,
            iconData: iconNext,
            quarterTurns: -3,
            previous: false,
          )
        ],
      );
    }

    return SizedBox.expand(
      child: child,
    );
  }
}
