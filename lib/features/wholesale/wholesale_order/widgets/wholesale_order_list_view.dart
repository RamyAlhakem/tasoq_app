import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_sliver_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_list_item_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_list_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleOrderListView extends StatefulWidget {
  const WholesaleOrderListView({super.key});

  @override
  State<WholesaleOrderListView> createState() => _WholesaleOrderListViewState();
}

class _WholesaleOrderListViewState extends State<WholesaleOrderListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleOrderController>(context, listen: false).getOrderList(reload: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleOrderController>(
      builder: (context, orderController, _) {
        final List<dynamic>? orders = orderController.orderList;

        if (orders == null) {
          return const WholesaleOrderListShimmer();
        }

        Future<void> onRefresh() => orderController.getOrderList(reload: true);

        if (orders.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(getTranslated('no_order_found', context) ?? '',
                      style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              PaginatedSliverListView(
                scrollController: _scrollController,
                onPaginate: (offset) async => orderController.getOrderList(offset: offset ?? 1),
                totalSize: orderController.orderListResponse?.totalSize,
                offset: orderController.orderListResponse?.offset,
                limit: orderController.orderListResponse?.limit ?? 25,
                itemView: SliverPadding(
                  padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => WholesaleOrderListItemCard(orderModel: orderController.orderList![index]),
                      childCount: orders.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
