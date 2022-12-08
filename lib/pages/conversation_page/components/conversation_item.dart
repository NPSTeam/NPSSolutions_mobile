import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.fullName ?? '',
              style: StyleConst.boldStyle(),
            ),
            (widget.conversation.text != null && widget.conversation.text != '')
                ? Text(widget.conversation.text ?? '')
                : (widget.conversation.call?.video == true)
                    ? const Icon(Ionicons.videocam_off_outline)
                    : const Icon(Ionicons.call_outline),
          ],
        ),
      ],
    );
  }
}
