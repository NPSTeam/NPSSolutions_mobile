import 'package:flutter/foundation.dart';
import 'package:npssolutions_mobile/configs/app_key.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class SockJS {
  static StompClient client = StompClient(
      config: StompConfig.SockJS(
    url: 'https://npssolutions.works/our-websocket',
    webSocketConnectHeaders: {
      'Upgrade': 'websocket',
      'Connection': 'Upgrade',
    },
    onConnect: (frame) => debugPrint('SockJS - onConnect: $frame'),
    onDisconnect: (frame) => debugPrint('SockJS - onDisconnect: $frame'),
    onStompError: (frame) => debugPrint('SockJS - onStompError: $frame'),
    onWebSocketError: (frame) =>
        debugPrint('SockJS - onWebSocketError: $frame'),
  ));

  static Future<void> connect() async {
    // if (!client.isActive) {
    client.activate();
    // }
  }
}
