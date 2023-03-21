import 'package:emerge_alert_dialog/emerge_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/configs/string_const.dart';
import 'package:npssolutions_mobile/configs/themes/assets_const.dart';
import 'package:npssolutions_mobile/configs/themes/size_const.dart';

import '../controllers/auth_controller.dart';

class WidgetAppBarAvatar extends StatefulWidget {
  const WidgetAppBarAvatar({super.key});

  @override
  State<WidgetAppBarAvatar> createState() => _WidgetAppBarAvatarState();
}

class _WidgetAppBarAvatarState extends State<WidgetAppBarAvatar> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _showMyDialog(context),
            child: CircleAvatar(
              radius: 22.0,
              backgroundColor: Colors.blueGrey,
              child: CircleAvatar(
                radius: 19.0,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    Image.asset(AssetsConst.profileAvatarPlaceholder).image,
                foregroundImage: NetworkImage(
                    controller.auth?.currentUser?.photoURL ??
                        StringConst.placeholderImageUrl),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future _showMyDialog(BuildContext context) async {
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
            title: const Text("Privacy Info"),
            content: _content(),
          ),
        );
      },
    );
  }

  Widget _content() {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
              "The backup created with this functionality may contain some sensitive data."),
          const SizedBox(height: 22.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: size.height * 0.045,
                  width: size.width * 0.3,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(SizeConst.boxRadius),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                height: size.height * 0.045,
                width: size.width * 0.3,
                alignment: Alignment.center,
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
