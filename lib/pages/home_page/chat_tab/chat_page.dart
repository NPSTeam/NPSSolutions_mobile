import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../configs/themes/color_const.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/chat_controller.dart';
import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../../../services/notification_service.dart';
import '../../../services/sockjs.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chat});

  final ChatModel chat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _chatController = Get.put(ChatController());

  final TextEditingController _messageController = TextEditingController();

  _loadData() async {
    await EasyLoading.show();

    await _chatController.getMessages(widget.chat.contactId!);
    _chatController.messages
        .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    if (!SockJS.client.isActive) {
      SockJS.client.activate();
    }

    if (SockJS.client.isActive) {
      SockJS.client.subscribe(
        destination:
            '/chat-contact/userId/${Get.find<AuthController>().auth?.currentUser?.id}/chatId/${widget.chat.contactId}',
        callback: (message) {
          debugPrint(message.body);

          if (message.body != null) {
            MessageModel messageModel =
                MessageModel.fromJson(jsonDecode(message.body!));

            _chatController.messages.insert(0, messageModel);
            _chatController.update();

            NotificationService.showNotification(
                title: widget.chat.contact?.name ?? 'New message',
                body: messageModel.value ?? '');
          }
        },
      );
    }

    await EasyLoading.dismiss();
  }

  @override
  void initState() {
    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.primary,
          centerTitle: true,
          title: Text(widget.chat.contact?.name ?? 'Chat'),
          // actions: [
          //   PopupMenuButton(
          //     shape:
          //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //     onSelected: (value) async {
          //       if (value == 'DELETE') {
          //         await EasyLoading.show(status: 'Deleting...');
          //         // await _taskDetailController.deleteTask(widget.taskId);
          //         await EasyLoading.dismiss();

          //         Get.back();
          //       }
          //     },
          //     itemBuilder: (_) {
          //       return [
          //         PopupMenuItem(
          //           value: 'DELETE',
          //           child: Row(
          //             children: const [
          //               Icon(Ionicons.trash_outline, color: Colors.black),
          //               SizedBox(width: 10),
          //               Text('Delete'),
          //             ],
          //           ),
          //         ),
          //       ];
          //     },
          //   ),
          // ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: chatController.messages[index].chatId !=
                            widget.chat.contactId
                        ? ChatBubble(
                            clipper: ChatBubbleClipper5(
                                type: BubbleType.receiverBubble),
                            backGroundColor: const Color(0xffE7E7ED),
                            margin: const EdgeInsets.only(top: 5),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Text(
                                chatController.messages[index].value ?? '',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        : ChatBubble(
                            clipper:
                                ChatBubbleClipper5(type: BubbleType.sendBubble),
                            alignment: Alignment.topRight,
                            margin: const EdgeInsets.only(top: 5),
                            backGroundColor: Colors.blue,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Text(
                                chatController.messages[index].value ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                                width: 3, color: Colors.greenAccent)),
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      NotificationService.showNotification(
                          title:
                              'New message from ${widget.chat.contact?.name}',
                          body: _messageController.text.trim());
                      return;

                      if (_messageController.text.trim().isEmpty) return;

                      chatController.sendMessage(MessageModel(
                        chatId: widget.chat.contactId!,
                        contactId:
                            Get.find<AuthController>().auth?.currentUser?.id!,
                        value: _messageController.text.trim(),
                        createdAt: DateTime.now(),
                      ));

                      _messageController.clear();
                    },
                    child: const Icon(Ionicons.send_outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
