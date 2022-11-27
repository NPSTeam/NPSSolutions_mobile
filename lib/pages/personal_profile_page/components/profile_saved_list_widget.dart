import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/pages/personal_profile_page/components/profile_post_container.dart';
import 'package:nps_social/pages/personal_profile_page/controllers/personal_profile_controller.dart';

import '../../../configs/theme/color_const.dart';
import '../../../models/user_model.dart';

class ProfileSavedListWidget extends StatefulWidget {
  const ProfileSavedListWidget({super.key});

  @override
  State<ProfileSavedListWidget> createState() => _ProfileSavedListWidgetState();
}

class _ProfileSavedListWidgetState extends State<ProfileSavedListWidget> {
  final UserModel? currentUser = Get.find<AuthController>().currentUser;
  PersonalProfileController _profileController = Get.find();
  bool isLoadingSaved = true;

  @override
  void initState() {
    _profileController.fetchSavedPosts().then((_) {
      setState(() {
        isLoadingSaved = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingSaved
        ? const SpinKitThreeBounce(
            color: ColorConst.blue,
            size: 30,
          )
        : GetBuilder<PersonalProfileController>(
            builder: (controller) {
              return Column(
                children: List.generate(
                    controller.savedPostList?.length ?? 0,
                    (index) => ProfilePostContainer(
                          post: controller.savedPostList?[index] ?? PostModel(),
                        )),
              );
            },
          );
  }
}
