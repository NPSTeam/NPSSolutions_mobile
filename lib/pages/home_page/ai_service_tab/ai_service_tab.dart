import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AISerivceTab extends StatefulWidget {
  const AISerivceTab({super.key});

  @override
  State<AISerivceTab> createState() => _AISerivceTabState();
}

class _AISerivceTabState extends State<AISerivceTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const WebView(
          initialUrl: 'https://npssocial.site/',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
