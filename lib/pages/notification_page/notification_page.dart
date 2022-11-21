import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/controllers/notification_controller.dart';
import 'package:nps_social/models/notification_model.dart';
import 'package:nps_social/pages/notification_page/components/notification_item.dart';

import '../../configs/theme/color_const.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController _notificationController = Get.find();
  bool isLoadingNotification = true;

  @override
  void initState() {
    _notificationController.getNotifications().then((_) {
      setState(() {
        isLoadingNotification = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "Notifications",
              style: TextStyle(
                color: ColorConst.blue,
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2,
              ),
            ),
            centerTitle: false,
            floating: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/icons/alarm.png",
                height: 30,
                width: 30,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () async {
                    debugPrint("Read all notifications");
                  },
                  icon: const Icon(
                    Ionicons.notifications_off_outline,
                    color: ColorConst.grey,
                  ),
                  iconSize: 25,
                ),
              ),
            ],
          ),
          isLoadingNotification
              ? const SliverPadding(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                  sliver: SliverToBoxAdapter(
                    child: SpinKitThreeBounce(
                      color: ColorConst.blue,
                      size: 30,
                    ),
                  ),
                )
              : GetBuilder<NotificationController>(
                  builder: (controller) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final int itemIndex = index ~/ 2;
                        if (index.isEven) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: NotificationItem(
                              notification:
                                  controller.allNotifications?[itemIndex] ??
                                      NotificationModel(),
                            ),
                          );
                        }
                        return const Divider(height: 0, color: Colors.grey);
                      },
                      semanticIndexCallback: (Widget widget, int localIndex) {
                        if (localIndex.isEven) {
                          return localIndex ~/ 2;
                        }
                        return null;
                      },
                      childCount: math.max(0,
                          (controller.allNotifications?.length ?? 0) * 2 - 1),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
