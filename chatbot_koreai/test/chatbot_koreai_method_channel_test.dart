import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatbot_koreai/chatbot_koreai_method_channel.dart';

void main() {
  MethodChannelChatbotKoreai platform = MethodChannelChatbotKoreai();
  const MethodChannel channel = MethodChannel('chatbot_koreai');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
