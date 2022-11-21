import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nps_social/configs/app_key.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketClient {
  static init({required String refreshToken}) async {
    Socket socket = io(
      AppKey.BACKEND_URL,
      OptionBuilder().setTransports(['websocket']).setExtraHeaders({
        "Authorization": "Bearer $refreshToken",
      }).build(),
    );

    socket.connect();
    socket.onConnect((data) {
      debugPrint("Connected Socket");
      debugPrint("$data");
    });

    socket.on('addMessageToClient', (data) {
      debugPrint("addMessageToClient");
      debugPrint("$data");
    });

    socket.on('addMessage', (data) {
      debugPrint("addMessage");
    });
  }
}
