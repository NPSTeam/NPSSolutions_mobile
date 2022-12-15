import 'package:permission_handler/permission_handler.dart';

initPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.location,
    Permission.camera,
    Permission.audio,
  ].request();
}
