import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_reply_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_ticket_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/widgets/support_ticket_reply_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';

class SupportTicketDescriptionWidget extends StatelessWidget {
  final SupportTicketModel ticket;
  const SupportTicketDescriptionWidget({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final DateTime? createdAt = DateTime.tryParse(ticket.createdAt ?? '');
    return SupportTicketReplyWidget(
      message: ticket.description,
      dateTime: createdAt != null
          ? DateConverter.localDateToIsoStringAMPM(createdAt)
          : '',
      isMe: true,
      replyModel: SupportReplyModel(
        supportTicketId: ticket.id,
        message: ticket.description,
        sentBy: 'customer',
        createdAt: ticket.createdAt,
        attachmentFullUrl: ticket.attachmentFullUrl,
      ),
    );
  }
}
