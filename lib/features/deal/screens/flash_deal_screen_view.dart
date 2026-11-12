import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/flash_deals_list_widget.dart';
import 'package:provider/provider.dart';

class FlashDealScreenView extends StatefulWidget {
  const FlashDealScreenView({super.key});
  @override
  State<FlashDealScreenView> createState() => _FlashDealScreenViewState();
}
class _FlashDealScreenViewState extends State<FlashDealScreenView> {
  @override
  Widget build(BuildContext context) {
    final FlashDealController flashDealController = Provider.of<FlashDealController>(context);
    final String title = flashDealController.flashDealTitle ?? getTranslated('one_time_deal', context)!;

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Column(children: [
        SafeArea(
          child: Padding(padding: const EdgeInsets.only(
            left:  Dimensions.paddingSizeSmall,
            right:  Dimensions.paddingSizeSmall,
            top:  Dimensions.paddingSizeSmall,
          ),
            child: FlashDealBar(
              title: title.toUpperCase(),
              eventDuration: flashDealController.duration,
              isBackExist : false,
            )),
        ),


        Expanded(child: RefreshIndicator(
          onRefresh: () async => await Provider.of<FlashDealController>(context, listen: false).getFlashDealList(true, false),
          child: Padding(padding: EdgeInsets.only(
            top: Dimensions.paddingSizeExtraSmall,
            left:  Dimensions.paddingSizeSmall,
            right:  Dimensions.paddingSizeSmall,
            bottom:  Dimensions.paddingSizeSmall,
          ),
          child: FlashDealsListWidget(isHomeScreen: false))))]));
  }
}