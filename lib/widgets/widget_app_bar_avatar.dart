import 'package:emerge_alert_dialog/emerge_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/string_const.dart';
import 'package:npssolutions_mobile/configs/themes/assets_const.dart';
import 'package:npssolutions_mobile/configs/themes/size_const.dart';

import '../configs/themes/text_style_const.dart';
import '../controllers/auth_controller.dart';

class WidgetAppBarAvatar extends StatefulWidget {
  const WidgetAppBarAvatar({super.key});

  @override
  State<WidgetAppBarAvatar> createState() => _WidgetAppBarAvatarState();
}

class _WidgetAppBarAvatarState extends State<WidgetAppBarAvatar> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _showMyDialog(context, authController),
            child: CircleAvatar(
              radius: 22.0,
              backgroundColor: Colors.blueGrey,
              child: CircleAvatar(
                radius: 19.0,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    Image.asset(AssetsConst.profileAvatarPlaceholder).image,
                foregroundImage: NetworkImage(
                    authController.auth?.currentUser?.photoURL ??
                        StringConst.placeholderImageUrl),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future _showMyDialog(
      BuildContext context, AuthController authController) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return EmergeAlertDialog(
          alignment: Alignment.topRight,
          emergeAlertDialogOptions: EmergeAlertDialogOptions(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConst.boxRadius),
            ),
            title: Align(
              alignment: Alignment.center,
              child: Text('Account',
                  style: TextStyleConst.semiBoldStyle(fontSize: 20)),
            ),
            content: _content(authController),
          ),
        );
      },
    );
  }

  Widget _content(AuthController authController) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * 0.4),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3)
                ],
              ),
              child: CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    Image.asset(AssetsConst.profileAvatarPlaceholder).image,
                foregroundImage: NetworkImage(
                    authController.auth?.currentUser?.photoURL ??
                        StringConst.placeholderImageUrl),
              ),
            ),
            Text(
              authController.auth?.currentUser?.displayName ?? '',
              style: TextStyleConst.mediumStyle(),
            ),
            const SizedBox(height: 4),
            Text(
              authController.auth?.currentUser?.email ?? '',
              style: TextStyleConst.mediumStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
