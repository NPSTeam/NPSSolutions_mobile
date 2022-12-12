import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/message_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/utils/datetime_convert.dart';

class MessageItem extends StatelessWidget {
  MessageItem({super.key, required this.message});
  MessageModel message;

  @override
  Widget build(BuildContext context) {
    UserModel? currentUser = Get.find<AuthController>().currentUser;

    return message.senderId == currentUser?.id ? rightItem() : leftItem();
  }

  Widget leftItem() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black45, width: 0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  if (message.text != null && message.text != '') {
                    return Text(
                      message.text ?? '',
                      maxLines: 10,
                    );
                  } else if (message.media != null) {
                    return CachedNetworkImage(
                      imageUrl: message.media?[0].url ?? '',
                      imageBuilder: (context, imageProvider) => Container(
                        width: Get.width * 0.7,
                        height: Get.width * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    );
                  } else {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(message.call?.video == true
                            ? Ionicons.videocam_off_outline
                            : Ionicons.call_outline),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            Text(message.call?.video == true
                                ? "Video Call"
                                : "Audio Call"),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            dateTimeToString(
                message.createdAt ?? DateTime.now(),
                message.createdAt?.day == DateTime.now().day
                    ? "hh:mm"
                    : "MM:dd"),
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget rightItem() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            dateTimeToString(
                message.createdAt ?? DateTime.now(),
                message.createdAt?.day == DateTime.now().day
                    ? "hh:mm"
                    : "MM:dd"),
            style: const TextStyle(fontSize: 10),
          ),
          const SizedBox(width: 5),
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            color: ColorConst.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  if (message.text != null && message.text != '') {
                    return Text(
                      message.text ?? '',
                      style: const TextStyle(color: Colors.white),
                      maxLines: 10,
                    );
                  } else if (message.media != null) {
                    return CachedNetworkImage(
                      imageUrl: message.media?[0].url ?? '',
                      imageBuilder: (context, imageProvider) => Container(
                        width: Get.width * 0.7,
                        height: Get.width * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    );
                  } else {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          message.call?.video == true
                              ? Ionicons.videocam_off_outline
                              : Ionicons.call_outline,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            Text(
                              message.call?.video == true
                                  ? "Video Call"
                                  : "Audio Call",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
