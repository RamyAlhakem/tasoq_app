library;

import 'dart:async';

import 'package:flutter/material.dart';

import 'index_controller.dart';


const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

const int kDefaultTransactionDuration = 300;

class TransformInfo {
  TransformInfo({
    this.index,
    this.position,
    this.width,
    this.height,
    this.activeIndex,
    required this.fromIndex,
    this.forward,
    this.done,
    this.viewportFraction,
    this.scrollDirection,
  });

  final double? width;

  final double? height;

  final double? position;

  final int? index;

  final int? activeIndex;

  final int fromIndex;

  final bool? forward;

  final bool? done;

  final double? viewportFraction;

  final Axis? scrollDirection;
}

abstract class PageTransformer {
  PageTransformer({this.reverse = false});

  final bool reverse;

  Widget transform(Widget child, TransformInfo info);
}

typedef PageTransformerBuilderCallback = Widget Function(
  Widget child,
  TransformInfo info,
);

class PageTransformerBuilder extends PageTransformer {
  PageTransformerBuilder({super.reverse, required this.builder});

  final PageTransformerBuilderCallback builder;

  @override
  Widget transform(Widget child, TransformInfo info) {
    return builder(child, info);
  }
}

class TransformerPageController extends PageController {
  TransformerPageController({
    int initialPage = 0,
    super.keepPage,
    super.viewportFraction,
    this.loop = false,
    this.itemCount = 0,
    this.reverse = false,
  }) : super(
            initialPage: TransformerPageController._getRealIndexFromRenderIndex(
                initialPage, loop, itemCount, reverse));

  final bool loop;
  final int itemCount;
  final bool reverse;

  int getRenderIndexFromRealIndex(num index) {
    return _getRenderIndexFromRealIndex(index, loop, itemCount, reverse);
  }

  int? getRealItemCount() {
    if (itemCount == 0) return 0;
    return loop ? itemCount + kMaxValue : itemCount;
  }

  static int _getRenderIndexFromRealIndex(
    num index,
    bool loop,
    int itemCount,
    bool reverse,
  ) {
    if (itemCount == 0) return 0;
    int renderIndex;
    if (loop) {
      renderIndex = (index - kMiddleValue).toInt();
      renderIndex = renderIndex % itemCount;
      if (renderIndex < 0) {
        renderIndex += itemCount;
      }
    } else {
      renderIndex = index.toInt();
    }
    if (reverse) {
      renderIndex = itemCount - renderIndex - 1;
    }

    return renderIndex;
  }

  double get realPage => super.page ?? 0.0;

  static double? _getRenderPageFromRealPage(
    double page,
    bool loop,
    int itemCount,
    bool reverse,
  ) {
    double? renderPage;
    if (loop) {
      renderPage = page - kMiddleValue;
      renderPage = renderPage % itemCount;
      if (renderPage < 0) {
        renderPage += itemCount;
      }
    } else {
      renderPage = page;
    }
    if (reverse) {
      renderPage = itemCount - renderPage - 1;
    }

    return renderPage;
  }

  @override
  double? get page {
    return loop
        ? _getRenderPageFromRealPage(realPage, loop, itemCount, reverse)
        : realPage;
  }

  int getRealIndexFromRenderIndex(num index) {
    return _getRealIndexFromRenderIndex(index, loop, itemCount, reverse);
  }

  static int _getRealIndexFromRenderIndex(
      num index, bool loop, int itemCount, bool reverse) {
    var result = reverse ? itemCount - index - 1 as int : index as int;
    if (loop) {
      result += kMiddleValue;
    }
    return result;
  }
}

class TransformerPageView extends StatefulWidget {
  const TransformerPageView({
    super.key,
    this.index,
    Duration? duration,
    this.curve = Curves.ease,
    this.viewportFraction = 1.0,
    required this.loop,
    this.scrollDirection = Axis.horizontal,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.controller,
    this.transformer,
    this.allowImplicitScrolling = false,
    this.itemBuilder,
    this.pageController,
    required this.itemCount,
  })  : assert(itemCount == 0 || itemBuilder != null || transformer != null),
        duration = duration ??
            const Duration(milliseconds: kDefaultTransactionDuration);

  factory TransformerPageView.children({
    Key? key,
    int? index,
    Duration? duration,
    Curve curve = Curves.ease,
    double viewportFraction = 1.0,
    bool loop = false,
    Axis scrollDirection = Axis.horizontal,
    ScrollPhysics? physics,
    bool pageSnapping = true,
    ValueChanged<int?>? onPageChanged,
    IndexController? controller,
    PageTransformer? transformer,
    bool allowImplicitScrolling = false,
    required List<Widget> children,
    TransformerPageController? pageController,
  }) {
    return TransformerPageView(
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
      pageController: pageController,
      transformer: transformer,
      pageSnapping: pageSnapping,
      key: key,
      index: index,
      loop: loop,
      duration: duration,
      curve: curve,
      viewportFraction: viewportFraction,
      scrollDirection: scrollDirection,
      physics: physics,
      allowImplicitScrolling: allowImplicitScrolling,
      onPageChanged: onPageChanged,
      controller: controller,
    );
  }

  final PageTransformer? transformer;

  final Axis scrollDirection;

  final ScrollPhysics? physics;

  final bool pageSnapping;

  final ValueChanged<int>? onPageChanged;

  final IndexedWidgetBuilder? itemBuilder;

  // See [IndexController.mode],[IndexController.next],[IndexController.previous]
  final IndexController? controller;

  final Duration duration;

  final Curve curve;

  final TransformerPageController? pageController;

  final bool loop;

  final int itemCount;

  final double viewportFraction;

  final int? index;

  final bool allowImplicitScrolling;

  @override
  State<StatefulWidget> createState() => _TransformerPageViewState();

  static int getRealIndexFromRenderIndex({
    required bool reverse,
    int index = 0,
    int itemCount = 0,
    required bool loop,
  }) {
    var initPage = reverse ? (itemCount - index - 1) : index;
    if (loop) {
      initPage += kMiddleValue;
    }
    return initPage;
  }

  static PageController createPageController({
    required bool reverse,
    int index = 0,
    int itemCount = 0,
    required bool loop,
    required double viewportFraction,
  }) {
    return PageController(
      initialPage: getRealIndexFromRenderIndex(
        reverse: reverse,
        index: index,
        itemCount: itemCount,
        loop: loop,
      ),
      viewportFraction: viewportFraction,
    );
  }
}

class _TransformerPageViewState extends State<TransformerPageView> {
  Size? _size;
  int _activeIndex = 0;
  late double _currentPixels;
  bool _done = false;

  late int _fromIndex;

  PageTransformer? _transformer;

  late TransformerPageController _pageController;

  Widget _buildItemNormal(BuildContext context, int index) {
    final renderIndex = _pageController.getRenderIndexFromRealIndex(index);
    return widget.itemBuilder!(context, renderIndex);
  }

  Widget _buildItem(BuildContext context, int index) {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (c, w) {
          final renderIndex =
              _pageController.getRenderIndexFromRealIndex(index);
          final child = widget.itemBuilder?.call(context, renderIndex) ??
              const SizedBox.shrink();
          if (_size == null) {
            return child;
          }

          double position;

          final page = _pageController.realPage;
          if (_transformer!.reverse) {
            position = page - index;
          } else {
            position = index - page;
          }
          position *= widget.viewportFraction;

          final info = TransformInfo(
            index: renderIndex,
            width: _size!.width,
            height: _size!.height,
            position: position.clamp(-1.0, 1.0),
            activeIndex:
                _pageController.getRenderIndexFromRealIndex(_activeIndex),
            fromIndex: _fromIndex,
            forward: _pageController.position.pixels - _currentPixels >= 0,
            done: _done,
            scrollDirection: widget.scrollDirection,
            viewportFraction: widget.viewportFraction,
          );

          return _transformer!.transform(child, info);
        });
  }

  double? _calcCurrentPixels() {
    _currentPixels = _pageController.getRenderIndexFromRealIndex(_activeIndex) *
        _pageController.position.viewportDimension *
        widget.viewportFraction;

    //  print("activeIndex:$_activeIndex , pix:$_currentPixels");

    return _currentPixels;
  }

  @override
  Widget build(BuildContext context) {
    final builder = _transformer == null ? _buildItemNormal : _buildItem;
    final child = Container(
      color:  Colors.green,
      padding: const EdgeInsets.all(15),
      child: PageView.builder(
        allowImplicitScrolling: widget.allowImplicitScrolling,
        itemBuilder: builder,
        itemCount: _pageController.getRealItemCount(),
        onPageChanged: _onIndexChanged,
        controller: _pageController,
        scrollDirection: widget.scrollDirection,
        physics: widget.physics,
        pageSnapping: widget.pageSnapping,
        reverse: _pageController.reverse,
      ),
    );
    if (_transformer == null) {
      return child;
    }
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          _calcCurrentPixels();
          _done = false;
          _fromIndex = _activeIndex;
        } else if (notification is ScrollEndNotification) {
          _calcCurrentPixels();
          _fromIndex = _activeIndex;
          _done = true;
        }

        return false;
      },
      child: child,
    );
  }

  void _onIndexChanged(int index) {
    _activeIndex = index;
    widget.onPageChanged
        ?.call(_pageController.getRenderIndexFromRealIndex(index));
  }

  void _onGetSize(Duration _) {
    if (!mounted) return;
    Size? size;

    final renderObject = context.findRenderObject();
    if (renderObject != null) {
      final bounds = renderObject.paintBounds;
      size = bounds.size;
    }
    _calcCurrentPixels();
    onGetSize(size);
  }

  void onGetSize(Size? size) {
    if (mounted) {
      setState(() {
        _size = size;
      });
    }
  }

  IndexController? _controller;

  @override
  void initState() {
    _transformer = widget.transformer;
    // int index = widget.index ?? 0;
    _pageController = widget.pageController ??
        TransformerPageController(
          initialPage: widget.index ?? 0,
          itemCount: widget.itemCount,
          loop: widget.loop,
          reverse: widget.transformer?.reverse ?? false,
        );
    // int initPage = _getRealIndexFromRenderIndex(index);
    // _pageController =  PageController(initialPage: initPage,viewportFraction: widget.viewportFraction);
    _fromIndex = _activeIndex = _pageController.initialPage;

    _controller = widget.controller;
    _controller?.addListener(onChangeNotifier);
    super.initState();
  }

  @override
  void didUpdateWidget(TransformerPageView oldWidget) {
    _transformer = widget.transformer;
    final index = widget.index ?? 0;
    var created = false;
    if (_pageController != widget.pageController) {
      if (widget.pageController != null) {
        _pageController = widget.pageController!;
      } else {
        created = true;
        _pageController = TransformerPageController(
          initialPage: widget.index ?? 0,
          itemCount: widget.itemCount,
          loop: widget.loop,
          reverse: widget.transformer?.reverse ?? false,
        );
      }
    }

    if (_pageController.getRenderIndexFromRealIndex(_activeIndex) != index) {
      _fromIndex = _activeIndex = _pageController.initialPage;
      if (!created) {
        final initPage = _pageController.getRealIndexFromRenderIndex(index);
        if (_pageController.hasClients) {
          unawaited(_pageController.animateToPage(
            initPage,
            duration: widget.duration,
            curve: widget.curve,
          ));
        }
      }
    }
    if (_transformer != null) {
      _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback(_onGetSize);
    }

    if (_controller != widget.controller) {
      _controller?.removeListener(onChangeNotifier);
      _controller = widget.controller;
      _controller?.addListener(onChangeNotifier);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    if (_transformer != null) {
      _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback(_onGetSize);
    }
    super.didChangeDependencies();
  }

  Future<void> onChangeNotifier() async {
    final controller = widget.controller!;
    final event = controller.event;
    int index;
    if (event == null) return;
    if (event is MoveIndexControllerEvent) {
      index = _pageController.getRealIndexFromRenderIndex(event.newIndex);
    } else if (event is StepBasedIndexControllerEvent) {
      index = event.calcNextIndex(
        currentIndex: _activeIndex,
        itemCount: _pageController.itemCount,
        loop: _pageController.loop,
        reverse: _pageController.reverse,
      );
    } else {
      //ignore other events
      return;
    }
    if (_pageController.hasClients) {
      if (event.animation) {
        await _pageController
            .animateToPage(
              index,
              duration: widget.duration,
              curve: widget.curve,
            )
            .whenComplete(event.complete);
      } else {
        event.complete();
      }
    } else {
      event.complete();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(onChangeNotifier);
    super.dispose();
  }
}

T? _ambiguate<T>(T? value) => value;
