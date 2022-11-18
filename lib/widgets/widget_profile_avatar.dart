import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nps_social/configs/theme/color_const.dart';

class WidgetProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final bool isOnline;
  final bool hasBorder;

  const WidgetProfileAvatar({
    Key? key,
    required this.imageUrl,
    this.isOnline = false,
    this.hasBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(imageUrl);
    return Stack(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: ColorConst.blue,
          child: CircleAvatar(
            radius: hasBorder ? 17.0 : 20.0,
            backgroundColor: Colors.grey[200],
            backgroundImage: imageUrl != '' ? NetworkImage(imageUrl) : null,
          ),
        ),
        isOnline
            ? Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Container(
                  height: 15.0,
                  width: 15.0,
                  decoration: BoxDecoration(
                      color: ColorConst.online,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.0,
                        color: Colors.white,
                      )),
                ))
            : const SizedBox.shrink(),
      ],
    );
  }
}