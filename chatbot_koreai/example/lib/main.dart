import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:chatbot_koreai/chatbot_koreai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = 
          'Unknown platform version';
      
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _MyWidget(),
    );
  }
}

class _MyWidget extends StatefulWidget {
  const _MyWidget();

  @override
  State<_MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<_MyWidget> {

  final _chatbotKoreaiPlugin = ChatbotKoreai();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {

    start();
    });
  }

  start() async {
    try {
      _chatbotKoreaiPlugin.configureChatBot(botId: "st-4b8ee63f-0bad-5657-b799-a8c414b9a086", clientId: "cs-7b5563e1-4548-5515-adce-476975efb41e", clientSecret: "f4Gxy/HE5Mk2TSglZFMYCe54OgjT+N1CHDBBJD6xcyU=", userId: "martin.bonardi+dev.2@kore.com", assertion: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODU0ODYxNzA3MzIsImV4cCI6MTY4NTU3MjU3MDczMiwiYXVkIjoiaHR0cHM6Ly9pZHByb3h5LmtvcmUuY29tL2F1dGhvcml6ZSIsImlzcyI6ImNzLTdiMjJiMzFiLTQ4ZWItNTYyMy1hOWUxLTNjY2ZiY2Y2MDkwNyIsInN1YiI6ImU4NDhkMGUzLWY3MjAtNDEyYi04OTlkLTQyNzQ2NDg1YWVhZSIsImlzQW5vbnltb3VzIjoiZmFsc2UifQ.ln15PRh1305OZfOI7o4EnmnO8q3um_3yG1rcIhl793I", chatBot: "Cora Suporte 90", userInfo: {
                        "firstName": "Martin",
                        "lastName": "Bonardi",
                        "email": "martin.bonardi@kore.com",
                        "device_id": "12312321",
                        "user_data": {
                            "device_token": "teste", "platform": "Android"
                        }
    }, context: context);
    _chatbotKoreaiPlugin.start();
    
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}