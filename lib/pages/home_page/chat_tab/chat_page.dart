import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../configs/themes/color_const.dart';
import '../../../controllers/chat_controller.dart';
import '../../../models/chat_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chat});

  final ChatModel chat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController _chatController = Get.put(ChatController());

  _loadData() async {
    await _chatController.getMessages(widget.chat.id!);
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
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ChatBubble(
              clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 20),
              backGroundColor: Colors.blue,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
