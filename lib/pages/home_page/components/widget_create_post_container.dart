import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/create_post_page/create_post_page.dart';
import 'package:nps_social/widgets/widget_profile_avatar.dart';

class WidgetCreatePostContainer extends StatelessWidget {
  final UserModel? currentUser;

  const WidgetCreatePostContainer({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
        Get.to(
          () => const CreatePostPage(),
          transition: Transition.cupertino,
        );
      },
      child: AbsorbPointer(
        absorbing: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  WidgetProfileAvatar(imageUrl: currentUser?.avatar ?? ''),
                  const SizedBox(width: 8.0),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        hintText: "What's on your mind? ",
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                height: 10.0,
                thickness: 0.5,
              ),
              SizedBox(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () => debugPrint("Live"),
                      icon: const Icon(
                        Icons.videocam,
                        color: Colors.red,
                      ),
                      label: const Text(
                        "Live",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const VerticalDivider(width: 8.0, thickness: 0.8),
                    TextButton.icon(
                      onPressed: () => debugPrint("Photo"),
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.green,
                      ),
                      label: const Text(
                        "Photo",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const VerticalDivider(width: 8.0, thickness: 0.8),
                    TextButton.icon(
                      onPressed: () => debugPrint("Room"),
                      icon: const Icon(
                        Icons.video_call,
                        color: Colors.purpleAccent,
                      ),
                      label: const Text(
                        "Room",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}