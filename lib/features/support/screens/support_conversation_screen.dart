import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/controllers/support_ticket_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_ticket_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/widgets/support_ticket_description_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/widgets/support_ticket_reply_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:provider/provider.dart';

class SupportConversationScreen extends StatefulWidget {
  final SupportTicketModel supportTicketModel;
  const SupportConversationScreen({super.key, required this.supportTicketModel});

  @override
  State<SupportConversationScreen> createState() => _SupportConversationScreenState();
}

class _SupportConversationScreenState extends State<SupportConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final DebounceHelper _tapGuard = DebounceHelper(milliseconds: 500);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<SupportTicketController>(context, listen: false).getSupportTicketReplyList(context, widget.supportTicketModel.id);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tapGuard.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.supportTicketModel.subject,),
      body: Consumer<SupportTicketController>(
        builder: (context, support, child) {
          return Column(children: [

            Expanded(child: Consumer<SupportTicketController>(builder: (context, support, child) {
              final SupportTicketModel ticket = (support.conversationTicket?.id == widget.supportTicketModel.id
                  && (support.conversationTicket?.description?.trim().isNotEmpty ?? false))
                  ? support.conversationTicket! : widget.supportTicketModel;
              final bool showDescription = (ticket.description?.trim().isNotEmpty ?? false)
                  && support.supportReplyList != null
                  && (support.replyTotalSize == null || support.supportReplyList!.length >= support.replyTotalSize!);
              return support.supportReplyList != null ?
              PaginatedListView(
                scrollController: _scrollController,
                reverse: true,
                totalSize: support.replyTotalSize,
                offset: support.replyOffset ?? 1,
                limit: support.replyLimit ?? 25,
                onPaginate: (int? offset) async => await support.getSupportTicketReplyList(
                  context, widget.supportTicketModel.id, offset: offset ?? 1, reload: false,
                ),
                itemView: Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: support.supportReplyList!.length + (showDescription ? 1 : 0),
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (index == support.supportReplyList!.length) {
                        return SupportTicketDescriptionWidget(ticket: ticket);
                      }
                      final reply = support.supportReplyList![index];
                      bool isMe = reply.isSentByCustomer;
                      String? message = reply.message;
                      final DateTime? sentAt = DateTime.tryParse(reply.createdAt ?? '');
                      String dateTime = sentAt != null ? DateConverter.localDateToIsoStringAMPM(sentAt) : '';
                      return SupportTicketReplyWidget(message: message, dateTime: dateTime, isMe: isMe, replyModel: reply);
                    },
                  ),
                ),
              ) : const Center(child: CircularProgressIndicator());
            })),

            support.pickedImageFileStored.isNotEmpty ?
            Container(height: 90, width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(scrollDirection: Axis.horizontal,
                itemBuilder: (context,index) {
                return  Stack(children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ClipRRect(borderRadius: BorderRadius.circular(10),
                      child: SizedBox(height: 80, width: 80,
                        child: Image.file(File(support.pickedImageFileStored[index].path),
                          fit: BoxFit.cover)))
                  ),

                  Positioned(right: 5, child: InkWell(
                    child: const Icon(Icons.cancel_outlined, color: Colors.red),
                    onTap: () => support.pickMultipleImage(true,index: index)))
                  ]);
                },
                itemCount: support.pickedImageFileStored.length)
            ) : const SizedBox(),

            SizedBox(height: 70,
              child: Card(color: Theme.of(context).highlightColor,
                shadowColor: Colors.grey[200],
                elevation: 2,
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Row(children: [
                    Expanded(child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: TextField(
                        controller: _controller,
                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            hintText: 'Type here...',
                            hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault),
                            border: InputBorder.none,
                            suffixIcon: InkWell(onTap: ()=> support.pickMultipleImage(false),
                              child: Padding(padding: const EdgeInsets.all(8.0),
                                child: Image.asset(Images.attachment))))
                        ),
                    )
                    ),

                    InkWell(onTap: () {
                        if(_controller.text.isEmpty && support.pickedImageFileStored.isEmpty ){

                        }else{
                          _tapGuard.runOnce(() {
                            support.sendReply(widget.supportTicketModel.id, _controller.text);
                            _controller.text = '';
                          });
                        }
                      },
                      child: support.isLoading ? const CircularProgressIndicator() : Icon(Icons.send, color: Theme.of(context).primaryColor, size: Dimensions.iconSizeDefault),
                    ),


                  ]),
                ),
              ),
            ),

          ]);
        }
      ),
    );
  }
}
