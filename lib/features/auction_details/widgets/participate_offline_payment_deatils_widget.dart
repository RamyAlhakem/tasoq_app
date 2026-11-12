import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction_details/widgets/auction_offline_payment_screen.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

enum ParticipateOfflinePaymentStatus { pending, approved, denied }

class ParticipateOfflinePaymentDetailsWidget extends StatefulWidget {
  final int auctionId;
  final ParticipateOfflinePaymentStatus status;
  final double participateFee;
  final String? deniedNote;
  final String? bankName;
  final String? bankBranch;
  final String? accountName;
  final String? accountNo;
  final String? methodName;
  final String? accountNumber;
  final double? amount;
  final String? reference;
  final String? paymentNote;
  final Map<String, dynamic>? methodInformations;

  const ParticipateOfflinePaymentDetailsWidget({
    super.key,
    required this.auctionId,
    required this.status,
    required this.participateFee,
    this.deniedNote,
    this.bankName,
    this.bankBranch,
    this.accountName,
    this.accountNo,
    this.methodName,
    this.accountNumber,
    this.amount,
    this.reference,
    this.paymentNote,
    this.methodInformations,
  });

  @override
  State<ParticipateOfflinePaymentDetailsWidget> createState() => _ParticipateOfflinePaymentDetailsWidgetState();
}

class _ParticipateOfflinePaymentDetailsWidgetState extends State<ParticipateOfflinePaymentDetailsWidget> {
  bool _isExpanded = false;

  Color _statusColor(BuildContext context) => switch (widget.status) {
    ParticipateOfflinePaymentStatus.pending => Theme.of(context).colorScheme.primary,
    ParticipateOfflinePaymentStatus.approved => Theme.of(context).colorScheme.onTertiaryContainer,
    ParticipateOfflinePaymentStatus.denied => Theme.of(context).colorScheme.error,
  };

  String _statusLabel(BuildContext context) => switch (widget.status) {
    ParticipateOfflinePaymentStatus.pending => getTranslated('pending', context)!,
    ParticipateOfflinePaymentStatus.approved => getTranslated('approve', context)!,
    ParticipateOfflinePaymentStatus.denied => getTranslated('denied', context)!,
  };

  static const Set<String> _nonInputKeys = {'method_name', 'payment_note', 'amount'};

  @override
  Widget build(BuildContext context) {
    final List<_InfoRow> submittedInputRows = widget.methodInformations != null
        ? widget.methodInformations!.entries.where((entry) => !_nonInputKeys.contains(entry.key) && (entry.value?.toString().trim().isNotEmpty ?? false))
            .map((entry) => _InfoRow(label: _inputLabel(context, entry.key), value: entry.value.toString())).toList()
        : [
            _InfoRow(label: getTranslated('account_number', context)!, value: widget.accountNumber ?? ''),
            _InfoRow(label: getTranslated('reference', context)!, value: widget.reference ?? ''),
          ];

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  getTranslated('participate_payment_details', context)!,
                  style: titilliumBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraExtraSmall),
                decoration: BoxDecoration(
                  color: _statusColor(context).withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(_statusLabel(context),
                  style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: _statusColor(context)),
                ),
              ),
            ],
          ),

          if (_isExpanded) ...[
            const SizedBox(height: Dimensions.paddingSizeDefault),

            if (widget.status == ParticipateOfflinePaymentStatus.denied && widget.deniedNote != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getTranslated('denied_note', context)!,
                      style: titilliumBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall),
                    Text(widget.deniedNote!,
                      style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
            ],

            _InfoCard(
              title: getTranslated('my_submitted_info', context)!,
              trailing: (widget.status == ParticipateOfflinePaymentStatus.pending || widget.status == ParticipateOfflinePaymentStatus.denied)
                  ? GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => AuctionOfflinePaymentScreen(
                    amount: widget.participateFee,
                    auctionId: widget.auctionId,
                    initialMethodName: widget.methodName,
                    initialMethodInformations: widget.methodInformations,
                    initialPaymentNote: widget.paymentNote,
                  ),
                )),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: .3), width: 1.5),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Icon(Icons.edit, size: Dimensions.iconSizeSmall, color: Theme.of(context).colorScheme.primary),
                ),
              ) : null,
              rows: [
                _InfoRow(label: getTranslated('method_name', context)!, value: widget.methodName ?? ''),
                ...submittedInputRows,
                _InfoRow(label: getTranslated('amount', context)!, value: PriceConverter.convertPrice(context, widget.amount ?? 0)),
                if (widget.paymentNote?.trim().isNotEmpty ?? false)
                  _InfoRow(label: getTranslated('payment_note', context)!, value: widget.paymentNote!),
              ],
            ),
          ],
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Center(
            child: GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(
                _isExpanded ? getTranslated('see_less', context)! : getTranslated('see_more', context)!,
                style: titilliumSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;
  final Widget? trailing;

  const _InfoCard({required this.title, required this.rows, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                  style: titilliumBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          ...rows,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraExtraSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: titilliumRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Text(': ',
            style: titilliumRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: titilliumRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _inputLabel(BuildContext context, String key) {
  final String? translated = getTranslated(key, context);
  if (translated != null && translated != key) return translated;
  final String readable = key.replaceAll('_', ' ').trim();
  return readable.isEmpty ? key : '${readable[0].toUpperCase()}${readable.substring(1)}';
}
