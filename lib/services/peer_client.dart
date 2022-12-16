import 'package:flutter/foundation.dart';
import 'package:peerdart/peerdart.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

class PeerClient {
  static late Peer peer;

  static init() async {
    peer = Peer(options: PeerOptions(path: '/', secure: true));
  }

  static Future<webrtc.MediaStream> openStream() async {
    return await webrtc.navigator.mediaDevices
        .getUserMedia({"audio": true, "video": true});
  }
}
