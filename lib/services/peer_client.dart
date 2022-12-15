import 'package:peerdart/peerdart.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

class PeerClient {
  static late Peer peer;

  static init() async {
    peer = Peer(id: '', options: PeerOptions(path: '/', secure: true));
    final _localRenderer = webrtc.RTCVideoRenderer();
    _localRenderer.initialize();

    peer.on<MediaConnection>('call').listen((call) async {
      final mediaStream = await webrtc.navigator.mediaDevices
          .getUserMedia({"audio": true, "video": false});

      call.answer(mediaStream);

      // call.on("close").listen((event) {
      //   setState(() {
      //     inCall = false;
      //   });
      // });

      // Get peer stream
      call.on<webrtc.MediaStream>("stream").listen((event) async {
        _localRenderer.srcObject = mediaStream;

        // setState(() {
        //   inCall = true;
        // });
      });
    });
  }
}
