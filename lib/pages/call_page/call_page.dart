import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:nps_social/pages/call_page/controllers/call_controller.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CallController>(builder: (controller) {
        return Column(
          children: [
            Expanded(child: webrtc.RTCVideoView(controller.localRenderer)),
            Expanded(child: webrtc.RTCVideoView(controller.remoteRenderer)),
          ],
        );
      }),
    );
  }
}
