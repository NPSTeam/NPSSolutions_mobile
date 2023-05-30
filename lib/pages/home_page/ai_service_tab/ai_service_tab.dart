import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webviewx/webviewx.dart';

class AISerivceTab extends StatefulWidget {
  const AISerivceTab({super.key});

  @override
  State<AISerivceTab> createState() => _AISerivceTabState();
}

class _AISerivceTabState extends State<AISerivceTab> {
  // late WebViewXController webviewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const WebView(
          initialUrl: 'http://167.172.78.210:7860/',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
