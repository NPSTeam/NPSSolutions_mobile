import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nps_social/configs/app_key.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/configs/theme/style_const.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/pages/call_page/call_page.dart';
import 'package:nps_social/pages/call_page/controllers/call_controller.dart';
import 'package:nps_social/services/peer_client.dart';
import 'package:peerdart/peerdart.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

class SocketClient {
  static late Socket socket;

  static init({required String refreshToken}) async {
    socket = io(
      AppKey.BACKEND_URL,
      OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.connect();
    socket.onConnect((data) {
      debugPrint("Connected Socket");
      if (Get.find<AuthController>().currentUser != null) {
        socket.emit(
            'joinUser', Get.find<AuthController>().currentUser?.toJson());
      }
    });

    socket.on('callUserToClient', (data) {
      print(data);
      String? senderId = data['sender'];
      String? recipientId = data['recipient'];
      String? avatar = data['avatar'];
      String? username = data['username'];
      String? fullName = data['fullName'];
      bool? video = data['video'];
      String? peerId = data['peerId'];

      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fullName ?? '',
                style: StyleConst.boldStyle(fontSize: 25),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(avatar ?? ''),
              ),
              const SizedBox(height: 20),
              Text(
                (video ?? false) ? "Calling Video..." : "Calling Audio...",
                style: StyleConst.regularStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      socket.emit('endCall', {
                        'sender': senderId,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.red, // <-- Button color
                      foregroundColor: ColorConst.blue, // <-- Splash color
                    ),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await PeerClient.openStream().then((stream) async {
                        debugPrint("openStream");
                        debugPrint("peerId: $peerId");

                        // Get.find<CallController>().setMediaStream(
                        //     myMedia: stream, remoteMedia: stream);
                        // Get.to(() => const CallPage());

                        MediaConnection newCall =
                            PeerClient.peer.call(peerId ?? '', stream);

                        newCall
                            .on<webrtc.MediaStream>("stream")
                            .listen((event) {
                          debugPrint("on Stream");
                          Get.find<CallController>().setMediaStream(
                              myMedia: stream, remoteMedia: event);
                          Get.to(() => const CallPage());
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.green, // <-- Button color
                      foregroundColor: ColorConst.blue, // <-- Splash color
                    ),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });

    socket.on('endCallToClient', (data) {
      if (Get.isOverlaysOpen) Navigator.of(Get.overlayContext!).pop();
    });
  }

  //
  static Future openStream(bool video) async {
    return webrtc.navigator.mediaDevices
        .getUserMedia({"audio": true, "video": video});
  }

  static Future playStream() async {}
}
