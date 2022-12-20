import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/pages/personal_profile_page/components/profile_post_container.dart';
import 'package:nps_social/pages/personal_profile_page/controllers/personal_profile_controller.dart';

import '../../../configs/theme/color_const.dart';
import '../../../models/user_model.dart';

class ProfilePostListWidget extends StatefulWidget {
  const ProfilePostListWidget({super.key});

  @override
  State<ProfilePostListWidget> createState() => _ProfilePostListWidgetState();
}

class _ProfilePostListWidgetState extends State<ProfilePostListWidget> {
  final UserModel? currentUser = Get.find<AuthController>().currentUser;
  PersonalProfileController _profileController = Get.find();
  bool isLoadingPosts = true;

  @override
  void initState() {
    _profileController.fetchUserPosts().then((_) {
      setState(() {
        isLoadingPosts = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingPosts
        ? const SpinKitThreeBounce(
            color: ColorConst.blue,
            size: 30,
          )
        : GetBuilder<PersonalProfileController>(
            builder: (controller) {
              return (controller.userPostList?.isEmpty ?? false)
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "No content",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ))
                  : Column(
                      children: List.generate(
                          controller.userPostList?.length ?? 0,
                          (index) => ProfilePostContainer(
                                post: controller.userPostList?[index] ??
                                    PostModel(),
                              )),
                    );
            },
          );
  }
}
