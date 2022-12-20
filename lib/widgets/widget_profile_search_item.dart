import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/configs/theme/style_const.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/personal_profile_page/controllers/personal_profile_controller.dart';
import 'package:nps_social/pages/personal_profile_page/personal_profile_page.dart';

import '../configs/theme/color_const.dart';

class WidgetProfileSearchItem extends StatelessWidget {
  final UserModel user;
  final PersonalProfileController _profileController = Get.find();
  WidgetProfileSearchItem({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => PersonalProfilePage(userId: user.id ?? ''),
          transition: Transition.cupertino,
        )?.then((_) {
          _profileController.selectedUser = null;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: ColorConst.blue,
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    user.avatar != '' ? NetworkImage(user.avatar ?? '') : null,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName ?? '', style: StyleConst.boldStyle()),
                Text(user.email ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
