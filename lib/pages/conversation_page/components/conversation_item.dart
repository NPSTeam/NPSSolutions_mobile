import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/configs/theme/style_const.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/conversation_model.dart';
import 'package:nps_social/models/user_model.dart';

class ConversationItem extends StatefulWidget {
  ConversationItem({super.key, required this.conversation});

  ConversationModel conversation;

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  late UserModel user;

  @override
  void initState() {
    user = widget.conversation.recipients?.firstWhere(
            (e) => e.id != Get.find<AuthController>().currentUser?.id) ??
        UserModel();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(user.avatar ?? ''),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.fullName ?? '',
              style: StyleConst.boldStyle(),
            ),
            Text(widget.conversation.text ?? ''),
          ],
        ),
      ],
    );
  }
}
