import 'package:emerge_alert_dialog/emerge_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:npssolutions_mobile/configs/themes/size_const.dart';

class WidgetAppBarAvatar extends StatefulWidget {
  const WidgetAppBarAvatar({super.key});

  @override
  State<WidgetAppBarAvatar> createState() => _WidgetAppBarAvatarState();
}

class _WidgetAppBarAvatarState extends State<WidgetAppBarAvatar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: InkWell(
          onTap: () => _showMyDialog(context),
          child: const CircleAvatar(
            radius: 22.0,
            backgroundColor: Colors.blueGrey,
            child: CircleAvatar(
              radius: 19.0,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
            ),
          ),
        ),
      ),
    );
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
