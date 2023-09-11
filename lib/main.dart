import 'package:chatbot_koreai/chatbot_koreai.dart';
import 'package:chatbot_koreai/chatbot_koreai_method_channel.dart';
import 'package:flutter/material.dart';

void main() => runApp(const _Init());

class _Init extends StatelessWidget {
  const _Init();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _MyWidget(),
    );
  }
}

class _MyWidget extends StatefulWidget {
  const _MyWidget();

  @override
  State<_MyWidget> createState() => __MyWidgetState();
}

class __MyWidgetState extends State<_MyWidget> {
  final _channel = MethodChannelChatbotKoreai();
  final chatbot = ChatbotKoreai();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initPlugin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  void initPlugin() async {
    final event = await _channel.initialize();
    if (Map.from(event).isNotEmpty) {
      chatbot.configureChatBot(botId: event["botId"], clientId: event['clientId'], clientSecret: 
        event['clientSecret'], userId: event['userId'], context: context, assertion: event['assertion'], chatBot: 
        event['chatBot'], userInfo: event['userInfo']);
      await chatbot.start();
      _channel.finalize();
      _channel.listenFinalize(() {
        Navigator.of(context).pop();
      });
    }
  }

}
