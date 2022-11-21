import 'package:flutter/material.dart';
import 'package:nps_social/configs/theme/style_const.dart';
import 'package:nps_social/models/notification_model.dart';
import 'package:nps_social/widgets/widget_profile_avatar.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WidgetProfileAvatar(imageUrl: notification.user?.avatar ?? ''),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: notification.user?.fullName ?? '',
                      style: StyleConst.boldStyle(),
                    ),
                    TextSpan(
                      text: " ${notification.text}",
                    ),
                  ],
                ),
              ),
            ),
            if (notification.content != null && notification.content != '')
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  notification.content ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(notification.image ?? ''),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
