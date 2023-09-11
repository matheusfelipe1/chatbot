
import 'package:chatbot_koreai/src/model/button_model.dart';
import 'package:chatbot_koreai/src/model/chat_model.dart';
import 'package:chatbot_koreai/src/repository/ichat_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../repository/chat_repository.dart';
import '../view/chatbot_screen.dart';

class ChatBotController extends GetxController {
  late String botId;
  late String clientId;
  late String clientSecret;
  late String userId;
  late String assertion;
  late String chatBot;
  late Map userInfo;
  late IChatRepository _repository;
  RxList<ChatModel> chat = RxList<ChatModel>();
  RxList<ButtonsModel> buttons = RxList<ButtonsModel>();
  RxBool gettingMessages = false.obs;
  RxBool isTyping = false.obs;
  ScrollController scroll = ScrollController();
  RxDouble heightListView = 0.0.obs;
  late int? limit;

  final focus = FocusNode();
  final text = TextEditingController();
  late RxBool buttonsInFloat = false.obs;
  late Size size;
  double positionButton = 0.065;
  late BuildContext context;
  late int limitSwitchTypeButtons;

  ChatBotController(
      this.botId,
      this.clientId,
      this.clientSecret,
      this.userId,
      this.assertion,
      this.chatBot,
      this.userInfo,
      this.limit,
      this.context,
      this.limitSwitchTypeButtons);

  @override
  onInit() {
    super.onInit();
    _repository = ChatRepository(botId, clientId, clientSecret, userId,
        assertion, chatBot, userInfo, limit);
    _init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      toScroll;

      final size = MediaQuery.of(context).size;
      heightListView.value = size.width * 1.59;
      _listenButtons();
    });
  }

  @override
  onClose() {
    focus.dispose();
    buttons.close();
    text.clear();
    text.dispose();
    chat.clear();
    chat.close();
    gettingMessages.close();
    isTyping.close();
    heightListView.close();
    scroll.dispose();
    scrollOfList.dispose();
  }

  _init() async {
    await getHistoryMessages();
    if (chat.isEmpty || _verifyAlreadyHasMessageToday()) {
      chat.insert(0, ChatModel(
          messageId: 'initMessage',
          createdOn: DateTime.now(),
          type: 'text',
          fromMe: false,
          val: 'Olá, como podemos te ajudar?'));
    }
    // scrollList;
  }

  bool _verifyAlreadyHasMessageToday() {
    if (chat.isEmpty) return true;
    return !(chat
        .any((element) => (validDatas(element.createdOn!))));
  }

  validDatas(DateTime date) {
    final diff = DateTime.now().difference(date);
    return diff.inDays == 0;
  }

  _listenButtons() {
    buttons.listen((p0) {
      positionButton = 0.065;
      verifyHeight;
    });
  }

  void get verifyHeight => {
        if (limitSwitchTypeButtons != null)
          {
            if (buttons.length <= limitSwitchTypeButtons)
              {
                buttonsInFloat.value = false,
                FocusManager.instance.primaryFocus?.unfocus(),
                heightListView.value = size.width * 1.59,
              }
            else
              {
                buttonsInFloat.value = true,
                heightListView.value = size.width * 1.59,
              }
          }
        else
          {
            if (buttons.length <= 3)
              {
                buttonsInFloat.value = false,
                FocusManager.instance.primaryFocus?.unfocus(),
                heightListView.value = size.width * .95,
              }
            else
              {buttonsInFloat.value = true, heightListView.value = size.width * .95}
          }
      };

  getHistoryMessages() async {
    gettingMessages.value = true;
    final message = await _repository.getHistoryMessage();
    gettingMessages.value = false;
    List<ChatModel> chat = [];
    if (message.isNotEmpty) {
      for (var item in message) {
        chat.add(item);
      }
    }
    this.chat.value = chat.reversed.toList();
  }

  sendMessage(String type, String value) async {
    if (buttons.isNotEmpty) buttons.clear();
    chat.insert(0, ChatModel(
        createdOn: DateTime.now(), type: type, val: value, fromMe: true));
    isTyping.value = true;
    final message = await _repository.sendMessage(type: type, value: value);
    isTyping.value = false;

    if (message.isNotEmpty) {
      for (var item in message) {
        chat.insert(0, item);
        if (item.buttons != null && item.buttons!.isNotEmpty) {
          buttons.addAll(item.buttons!);
        }
      }
    } else {
      chat.first = ChatModel(
          createdOn: DateTime.now(),
          type: type,
          val: value,
          hasError: true,
          fromMe: true);
    }
    toScroll;
    // scrollList;
  }

  void errorMessageChatbot() {
    chat.first = ChatModel(
        createdOn: DateTime.now(),
        type: 'text',
        val: 'Houve um erro ao enviar imagem, tente novamente em instantes.',
        hasError: true,
        fromMe: true);
  }

  getImage(ImageSource source) async {
    if (buttons.isNotEmpty) buttons.clear();
    final fileToken = await _repository.getFileToken();
    // ignore: invalid_use_of_visible_for_testing_member
    final file = await ImagePicker.platform.pickImage(
        source: source, maxHeight: 7000, maxWidth: 6000, imageQuality: 45);
    if (fileToken != null && file != null) {
      chat.insert(0, ChatModel(
          createdOn: DateTime.now(),
          type: 'image',
          val: file.path,
          fromMe: true));
      Future.delayed(
          Duration(milliseconds: source == ImageSource.gallery ? 700 : 1300),
          () {
        toScroll;
        scrollList;
      });
      final fileId = await _repository.sendImage(fileToken, file);
      if (fileId != null) {
        isTyping.value = true;
        final fileOK = await _repository.sendMessage(
          type: 'file',
          value: fileId['hash'],
          fileName: fileId['fileName'],
          fileType: 'image',
          fileId: fileId['fileId'],
        );
        isTyping.value = false;
        if (fileOK.isNotEmpty) {
          for (var item in fileOK) {
            chat.insert(0, item);
            if (item.buttons != null && item.buttons!.isNotEmpty) {
              buttons.addAll(item.buttons!);
            }
          }
        } else {
          final lastChat = chat.first;
          lastChat.hasError = true;
          chat.first = lastChat;
        }
      } else {
        final lastChat = chat.first;
        lastChat.hasError = true;
        chat.first = lastChat;
      }
    }
  }

  getAnyFile() async {
    if (buttons.isNotEmpty) buttons.clear();
    final fileToken = await _repository.getFileToken();
    final file = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (fileToken != null && file != null) {
      isTyping.value = true;
      chat.insert(0, ChatModel(
          createdOn: DateTime.now(),
          type: 'file',
          val: file.files.first.name,
          fromMe: true));
      final fileId = await _repository.sendAnyFile(fileToken, file);
      isTyping.value = false;
      if (fileId != null) {
        isTyping.value = true;
        final fileOK = await _repository.sendMessage(
          type: 'file',
          value: fileId['hash'],
          fileName: fileId['fileName'],
          fileType: 'image',
          fileId: fileId['fileId'],
        );
        isTyping.value = false;
        if (fileOK.isNotEmpty) {
          for (var item in fileOK) {
            chat.insert(0, item);
            if (item.buttons != null && item.buttons!.isNotEmpty) {
              buttons.addAll(item.buttons!);
            }
          }
        } else {
          final lastChat = chat.first;
          lastChat.hasError = true;
          chat.first = lastChat;
        }
      } else {
        final lastChat = chat.first;
        lastChat.hasError = true;
        chat.first = lastChat;
      }
      toScroll;
      scrollList;
    }
  }

  clickButton(ButtonsModel data) async {
    chat.insert(0, ChatModel(
        createdOn: DateTime.now(),
        type: 'text',
        val: data.label,
        fromMe: true));
    isTyping.value = true;
    final message =
        await _repository.sendMessage(type: 'text', value: data.action!);
    isTyping.value = false;

    if (message.isNotEmpty) {
      for (var item in message) {
        chat.insert(0, item);
        if (item.buttons != null && item.buttons!.isNotEmpty) {
          buttons.addAll(item.buttons!);
        }
      }
    } else {
      chat.first = ChatModel(
          createdOn: DateTime.now(),
          type: 'text',
          val: data.label,
          hasError: true,
          fromMe: true);
    }
    toScroll;
    scrollList;
  }

  void _scrolling() {
    Future.delayed(const Duration(milliseconds: 100), () {
      scroll.animateTo(scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
    });
  }

  void get toScroll => _scrolling();

  void _toScroll() {
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollOfList.jumpTo(scrollOfList.position.minScrollExtent);
    });
  }

  void get scrollList => _toScroll();

  int get lengthList => chat.value.length;
}
