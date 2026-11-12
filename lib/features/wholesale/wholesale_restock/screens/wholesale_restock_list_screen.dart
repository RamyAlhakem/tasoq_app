import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/controllers/wholesale_restock_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/widgets/delete_wholesale_restock_confirm_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/widgets/wholesale_restock_list_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_restock/widgets/wholesale_restock_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleRestockListScreen extends StatefulWidget {
  const WholesaleRestockListScreen({super.key});

  @override
  State<WholesaleRestockListScreen> createState() => _WholesaleRestockListScreenState();
}

class _WholesaleRestockListScreenState extends State<WholesaleRestockListScreen> {
  @override
  void initState() {
    super.initState();
    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<WholesaleRestockController>(context, listen: false).getRestockRequestList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('restock_request', context)),
      body: !Provider.of<AuthController>(context, listen: false).isLoggedIn()
          ? NotLoggedInWidget(
              fromPage: RouterHelper.wholesaleRestockListScreen,
              onLoginSuccess: () => RouterHelper.getWholesaleRestockListScreenRoute(action: RouteAction.pushReplacement),
            )
          : Consumer<WholesaleRestockController>(builder: (context, restockController, _) {
              final List? requests = restockController.requests;

              if (requests == null) return const WholesaleRestockShimmer();
              if (requests.isEmpty) {
                return NoInternetOrDataScreenWidget(isNoInternet: false, message: 'product_not_found', icon: Images.noProduct);
              }

              return RefreshIndicator(
                onRefresh: () async => await restockController.getRestockRequestList(),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeSmall),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(
                        '${getTranslated('products', context) ?? 'Products'} (${restockController.totalSize ?? requests.length})',
                        style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      InkWell(
                        onTap: () => showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (_) => const DeleteWholesaleRestockConfirmBottomSheetWidget(),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: Text(
                            getTranslated('clear_all', context) ?? 'Clear all',
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: PaginatedListView(
                      scrollController: null,
                      totalSize: restockController.totalSize,
                      offset: restockController.offset,
                      onPaginate: (int? offset) async => await restockController.getRestockRequestList(offset: offset ?? 1),
                      itemView: Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: requests.length,
                          itemBuilder: (context, index) => WholesaleRestockListItemWidget(item: requests[index]),
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            }),
    );
  }
}
