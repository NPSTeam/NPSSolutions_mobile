import 'package:flutter/material.dart';
import 'package:npssolutions_mobile/configs/themes/color_const.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorConst.primary,
      child: ListView(
        children: const [
          // CircleAvatar(
          //   radius: 40.0,
          //   backgroundColor: Colors.blueGrey,
          //   child: CircleAvatar(
          //     radius: 40.0,
          //     backgroundColor: Colors.transparent,
          //     backgroundImage: NetworkImage(
          //         'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
          //   ),
          // )
          DrawerHeader(
            child: Center(
              child: CircleAvatar(
                radius: 42.0,
                backgroundColor: Colors.blueGrey,
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
