import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/enum/wholesale_refund_status.dart';

class WholesaleRefundChangeLogWidget extends StatelessWidget {
  const WholesaleRefundChangeLogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleRefundController>(
      builder: (context, refundController, _) {
        final history = refundController.refundResultModel?.statusHistory ?? const [];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeController>(context).darkTheme ? 800 : 200]!, spreadRadius: 0.5, blurRadius: 0.3)],
          ),
          child: history.isEmpty
              ? Center(child: Image.asset(Images.noData))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final entry = history[index];

                    return Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        flex: 1,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeLarge), color: Theme.of(context).primaryColor),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeExtraSmall, top: Dimensions.paddingSizeEight, end: Dimensions.paddingSizeEight, bottom: Dimensions.paddingSizeEight),
                              child: Image.asset(Images.refundLogImage),
                            ),
                          ),
                          if (index != history.length - 1) Container(height: 60, width: 2, color: Theme.of(context).primaryColor),
                        ]),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          margin: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall, top: Dimensions.paddingSizeSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            _ItemWidget(label: 'refund_request_status', value: entry.statusLabel ?? entry.status ?? ''),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: _ItemWidget(label: 'updated_by', value: entry.changedBy ?? ''),
                            ),
                            if (entry.message != null && entry.message!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                child: _ItemWidget(label: 'reason', value: entry.message!),
                              ),
                            if (entry.changedAt != null)
                              Text(DateConverter.refundDateTime(entry.changedAt!), textDirection: TextDirection.ltr, style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall)),
                          ]),
                        ),
                      ),
                    ]);
                  },
                ),
        );
      },
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final String label;
  final String value;
  const _ItemWidget({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final Color valueColor = WholesaleRefundStatus.fromString(value.toLowerCase()).timelineColor(context);

    return Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('${getTranslated(label, context)} : ', style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault)),
      Expanded(child: Text(_capitalize(value), style: robotoBold.copyWith(color: valueColor, fontSize: Dimensions.fontSizeDefault), maxLines: 2, overflow: TextOverflow.ellipsis)),
    ]);
  }

  String _capitalize(String value) => value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
}
