import 'package:chatbot_koreai/src/view/chatbot_screen.dart';
import 'package:chatbot_koreai/src/viewModel/chatbot_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatbotKoreai {
  static final ChatbotKoreai _instance = ChatbotKoreai._();
  ChatbotKoreai._();
  factory ChatbotKoreai() => _instance;

  late Color? _backgroundBottom;
  late Color? _colorIconSend;
  late Color? _backgroundContent;
  late Color? _backgroundAppbar;
  late String? _textAppBar;
  late bool? _centerTitle;
  late String? _hintText;
  late IconData? _iconAppBarClose;
  late Color? _iconAppBarCloseColor;
  late Color? _textAppBarColor;
  late Color? _textTypingAppBarColor;
  late String? _pathImageAppBar;
  late bool? _hasImageAppBar;
  late Color? _colorStatusBar;
  late Color? _colorBackgroundButtonCards;
  late Color? _colorTextButtonCards;
  // card robot
  late Color? _colorTextRobotMessage;
  late Color? _colorRobotCard;
  late Color? _colorRobotIcon;
  late IconData? _iconRobot;
  late bool? _hasIcon;
  // my card
  late Color? _colorTextMyMessage;
  late Color? _colorMyCard;
  // keys
  late String? _botId;
  late String? _userId;
  late String? _clientId;
  late String? _clientSecret;
  late BuildContext? _context;
  late String? _assertion;
  late String? _chatBot;
  late Map? _userInfo;
  late int? _limit;
  late IconData? _iconSuggestion;
  late String? _labelSuggestion;
  late int? _limitSwitchTypeButtons;
  late Color? _dateColorMessagesList;
  late String? _textTyping;

  void configureChatBot(
      {Color? backgroundBottom,
      Color? colorIconSend,
      Color? backgroundContent,
      Color? backgroundAppbar,
      String? textAppBar,
      IconData? iconAppBarClose,
      Color? iconAppBarCloseColor,
      Color? textAppBarColor,
      Color? textTypingAppBarColor,
      String? hintText,
      Color? colorRobotCard,
      Color? colorRobotIcon,
      Color? colorTextRobotMessage,
      IconData? iconRobot,
      Color? colorTextMyMessage,
      Color? colorMyCard,
      bool? hasIcon,
      required String botId,
      required String clientId,
      required String clientSecret,
      required String userId,
      required BuildContext context,
      required String assertion,
      required String chatBot,
      required Map userInfo,
      String? framework,
      String? platform,
      bool? centerTitle,
      String? pathImageAppBar,
      bool? hasImageAppBar,
      Color? colorBackgroundButtonCards,
      Color? colorTextButtonCards,
      Color? colorStatusBar,
      int? limit,
      IconData? iconSuggestion,
      String? labelSuggestion,
      int? limitSwitchTypeButtons,
      Color? dateColorMessagesList,
      String? textTyping}) {
    _context = context;
    _backgroundBottom = backgroundBottom;
    _colorIconSend = colorIconSend;
    _backgroundContent = backgroundContent;
    _backgroundAppbar = backgroundAppbar;
    _textAppBar = textAppBar;
    _iconAppBarClose = iconAppBarClose;
    _hintText = hintText;
    _colorRobotCard = colorRobotCard;
    _colorRobotIcon = colorRobotIcon;
    _colorTextRobotMessage = colorTextRobotMessage;
    _iconRobot = iconRobot;
    _colorTextMyMessage = colorTextMyMessage;
    _colorMyCard = colorMyCard;
    _botId = botId;
    _clientId = clientId;
    _hasIcon = hasIcon;
    _clientSecret = clientSecret;
    _userId = userId;
    _centerTitle = centerTitle;
    _iconAppBarCloseColor = iconAppBarCloseColor;
    _textAppBarColor = textAppBarColor;
    _textTypingAppBarColor = textTypingAppBarColor;
    _pathImageAppBar = pathImageAppBar;
    _hasImageAppBar = hasImageAppBar;
    _colorStatusBar = colorStatusBar;
    _colorBackgroundButtonCards = colorBackgroundButtonCards;
    _colorTextButtonCards = colorTextButtonCards;
    _assertion = assertion;
    _chatBot = chatBot;
    _userInfo = userInfo;
    _limit = limit;
    _iconSuggestion = iconSuggestion;
    _labelSuggestion = labelSuggestion;
    _limitSwitchTypeButtons = limitSwitchTypeButtons;
    _textTyping = textTyping;
    _dateColorMessagesList = dateColorMessagesList;
    if ((hasImageAppBar != null && hasImageAppBar == true) &&
            pathImageAppBar == null ||
        pathImageAppBar == '') {
      throw ErrorDescription(
          "need to inform a path of an image in 'pathImageAppBar'");
    }
  }

  Future<void> start() async {
    Get.put(ChatBotController(_botId!, _clientId!, _clientSecret!, _userId!,
        _assertion!, _chatBot!, _userInfo ?? {}, _limit ?? 30, _context!, _limitSwitchTypeButtons ?? 3));
    await Navigator.of(_context!).push(MaterialPageRoute(
        builder: (ctx) => ChatBot(
            backgroundBottom: _backgroundBottom,
            colorIconSend: _colorIconSend,
            backgroundContent: _backgroundContent,
            backgroundAppbar: _backgroundAppbar,
            textAppBar: _textAppBar,
            iconAppBarClose: _iconAppBarClose,
            hintText: _hintText,
            colorRobotCard: _colorRobotCard,
            colorRobotIcon: _colorRobotIcon,
            colorTextRobotMessage: _colorTextRobotMessage,
            iconRobot: _iconRobot,
            colorTextMyMessage: _colorTextMyMessage,
            colorMyCard: _colorMyCard,
            botId: _botId!,
            clientId: _clientId!,
            hasIcon: _hasIcon ?? false,
            clientSecret: _clientSecret!,
            userId: _userId!,
            iconAppBarCloseColor: _iconAppBarCloseColor,
            textAppBarColor: _textAppBarColor,
            textTypingAppBarColor: _textTypingAppBarColor,
            pathImageAppBar: _pathImageAppBar,
            hasImageAppBar: _hasImageAppBar,
            colorStatusBar: _colorStatusBar,
            colorBackgroundButtonCards: _colorBackgroundButtonCards,
            colorTextButtonCards: _colorTextButtonCards,
            centerTitle: _centerTitle,
            assertion: _assertion!,
            chatBot: _chatBot!,
            userInfo: _userInfo,
            limit: _limit,
            iconSuggestion: _iconSuggestion,
            labelSuggestion: _labelSuggestion,
            limitSwitchTypeButtons: _limitSwitchTypeButtons,
            dateColorMessagesList: _dateColorMessagesList,
            textTyping: _textTyping)));
  }
}
