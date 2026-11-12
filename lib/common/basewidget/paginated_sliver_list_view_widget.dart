import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class PaginatedSliverListView extends StatefulWidget {
  final ScrollController? scrollController;
  final Function(int? offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final int? limit;
  final Widget itemView;
  final bool enabledPagination;
  const PaginatedSliverListView({
    super.key, this.scrollController, required this.onPaginate, required this.totalSize,
    required this.offset, required this.itemView, this.enabledPagination = true, this.limit = 10,
  });

  @override
  State<PaginatedSliverListView> createState() => _PaginatedSliverListViewState();
}

class _PaginatedSliverListViewState extends State<PaginatedSliverListView> {
  int? _offset;
  late List<int?> _offsetList;
  bool _isLoading = false;

  final DebounceHelper debounce = DebounceHelper(milliseconds: 500);

  // Trigger pagination this far before the true scroll end, so the loader
  // has room to render inside the visible viewport instead of appearing
  // just past the edge the user already scrolled to.
  static const double _paginationTriggerOffset = 200.0;

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];

    if(widget.scrollController != null){
      widget.scrollController?.addListener(() {
        final position = widget.scrollController?.position;
        if (position != null && position.pixels >= position.maxScrollExtent - _paginationTriggerOffset
            && widget.totalSize != null && !_isLoading && widget.enabledPagination) {
          if(mounted) {
            debounce.run((){
              _paginate();
            });
          }
        }
      });
    }

  }

  void _paginate() async {
    int pageSize = (widget.totalSize! / widget.limit!).ceil();
    if (_offset! < pageSize && !_offsetList.contains(_offset!+1)) {

      setState(() {
        _offset = _offset! + 1;
        _offsetList.add(_offset);
        _isLoading = true;
      });
      await widget.onPaginate(_offset);
      setState(() {
        _isLoading = false;
      });

    }else {
      if(_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.offset != null) {
      _offset = widget.offset;
      _offsetList = [];
      for(int index=1; index<=widget.offset!; index++) {
        _offsetList.add(index);
      }
    }


    return _OnSliverNotificationListenerWidget(
      isEnabled: widget.scrollController == null,
      onNotification: (scrollNotification){
        if (scrollNotification!.metrics.pixels >= scrollNotification.metrics.maxScrollExtent - _paginationTriggerOffset
            && widget.totalSize != null && !_isLoading && widget.enabledPagination) {

          if(mounted) {
            debounce.run((){
              _paginate();
            });
          }
        }
      },

      // Sliver order is always [itemView, loader] — CustomScrollView.reverse (set by the
      // caller) flips the growth direction itself, so the loader lands on the correct
      // edge (bottom for a normal list, top for a reversed one like chat) without needing
      // to be reordered here.
      child: SliverMainAxisGroup(slivers: [

        widget.itemView,

        SliverToBoxAdapter(child: ((widget.totalSize == null || _offset! >= (widget.totalSize! / (widget.limit ?? 10)).ceil() || _offsetList.contains(_offset!+1))) ? const SizedBox() : Center(child: Padding(
            padding: (_isLoading) ?  const EdgeInsets.all(Dimensions.paddingSizeSmall) : EdgeInsets.zero,
            child: _isLoading ? const CircularProgressIndicator(color: Colors.red ) :  const SizedBox()))),

      ]),
    );
  }
}

class _OnSliverNotificationListenerWidget extends StatelessWidget {
  final bool isEnabled;
  final Widget child;
  final Function(ScrollNotification? scrollNotification) onNotification;
  const _OnSliverNotificationListenerWidget({required this.isEnabled, required this.child, required this.onNotification});

  @override
  Widget build(BuildContext context) {
    return isEnabled ? NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        onNotification(scrollNotification);

        return false;
      },
      child: child,
    ) : child;
  }
}
