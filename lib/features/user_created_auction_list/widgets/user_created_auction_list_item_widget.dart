import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/status_badge_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/user_created_auction_list/domain/enum/creator_auction_details_route_action.dart';
import 'package:flutter_sixvalley_ecommerce/features/user_created_auction_list/domain/enum/user_created_auction_purchase_enum.dart';
import 'package:flutter_sixvalley_ecommerce/features/user_created_auction_list/domain/models/user_created_auction_list_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/color_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class UserCreatedAuctionListItemWidget extends StatefulWidget {
  final UserCreatedAuctionPurchaseEnum auctionStatus;
  final String imageUrl;
  final String slug;
  final int auctionId;
  final String productName;
  final double startingPrice;
  final double highestBidAmount;
  final DateTime targetTime;
  final int viewCount;
  final int? participantCount;
  final int totalBidCount;
  final double adminCommission;
  final bool isAdminCommissionPaid;
  final String? claimPaymentStatus;
  final VoidCallback? onPayNow;
  final VoidCallback? onWithdrawMoney;
  final VoidCallback? onRelaunch;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final UserCreatedAuctionProduct? userCreatedAuctionProduct;

  const UserCreatedAuctionListItemWidget({
    super.key,
    required this.auctionStatus,
    required this.imageUrl,
    required this.slug,
    required this.auctionId,
    required this.productName,
    required this.startingPrice,
    required this.highestBidAmount,
    required this.targetTime,
    required this.viewCount,
    this.participantCount,
    this.totalBidCount = 0,
    this.adminCommission = 0.0,
    this.isAdminCommissionPaid = false,
    this.claimPaymentStatus,
    this.onPayNow,
    this.onWithdrawMoney,
    this.onRelaunch,
    this.onCancel,
    this.onDelete,
    this.onEdit,
    this.userCreatedAuctionProduct
  });

  @override
  State<UserCreatedAuctionListItemWidget> createState() => _UserCreatedAuctionListItemWidgetState();
}

class _UserCreatedAuctionListItemWidgetState extends State<UserCreatedAuctionListItemWidget> {
  late Timer _timer;
  late Duration _remaining;

  bool get _isLive => widget.auctionStatus == UserCreatedAuctionPurchaseEnum.live;
  bool get _isUpcoming => widget.auctionStatus == UserCreatedAuctionPurchaseEnum.upcoming;

  bool get _isActionable =>
      widget.auctionStatus == UserCreatedAuctionPurchaseEnum.readyToClaim ||
          widget.auctionStatus == UserCreatedAuctionPurchaseEnum.purchaseComplete ||
          widget.auctionStatus == UserCreatedAuctionPurchaseEnum.unsold ||
          widget.auctionStatus == UserCreatedAuctionPurchaseEnum.delivered ||
          widget.auctionStatus == UserCreatedAuctionPurchaseEnum.readyToDelivery ||
          widget.auctionStatus == UserCreatedAuctionPurchaseEnum.onTheWay;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    final diff = widget.targetTime.difference(DateTime.now());
    setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => RouterHelper.getCreatorAuctionDetailsRoute(slug: widget.slug),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeEight),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AuctionListItemImage(
                  imageUrl: widget.imageUrl,
                  isLive: _isLive,
                  isUpcoming: _isUpcoming,
                  remaining: _remaining,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Expanded(
                  child: AuctionListItemDetails(
                    auctionId: widget.auctionId,
                    slug: widget.slug,
                    auctionStatus: widget.auctionStatus,
                    participantCount: widget.participantCount,
                    onRelaunch: widget.onRelaunch,
                    onCancel: widget.onCancel,
                    onDelete: widget.onDelete,
                    onEdit: widget.onEdit,
                    productName: widget.productName,
                    isUpcoming: _isUpcoming,
                    isLive: _isLive,
                    isActionable: _isActionable,
                    startingPrice: widget.startingPrice,
                    highestBidAmount: widget.highestBidAmount,
                    viewCount: widget.viewCount,
                    totalBidCount: widget.totalBidCount,
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 0,
            start: 0,
            child: StatusBadgeWidget(
              text: widget.auctionStatus.label(context),
              color: widget.auctionStatus.badgeColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class AuctionListItemImage extends StatelessWidget {
  final String imageUrl;
  final bool isLive;
  final bool isUpcoming;
  final Duration remaining;

  const AuctionListItemImage({
    super.key,
    required this.imageUrl,
    required this.isLive,
    required this.isUpcoming,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      height: 85,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).hintColor, width: 0.5)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: CustomImageWidget(
                image: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          if (isLive || isUpcoming)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
              decoration: BoxDecoration(
                color: ColorHelper.blendColors(Theme.of(context).cardColor, Theme.of(context).hintColor, 0.35),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.radiusDefault),
                  bottomRight: Radius.circular(Dimensions.radiusDefault),
                ),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: Dimensions.iconSizeExtraSmall + 2,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraExtraSmall),
                  Flexible(
                    child: Text(
                      DateConverter.formatDuration(remaining),
                      overflow: TextOverflow.ellipsis,
                      style: titilliumBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuctionListItemDetails extends StatelessWidget {
  final int auctionId;
  final String slug;
  final UserCreatedAuctionPurchaseEnum auctionStatus;
  final int? participantCount;
  final VoidCallback? onRelaunch;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final String productName;
  final bool isUpcoming;
  final bool isLive;
  final bool isActionable;
  final double startingPrice;
  final double highestBidAmount;
  final int viewCount;
  final int totalBidCount;

  const AuctionListItemDetails({
    super.key,
    required this.auctionId,
    required this.slug,
    required this.auctionStatus,
    this.participantCount,
    this.onRelaunch,
    this.onCancel,
    this.onDelete,
    this.onEdit,
    required this.productName,
    required this.isUpcoming,
    required this.isLive,
    required this.isActionable,
    required this.startingPrice,
    required this.highestBidAmount,
    required this.viewCount,
    required this.totalBidCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuctionListIdRow(
          auctionId: auctionId,
          slug: slug,
          auctionStatus: auctionStatus,
          participantCount: participantCount,
          onRelaunch: onRelaunch,
          onCancel: onCancel,
          onDelete: onDelete,
          onEdit: onEdit,
        ),
        AuctionListProductName(productName: productName),
        const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
        AuctionListPriceSection(
          isUpcoming: isUpcoming,
          isLive: isLive,
          isActionable: isActionable,
          startingPrice: startingPrice,
          highestBidAmount: highestBidAmount,
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
        AuctionListBottomRow(
          viewCount: viewCount,
          isUpcoming: isUpcoming,
          isLive: isLive,
          participantCount: participantCount,
          totalBidCount: totalBidCount,
        ),
      ],
    );
  }
}

class AuctionListIdRow extends StatelessWidget {
  final int auctionId;
  final String slug;
  final UserCreatedAuctionPurchaseEnum auctionStatus;
  final int? participantCount;
  final VoidCallback? onRelaunch;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const AuctionListIdRow({
    super.key,
    required this.auctionId,
    required this.slug,
    required this.auctionStatus,
    this.participantCount,
    this.onRelaunch,
    this.onCancel,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${getTranslated('auction_id', context) ?? 'Auction id'} #$auctionId',
            style: titilliumRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        SizedBox(
          width: 25,
          height: 25,
          child: PopupMenuButton<String>(
            padding: EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
            color: Theme.of(context).cardColor,
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.more_vert_rounded,
              size: Dimensions.iconSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            onSelected: (value) {
              if (value == 'view') {
                RouterHelper.getCreatorAuctionDetailsRoute(slug: slug);
              } else if (value == 'relaunch') {
                onRelaunch?.call();
              } else if (value == 'cancel') {
                onCancel?.call();
              } else if (value == 'delete') {
                onDelete?.call();
              } else if (value == 'edit') {
                onEdit?.call();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'view',
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: PopupMenuIconItem(
                  label: getTranslated('view_details', context) ?? 'View Details',
                  icon: Icons.remove_red_eye,
                ),
              ),
              if (auctionStatus == UserCreatedAuctionPurchaseEnum.unsold ||
                  auctionStatus == UserCreatedAuctionPurchaseEnum.recreated)
                PopupMenuItem<String>(
                  value: 'relaunch',
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: PopupMenuIconItem(
                    label: getTranslated('relaunch', context) ?? 'Relaunch',
                    icon: Icons.refresh,
                  ),
                ),

              if (auctionStatus == UserCreatedAuctionPurchaseEnum.upcoming)
                PopupMenuItem<String>(
                  value: 'delete',
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: PopupMenuIconItem(
                    label: getTranslated('delete_auction', context) ?? 'Delete Auction',
                    icon: Icons.delete_outline,
                  ),
                ),

              if (auctionStatus == UserCreatedAuctionPurchaseEnum.canceled) ...[
                PopupMenuItem<String>(
                  value: 'edit',
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: PopupMenuIconItem(
                    label: getTranslated('edit_auction', context) ?? 'Edit Auction',
                    icon: Icons.edit_outlined,
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: PopupMenuIconItem(
                    label: getTranslated('delete_auction', context) ?? 'Delete Auction',
                    icon: Icons.delete_outline,
                  ),
                ),
              ],

              if (auctionStatus == UserCreatedAuctionPurchaseEnum.unsold ||
                  auctionStatus == UserCreatedAuctionPurchaseEnum.recreated ||
                  (auctionStatus == UserCreatedAuctionPurchaseEnum.live && (participantCount == 0 || participantCount == null)))
                PopupMenuItem<String>(
                  value: 'cancel',
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: PopupMenuIconItem(
                    label: getTranslated('cancel_auction', context) ?? 'Cancel Auction',
                    icon: Icons.cancel_outlined,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class AuctionListProductName extends StatelessWidget {
  final String productName;

  const AuctionListProductName({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Text(productName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textBold.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}

class AuctionListPriceSection extends StatelessWidget {
  final bool isUpcoming;
  final bool isLive;
  final bool isActionable;
  final double startingPrice;
  final double highestBidAmount;

  const AuctionListPriceSection({
    super.key,
    required this.isUpcoming,
    required this.isLive,
    required this.isActionable,
    required this.startingPrice,
    required this.highestBidAmount,
  });

  @override
  Widget build(BuildContext context) {
    if (isUpcoming) {
      return AuctionPriceRow(
        label: getTranslated('start_price', context) ?? 'Starting Price',
        value: PriceConverter.convertPrice(context, startingPrice),
      );
    }

    if (isLive) {
      return AuctionPriceRow(
        label: getTranslated('highest_bid', context) ?? 'Highest Bid',
        value: PriceConverter.convertPrice(context, highestBidAmount),
      );
    }

    if (isActionable) {
      return AuctionPriceRow(
        label: getTranslated('final_price', context) ?? 'Final Price',
        value: PriceConverter.convertPrice(context, highestBidAmount),
      );
    }

    return AuctionPriceRow(
      label: getTranslated('start_price', context) ?? 'Starting Price',
      value: PriceConverter.convertPrice(context, startingPrice),
    );
  }
}

class AuctionPriceRow extends StatelessWidget {
  final String label;
  final String value;

  const AuctionPriceRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Text(
          value,
          style: titilliumBold.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class AuctionListBottomRow extends StatelessWidget {
  final int viewCount;
  final bool isUpcoming;
  final bool isLive;
  final int? participantCount;
  final int totalBidCount;

  const AuctionListBottomRow({
    super.key,
    required this.viewCount,
    required this.isUpcoming,
    required this.isLive,
    this.participantCount,
    required this.totalBidCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
         children:[
          Icon(Icons.remove_red_eye, size: Dimensions.iconSizeSmall, color: Theme.of(context).hintColor),
          const SizedBox(width: Dimensions.paddingSizeExtraExtraSmall),

          Text('$viewCount',
            style: titilliumRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ]),
        const Spacer(),

        if (isUpcoming && participantCount != null) ...[
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${getTranslated('participants', context) ?? 'Participants'} ',
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                TextSpan(
                  text: '$participantCount',
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          )
        ] else if (isLive) ...[
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${getTranslated('total_bids', context) ?? 'Total bids'} ',
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                TextSpan(
                  text: '$totalBidCount',
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          )
        ],
        const Spacer(),
      ],
    );
  }
}

class AuctionListActionButton extends StatefulWidget {
  final String slug;
  final double adminCommission;
  final String? claimPaymentStatus;

  const AuctionListActionButton({
    super.key,
    required this.slug,
    required this.adminCommission,
    this.claimPaymentStatus,
  });

  @override
  State<AuctionListActionButton> createState() => _AuctionListActionButtonState();
}

class _AuctionListActionButtonState extends State<AuctionListActionButton> {
  final JustTheController _tooltipController = JustTheController();

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showPayNow = widget.adminCommission > 0;
    final bool isWithdrawDisabled = !showPayNow && widget.claimPaymentStatus == 'unpaid';

    final buttonChild = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeEight,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(Dimensions.radiusHundred),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            showPayNow
                ? (getTranslated('pay_now', context) ?? 'Pay Now')
                : (getTranslated('withdraw_money', context) ?? 'Withdraw Money'),
            style: titilliumSemiBold.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: isWithdrawDisabled ? Colors.white.withValues(alpha: 0.5) : Colors.white,
            ),
          ),
          if (isWithdrawDisabled) ...[
            const SizedBox(width: Dimensions.paddingSizeExtraExtraSmall),
            JustTheTooltip(
              controller: _tooltipController,
              tailLength: 10,
              tailBaseWidth: 20,
              backgroundColor: Colors.black87,
              content: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeEight),
                child: Text(
                  getTranslated('withdraw_disabled_unpaid', context) ?? 'Payment must be completed before withdrawal can be requested',
                  style: titilliumRegular.copyWith(color: Colors.white),
                ),
              ),
              child: GestureDetector(
                onTap: () => _tooltipController.showTooltip(),
                child: const Icon(Icons.info_outline, size: 16, color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );

    if (isWithdrawDisabled) {
      return Opacity(opacity: 0.5, child: buttonChild);
    }

    return GestureDetector(
      onTap: () {
        RouterHelper.getCreatorAuctionDetailsRoute(
          slug: widget.slug,
          action: RouteAction.push,
          routeAction: showPayNow
              ? CreatorAuctionDetailsRouteAction.payCommission
              : CreatorAuctionDetailsRouteAction.withdraw,
        );
      },
      child: buttonChild,
    );
  }
}

class PopupMenuIconItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? iconColor;

  const PopupMenuIconItem({super.key, required this.label, required this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
          style: titilliumRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const Spacer(),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
          child: Icon(icon, size: Dimensions.iconSizeExtraSmall, color: Colors.white),
        ),
      ],
    );
  }
}