import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

class CallController extends GetxController {
  webrtc.RTCVideoRenderer localRenderer = webrtc.RTCVideoRenderer();
  webrtc.RTCVideoRenderer remoteRenderer = webrtc.RTCVideoRenderer();

  CallController() {
    localRenderer.initialize();
    remoteRenderer.initialize();
  }

  setMediaStream({
    required webrtc.MediaStream myMedia,
    required webrtc.MediaStream remoteMedia,
  }) {
    localRenderer.setSrcObject(stream: myMedia);
    remoteRenderer.setSrcObject(stream: remoteMedia);
    update();
  }
}
