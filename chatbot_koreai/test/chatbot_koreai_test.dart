import 'package:flutter_test/flutter_test.dart';
import 'package:chatbot_koreai/chatbot_koreai.dart';
import 'package:chatbot_koreai/chatbot_koreai_platform_interface.dart';
import 'package:chatbot_koreai/chatbot_koreai_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockChatbotKoreaiPlatform
    with MockPlatformInterfaceMixin
    implements ChatbotKoreaiPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ChatbotKoreaiPlatform initialPlatform = ChatbotKoreaiPlatform.instance;

  test('$MethodChannelChatbotKoreai is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelChatbotKoreai>());
  });

  test('getPlatformVersion', () async {
    ChatbotKoreai chatbotKoreaiPlugin = ChatbotKoreai();
    MockChatbotKoreaiPlatform fakePlatform = MockChatbotKoreaiPlatform();
    ChatbotKoreaiPlatform.instance = fakePlatform;

    expect(await chatbotKoreaiPlugin.getPlatformVersion(), '42');
  });
}
