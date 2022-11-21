import 'package:get/get.dart';
import 'package:nps_social/models/notification_model.dart';
import 'package:nps_social/repositories/notification_repo.dart';

class NotificationController extends GetxController {
  List<NotificationModel>? allNotifications;

  NotificationController() {}

  Future getNotifications() async {
    allNotifications = await notificationRepository.getNotifications();
    update();
  }
}
