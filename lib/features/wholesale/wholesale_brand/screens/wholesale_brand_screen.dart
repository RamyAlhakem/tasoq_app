import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_sliver_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/controllers/wholesale_brand_list_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/widgets/wholesale_brand_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_brand/widgets/wholesale_brand_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleBrandScreen extends StatefulWidget {
  const WholesaleBrandScreen({super.key});

  @override
  State<WholesaleBrandScreen> createState() => _WholesaleBrandScreenState();
}

class _WholesaleBrandScreenState extends State<WholesaleBrandScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<WholesaleBrandListController>(context, listen: false).getBrandList(offset: 1, reload: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('all_brand', context)),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Consumer<WholesaleBrandListController>(
          builder: (context, brandController, _) {
            if (brandController.brands == null) {
              return const WholesaleBrandShimmerWidget();
            }

            if (brandController.brands!.isEmpty) {
              return const Center(
                child: NoInternetOrDataScreenWidget(isNoInternet: false, message: 'no_data_found'),
              );
            }

            return RefreshIndicator(
              onRefresh: () => brandController.getBrandList(offset: 1, reload: true),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  PaginatedSliverListView(
                    scrollController: _scrollController,
                    totalSize: brandController.brandResponseModel?.totalSize,
                    offset: brandController.brandResponseModel?.offset,
                    limit: brandController.brandResponseModel?.limit ?? 25,
                    onPaginate: (int? offset) async => await brandController.getBrandList(offset: offset ?? 1),
                    itemView: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: (1/1.3),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 5,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => WholesaleBrandItemWidget(brand: brandController.brands![index]),
                        childCount: brandController.brands!.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
