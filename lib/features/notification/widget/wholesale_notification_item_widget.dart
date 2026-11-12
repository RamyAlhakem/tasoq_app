import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/domain/models/notification_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/widget/wholesale_notification_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class WholesaleNotificationItemWidget extends StatelessWidget {
  final WholesaleNotificationItem item;
  final int index;
  const WholesaleNotificationItemWidget({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    return Consumer<NotificationController>(
      builder: (context, notificationController, _) {
        return InkWell(
          onTap: () {
            if (item.id != null && !item.isSeen) {
              notificationController.markWholesaleSeen(item.id!);
            }
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => WholesaleNotificationDialogWidget(item: item),
            );
          },
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            if (_willShowDate(index, notificationController.wholesaleNotificationModel?.notifications)) ...[
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: Dimensions.paddingSizeDefault),
                child: Text(
                  DateConverter.getRelativeDateStatus(
                    notificationController.wholesaleNotificationModel?.notifications?[index].createdAt ?? '',
                    context,
                  ),
                  style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(children: [

                Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05), width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CustomImageWidget(width: 45, height: 45, image: item.imageFullUrl ?? '', fit: BoxFit.cover),
                    ),
                  ),
                  if (!item.isSeen)
                    CircleAvatar(backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: .75), radius: 3),
                ]),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: SizedBox(height: 45, child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: Text(item.title ?? '',
                        style: textBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodyLarge!.color!,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        DateConverter.getLocalTimeWithAMPM(item.createdAt ?? ''),
                        style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: isDark ? Theme.of(context).hintColor : Theme.of(context).primaryColor,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ]),

                    Text(
                      item.description ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyLarge!.color!,
                      ),
                    ),

                  ],
                ))),

              ]),
            ),

          ]),
        );
      },
    );
  }

  bool _willShowDate(int index, List<WholesaleNotificationItem>? list) {
    if (list?.isEmpty ?? true) return false;
    if (index == 0) return true;
    final currentDate = DateTime.tryParse(list?[index].createdAt ?? '');
    final previousDate = DateTime.tryParse(list?[index - 1].createdAt ?? '');
    return currentDate?.day != previousDate?.day;
  }
}
