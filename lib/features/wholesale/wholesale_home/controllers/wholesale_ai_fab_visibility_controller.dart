import 'dart:async';

import 'package:flutter/material.dart';

class WholesaleAiFabVisibilityController {
  WholesaleAiFabVisibilityController({
    required TickerProvider vsync,
    required this.scrollController,
    this.nested = false,
  }) {
    _animation = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 300), value: 0.0);
    slide = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 2.5)).animate(CurvedAnimation(
      parent: _animation,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      reverseCurve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));
    fade = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animation,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      reverseCurve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));
  }

  static const Duration idleShowDelay = Duration(seconds: 5);
  static const double _topTolerance = 10;
  static const double _bottomTolerance = 2;

  final ScrollController scrollController;
  final bool nested;

  late final AnimationController _animation;
  late final Animation<Offset> slide;
  late final Animation<double> fade;
  Timer? _idleTimer;

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is! ScrollUpdateNotification || notification.metrics.axis != Axis.vertical) return false;

    final double delta = notification.scrollDelta ?? 0;
    final bool atTop = scrollController.hasClients && scrollController.offset < _topTolerance;
    final bool atBottom = notification.metrics.extentAfter <= _bottomTolerance;

    if (atTop) {
      _show();
    } else if (delta > 0) {
      if (atBottom && _isBottomSource(notification)) {
        _idleTimer?.cancel();
        _hide();
      } else {
        _hide();
        _idleTimer?.cancel();
        _idleTimer = Timer(idleShowDelay, _show);
      }
    } else if (delta < 0 && !atBottom) {
      _show();
    }
    return false;
  }

  bool _isBottomSource(ScrollNotification notification) {
    final bool isOuter = scrollController.positions.any(
      (ScrollPosition position) => identical(position.context.notificationContext, notification.context),
    );
    return nested ? !isOuter : isOuter;
  }

  void _show() {
    _idleTimer?.cancel();
    if (_animation.value != 0.0) _animation.reverse();
  }

  void _hide() {
    if (_animation.value != 1.0) _animation.forward();
  }

  void dispose() {
    _idleTimer?.cancel();
    _animation.dispose();
  }
}
