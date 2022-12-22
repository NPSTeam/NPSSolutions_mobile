import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/pages/call_page/controllers/call_controller.dart';

class CallPage extends StatefulWidget {
  final Function endCall;

  const CallPage({
    super.key,
    required this.endCall,
  });

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
        return Stack(
          children: [
            webrtc.RTCVideoView(
              controller.remoteRenderer,
              objectFit:
                  webrtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
            Positioned(
              top: 20,
              right: 15,
              width: Get.width * 0.3,
              height: Get.height * 0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: webrtc.RTCVideoView(
                  controller.localRenderer,
                  objectFit:
                      webrtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 50,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    widget.endCall.call();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.red,
                    foregroundColor: ColorConst.blue,
                  ),
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
