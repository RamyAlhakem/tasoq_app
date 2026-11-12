import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_wishlist/controllers/wholesale_wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_wishlist/widgets/wholesale_wishlist_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_wishlist/widgets/wholesale_wishlist_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:provider/provider.dart';

class WholesaleWishlistScreen extends StatefulWidget {
  const WholesaleWishlistScreen({super.key});
  @override
  State<WholesaleWishlistScreen> createState() => _WholesaleWishlistScreenState();
}

class _WholesaleWishlistScreenState extends State<WholesaleWishlistScreen> {
  final TextEditingController searchTextEditingController = TextEditingController();
  final DebounceHelper debounceHelper = DebounceHelper(milliseconds: 500);

  @override
  void dispose() {
    searchTextEditingController.dispose();
    debounceHelper.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<WholesaleWishlistController>(context, listen: false).getWishList('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('wishlist', context)),
      resizeToAvoidBottomInset: true,
      body: Column(children: [

        Consumer<WholesaleWishlistController>(builder: (context, wishListController, child) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(
                start: Dimensions.homePagePadding,
                end: Dimensions.paddingSizeDefault,
                top: Dimensions.paddingSizeSmall,
                bottom: Dimensions.paddingSizeSmall
            ),
            child: TextFormField(
              controller: searchTextEditingController,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                debounceHelper.run(() {
                  wishListController.getWishList(searchTextEditingController.text);
                });
              },
              onFieldSubmitted: (value) {
                wishListController.getWishList(searchTextEditingController.text);
              },
              style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : null),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeLarge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  borderSide: BorderSide(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .3) : Colors.grey[300]!)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  borderSide: BorderSide(color: isDark ? Theme.of(context).primaryColor : Colors.grey[300]!)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  borderSide: BorderSide(color: isDark ? Theme.of(context).hintColor.withValues(alpha: .3) : Colors.grey[300]!)),
                hintText: getTranslated('search_products', context),
                hintStyle: textRegular.copyWith(color: isDark ? Theme.of(context).hintColor : Theme.of(context).colorScheme.shadow.withValues(alpha: 0.9)),
                suffixIcon: SizedBox(width: searchTextEditingController.text.isNotEmpty ? 70 : 50,
                  child: Row(children: [
                    if(searchTextEditingController.text.isNotEmpty)
                      InkWell(
                        onTap: (){
                          searchTextEditingController.clear();
                          wishListController.getWishList('', clearSearch: true);
                        },
                        child: const Icon(Icons.clear, size: 20,),
                      ),

                    InkWell(onTap: () {
                      if(searchTextEditingController.text.trim().isNotEmpty) {
                        wishListController.getWishList(searchTextEditingController.text);
                      } else {
                        showCustomSnackBarWidget(getTranslated('enter_somethings', context), context, snackBarType: SnackBarType.warning);
                      }
                    },
                      child: Container(
                        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        ),
                        child: Image.asset(Images.search, color: Colors.white, height: Dimensions.iconSizeSmall, width: Dimensions.iconSizeSmall, fit: BoxFit.contain),
                      ),
                    ),
                  ]),
                )
              ),
            ),
          );
        }),

        Expanded(child: !Provider.of<AuthController>(context, listen: false).isLoggedIn() ?
        NotLoggedInWidget(
          fromPage: RouterHelper.wholesaleWishlistScreen,
          onLoginSuccess: () {
            RouterHelper.getWholesaleWishlistScreenRoute(action: RouteAction.pushReplacement);
          },
        )
          : Consumer<WholesaleWishlistController>(builder: (context, wishListProvider, child) {
        return wishListProvider.wishList != null
          ? wishListProvider.wishList!.isNotEmpty
          ? RefreshIndicator(
          onRefresh: () async => await  wishListProvider.getWishList(searchTextEditingController.text),
          child: PaginatedListView(
            scrollController: null,
            totalSize: wishListProvider.totalSize,
            offset: wishListProvider.offset,
            limit: 10,
            onPaginate: (int? offset) async => await wishListProvider.getWishList(searchTextEditingController.text, offset: offset ?? 1),
            itemView: Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: wishListProvider.wishList!.length,
                itemBuilder: (context, index) => WholesaleWishlistWidget(product: wishListProvider.wishList?[index], index: index),
              ),
            ),
          ))
          : NoInternetOrDataScreenWidget(isNoInternet: false, message: searchTextEditingController.text.trim().isNotEmpty ? 'no_product_found' : 'no_wishlist_product', icon: Images.noWishlist)
          : const WholesaleWishlistShimmer();
        })),
      ]),
    );
  }
}
