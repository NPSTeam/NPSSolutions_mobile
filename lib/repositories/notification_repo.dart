import 'package:nps_social/models/notification_model.dart';
import 'package:nps_social/repositories/crud_repo.dart';

final notificationRepository = _NotificationRepository();

class _NotificationRepository extends CrudRepository {
  Future<List<NotificationModel>?> getNotifications() async {
    List<NotificationModel>? notifications;

    var result = await get('/api/notify/getNotifies');
    if (result?.data['notifies'] != null) {
      notifications = List<NotificationModel>.from(
          result?.data['notifies'].map((e) => NotificationModel.fromJson(e)));
      return notifications;
    }
    return null;
  }
}
