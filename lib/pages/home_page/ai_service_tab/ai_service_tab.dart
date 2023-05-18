import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webviewx/webviewx.dart';

class AISerivceTab extends StatefulWidget {
  const AISerivceTab({super.key});

  @override
  State<AISerivceTab> createState() => _AISerivceTabState();
}

class _AISerivceTabState extends State<AISerivceTab> {
  late WebViewXController webviewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewX(
        width: Get.width * 2.0,
        height: 500,
        initialContent: '''
      <iframe src="http://167.172.78.210:7860/" title="Full Screen ServiceAi" style={{ width: '${Get.width}px', height: '100vh', border: 'none'}}/>

      ''',
        initialSourceType: SourceType.html,
        onWebViewCreated: (controller) => webviewController = controller,
      ),
    );
  }
}
