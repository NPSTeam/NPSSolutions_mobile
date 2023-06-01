import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../configs/themes/color_const.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.primary,
        centerTitle: true,
        title: const Text("Task"),
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
    );
  }
}
