import 'package:flutter/material.dart';
import 'package:nps_social/configs/theme/color_const.dart';

class WidgetButtonTabBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;
  final TabController? controller;

  const WidgetButtonTabBar({
    Key? key,
    required this.icons,
    required this.selectedIndex,
    required this.onTap,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicatorPadding: EdgeInsets.zero,
      indicator: const BoxDecoration(
          border: Border(
              top: BorderSide(
        color: ColorConst.blue,
        width: 3.0,
      ))),
      tabs: icons
          .asMap()
          .map((i, e) => MapEntry(
                i,
                Tab(
                  icon: Icon(
                    e,
                    color:
                        i == selectedIndex ? ColorConst.blue : Colors.black45,
                    size: 30.0,
                  ),
                ),
              ))
          .values
          .toList(),
      onTap: onTap,
    );
  }
}
