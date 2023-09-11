import 'dart:ui';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'chatbot_koreai_method_channel.dart';

abstract class ChatbotKoreaiPlatform extends PlatformInterface {
  /// Constructs a ChatbotKoreaiPlatform.
  ChatbotKoreaiPlatform() : super(token: _token);

  static final Object _token = Object();

  static ChatbotKoreaiPlatform _instance = MethodChannelChatbotKoreai();

  /// The default instance of [ChatbotKoreaiPlatform] to use.
  ///
  /// Defaults to [MethodChannelChatbotKoreai].
  static ChatbotKoreaiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ChatbotKoreaiPlatform] when
  /// they register themselves.
  static set instance(ChatbotKoreaiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize() async {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> finalize() async {
    throw UnimplementedError('initialize() has not been implemented.');
  }
  
  Future<void> listenFinalize(VoidCallback callback) async {
    throw UnimplementedError('initialize() has not been implemented.');
  }
}
