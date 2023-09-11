import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'chatbot_koreai_platform_interface.dart';

/// An implementation of [ChatbotKoreaiPlatform] that uses method channels.
class MethodChannelChatbotKoreai extends ChatbotKoreaiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel("chatbot_koreai");

  @override
  Future<Map<String, dynamic>> initialize() async {
    final map = await methodChannel.invokeMethod('start');
    final mapObject = map!.cast<String, dynamic>();
    return mapObject;
  }

  @override
  Future<void> finalize() async {
    await methodChannel.invokeMethod('close');
  }

  @override
  Future<void> listenFinalize(VoidCallback callback) async {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "finalizaKotlin") {
        callback.call();
      }
    });
  }
}
