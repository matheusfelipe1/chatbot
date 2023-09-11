import 'dart:async';
import 'dart:convert';

import 'package:chatbot_koreai/src/shared/dictionary.dart';
import 'package:chatbot_koreai/src/viewModel/chatbot_controller.dart';
import 'package:chatbot_koreai/src/widgets/card_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/chat_model.dart';
import '../widgets/card_my_file.dart';
import '../widgets/card_my_images.dart';
import '../widgets/card_my_message.dart';
import '../widgets/card_robot_file.dart';
import '../widgets/card_robot_image.dart';
import '../widgets/card_robot_message.dart';

class ChatBot extends StatelessWidget {
  final Color? backgroundBottom;
  final Color? colorIconSend;
  final Color? backgroundContent;
  final Color? backgroundAppbar;
  final String? textAppBar;
  final bool? centerTitle;
  final String? hintText;
  final IconData? iconAppBarClose;
  final Color? iconAppBarCloseColor;
  final Color? textAppBarColor;
  final Color? textTypingAppBarColor;
  final Color? colorStatusBar;
  final String? pathImageAppBar;
  final bool? hasImageAppBar;
  final Color? colorBackgroundButtonCards;
  final Color? colorTextButtonCards;
  // card robot
  final Color? colorTextRobotMessage;
  final Color? colorRobotCard;
  final Color? colorRobotIcon;
  final IconData? iconRobot;
  final bool hasIcon;
  // my card
  final Color? colorTextMyMessage;
  final Color? colorMyCard;
  // keys
  final String botId;
  final String userId;
  final String clientId;
  final String clientSecret;
  final String assertion;
  final String chatBot;
  final Map? userInfo;
  final int? limit;
  final String? labelSuggestion;
  final IconData? iconSuggestion;
  final int? limitSwitchTypeButtons;
  final Color? dateColorMessagesList;
  final String? textTyping;
  ChatBot(
      {super.key,
      this.backgroundBottom,
      this.colorIconSend,
      this.backgroundContent,
      this.backgroundAppbar,
      this.textTyping,
      this.textAppBar,
      this.iconAppBarClose,
      this.hintText,
      this.colorRobotCard,
      this.colorRobotIcon,
      this.colorTextRobotMessage,
      this.iconRobot,
      this.colorTextMyMessage,
      this.colorMyCard,
      this.textAppBarColor,
      this.iconAppBarCloseColor,
      this.textTypingAppBarColor,
      required this.botId,
      required this.clientId,
      required this.hasIcon,
      required this.clientSecret,
      required this.userId,
      this.pathImageAppBar,
      this.colorStatusBar,
      this.hasImageAppBar,
      this.colorBackgroundButtonCards,
      this.colorTextButtonCards,
      this.centerTitle,
      required this.assertion,
      required this.chatBot,
      this.userInfo,
      this.limit,
      this.labelSuggestion,
      this.iconSuggestion,
      this.limitSwitchTypeButtons,
      this.dateColorMessagesList});

  final ChatBotController _controller = Get.find<ChatBotController>();

  // @override
  // void initState() {
  //   super.initState();
  //   _init();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     final size = MediaQuery.of(context).size;
  //     _controller.heightListView.value = size.width * 1.59;

  //     _listenButtons();
  //   });
  // }

  // @override
  // void dispose() {
  //   _focus.dispose();
  //   _controller.buttons.close();
  //   _text.clear();
  //   _text.dispose();
  //   // _stream.cancel();
  //   _controller.chat.clear();
  //   _controller.chat.close();
  //   _controller.gettingMessages.close();
  //   _controller.isTyping.close();
  //   _controller.heightListView.close();
  //   _controller.scroll.dispose();
  //   scrollOfList.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    _controller.size = MediaQuery.of(context).size;
    return KeyboardVisibilityBuilder(
      builder: (context, isVisible) {
        if (!isVisible) {
          _controller.positionButton = 0.065;
        } else {
          _controller.positionButton = 0.001;
        }
        return Scaffold(
          backgroundColor:
              backgroundContent ?? const Color.fromARGB(255, 236, 236, 236),
          appBar: AppBar(
            systemOverlayStyle: colorStatusBar == null
                ? null
                : SystemUiOverlayStyle(statusBarColor: colorStatusBar),
            centerTitle: centerTitle ?? false,
            backgroundColor: backgroundAppbar ?? Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !(hasImageAppBar != null && hasImageAppBar == true)
                    ? Text(
                        textAppBar ?? 'KoreAI',
                        style: TextStyle(color: textAppBarColor ?? Colors.black),
                      )
                    : Image.asset(
                        pathImageAppBar!,
                        width: _controller.size.width * .2,
                      ),
                Obx(
                  () => _controller.isTyping.value
                      ? Container(
                          margin: EdgeInsets.only(
                              top: _controller.size.width * .01,
                              left: _controller.size.width * .04),
                          child: Text(
                            textTyping ?? 'digitando...',
                            style: TextStyle(
                                color: textTypingAppBarColor ?? Colors.grey,
                                fontStyle: FontStyle.italic,
                                fontSize: 13),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  iconAppBarClose ?? FontAwesomeIcons.xmark,
                  color: iconAppBarCloseColor ?? Colors.black,
                )),
          ),
          body: LayoutBuilder(
            builder: (context, length) => GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: SingleChildScrollView(
                controller: _controller.scroll,
                physics: const NeverScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(_controller.size.width * .027),
                      child: SizedBox(
                          height: length.maxHeight,
                          child: ListViewCustom(
                              controller: _controller,
                              size: length,
                              key: UniqueKey(),
                              widget: this)
                          // ListView.builder(
                          //     physics: BouncingScrollPhysics(),
                          //     controller: _controller.scrollOfList,
                          //     itemCount: _controller.chat.length,
                          //     itemBuilder: (context, i) {
                          //       final data = _controller.chat[i];
                          //       bool showDate = false;
                          //       if (i < _controller.chat.length &&
                          //           (i - 1) >= 0) {
                          //         final before = _controller.chat[i - 1];
                          //         if ((before.createdOn?.formattDate() !=
                          //             data.createdOn?.formattDate())) {
                          //           showDate = true;
                          //         }
                          //       }
                          //       return Column(
                          //         children: [
                          //           if (showDate || i == 0)
                          //             Container(
                          //                 margin: EdgeInsets.symmetric(
                          //                     vertical: size.width * .02),
                          //                 child: Text(
                          //                   showTodayYesterdayOrAnother(
                          //                           data.createdOn) ??
                          //                       '',
                          //                   style: TextStyle(
                          //                       color: widget
                          //                               .dateColorMessagesList ??
                          //                           Colors.black),
                          //                 )),
                          //           buildMyOrAnotherMessages(data),
                          //           if (i == _controller.chat.length - 1)
                          //             Container(
                          //               margin: EdgeInsets.only(
                          //                   bottom:
                          //                       length.maxHeight * .158),
                          //             )
                          //         ],
                          //       );
                          //     }),

                          ),
                    ),
                    Obx(() {return Positioned(
                      bottom: -(length.maxWidth * _controller.positionButton),
                      child: !_controller.buttonsInFloat.value
                          ? Container(
                              width: length.maxWidth,
                              margin:
                                  EdgeInsets.only(bottom: length.maxHeight * .15),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: _controller.buttons
                                      .map((element) => InkWell(
                                            onTap: () async {
                                              switch (element.type) {
                                                case 0:
                                                  _controller.clickButton(element);
                                                  _controller.buttons.clear();
                                                  break;
                                                case 2:
                                                  Navigator.of(context).pop(
                                                      jsonEncode(element.action));
                                                  break;
                                                default:
                                              }
                                              _controller.verifyHeight;
                                              _controller.scrollList;
                                            },
                                            child: CardButtons(
                                              button: element,
                                              colorBackgroundButtonCards:
                                                  colorBackgroundButtonCards,
                                              colorTextButtonCards:
                                                  colorTextButtonCards,
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    );}),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: length.maxWidth,
                        color: backgroundBottom ?? Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: _controller.size.width * .028,
                              horizontal: _controller.size.width * .02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxHeight: _controller.size.width * .2),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 220, 220, 220),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: _controller.size.width * .004,
                                      horizontal: _controller.size.width * .04),
                                  child: SizedBox(
                                      width: _controller.size.width * .6,
                                      child: TextFormField(
                                        controller: _controller.text,
                                        focusNode: _controller.focus,
                                        // onTap: () async {
                                        //   _controller.positionButton = 0.001;
                                        //   // await Future.delayed(
                                        //   //     const Duration(milliseconds: 1000));
                                        //   // _controller.scrollList;
                                        //   // _controller.toScroll;
                                        // },
                                        maxLines: 5,
                                        minLines: 1,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText:
                                                hintText ?? 'Send your message..',
                                            border: InputBorder.none),
                                      )),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await showModalBottomSheet(
                                        backgroundColor:
                                            backgroundBottom ?? Colors.white,
                                        elevation: 6,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        )),
                                        constraints: BoxConstraints(
                                            maxHeight: _controller.size.width * .3),
                                        context: context,
                                        builder: (context) => Center(
                                                child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        Navigator.of(context).pop();
                                                        FocusScope.of(context).unfocus();
                                                        _controller.getImage(
                                                            ImageSource.camera);
                                                        await Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    1000));
                                                        _controller.scrollList;
                                                        _controller.toScroll;
                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons.camera,
                                                        size:
                                                            _controller.size.width *
                                                                .085,
                                                        color: colorIconSend ??
                                                            const Color.fromARGB(
                                                                255, 130, 127, 234),
                                                      )),
                                                  SizedBox(
                                                    width: _controller.size.width *
                                                        .15,
                                                  ),
                                                  IconButton(
                                                      onPressed: () async {
                                                        Navigator.of(context).pop();
                                                        FocusScope.of(context).unfocus();
                                                        _controller.getImage(
                                                            ImageSource.gallery);
                                                        await Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    1000));
                                                        _controller.scrollList;
                                                        _controller.toScroll;
                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons.image,
                                                        size:
                                                            _controller.size.width *
                                                                .085,
                                                        color: colorIconSend ??
                                                            const Color.fromARGB(
                                                                255, 130, 127, 234),
                                                      )),
                                                  SizedBox(
                                                    width: _controller.size.width *
                                                        .15,
                                                  ),
                                                  IconButton(
                                                      onPressed: () async {
                                                        Navigator.of(context).pop();
                                                        FocusScope.of(context).unfocus();
                                                        await _controller
                                                            .getAnyFile();
                                                        await Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    1000));
                                                        _controller.scrollList;
                                                        _controller.toScroll;
                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons.file,
                                                        size:
                                                            _controller.size.width *
                                                                .085,
                                                        color: colorIconSend ??
                                                            const Color.fromARGB(
                                                                255, 130, 127, 234),
                                                      )),
                                                ],
                                              ),
                                            )));
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.paperclip,
                                    color: colorIconSend ??
                                        const Color.fromARGB(255, 130, 127, 234),
                                  )),
                              IconButton(
                                  onPressed: () {
                                    if (_controller.text.text.trim().isNotEmpty) {
                                      _controller.sendMessage(
                                          'text', _controller.text.text.trim());
                                      _controller.text.clear();
                                      _controller.scrollList;
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: colorIconSend ??
                                        const Color.fromARGB(255, 130, 127, 234),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Obx(() {
            bool show() => _controller.buttonsInFloat.value;
            return Visibility(
              visible: show() &&
                  _controller.buttons.isNotEmpty,
              child: Container(
                margin: EdgeInsets.only(bottom: _controller.size.width * .18),
                child: FloatingActionButton.extended(
                  label: Text(
                    labelSuggestion ?? 'Opções',
                    style: const TextStyle(letterSpacing: 0.4),
                  ),
                  backgroundColor:
                      colorIconSend ?? const Color.fromARGB(255, 130, 127, 234),
                  onPressed: () {
                    showCupertinoModalPopup(
                        // shape: const RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.only(
                        //   topLeft: Radius.circular(15),
                        //   topRight: Radius.circular(15),
                        // )),
                        // constraints: BoxConstraints(maxHeight: _controller.size.width * .45),
                        context: context,
                        // elevation: 6,
                        useRootNavigator: true,
                        builder: (context) => GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Material(
                                color: Colors.black.withOpacity(.8),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: _controller.size.width * .35),
                                  child: SizedBox(
                                    width: _controller.size.width,
                                    height: _controller.size.height,
                                    child: ListView.builder(
                                        itemCount: _controller.buttons.length,
                                        reverse: true,
                                        itemBuilder: (context, i) {
                                          final element = _controller.buttons[i];
                                          return InkWell(
                                            onTap: () async {
                                              switch (element.type) {
                                                case 0:
                                                  _controller.clickButton(element);
                                                  _controller.buttons.clear();
                                                  break;
                                                case 2:
                                                  Navigator.of(context).pop(
                                                      jsonEncode(element.action));
                                                  break;
                                                default:
                                              }
                                              _controller.verifyHeight;

                                              _controller.scrollList;
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: CardButtons(
                                                button: element,
                                                colorBackgroundButtonCards:
                                                    colorBackgroundButtonCards,
                                                colorTextButtonCards:
                                                    colorTextButtonCards,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            ));
                  },
                  icon: Icon(
                    iconSuggestion ?? FontAwesomeIcons.bars,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
          // bottomSheet: Container(
          //   color: backgroundBottom ?? Colors.white,
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(
          //         vertical: size.width * .028, horizontal: size.width * .02),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Container(
          //           constraints: BoxConstraints(maxHeight: size.width * .2),
          //           decoration: BoxDecoration(
          //               color: const Color.fromARGB(255, 220, 220, 220),
          //               borderRadius: BorderRadius.circular(25)),
          //           child: Padding(
          //             padding: EdgeInsets.symmetric(
          //                 vertical: size.width * .004,
          //                 horizontal: size.width * .04),
          //             child: SizedBox(
          //                 width: size.width * .6,
          //                 child: TextFormField(
          //                   controller: _text,
          //                   focusNode: _focus,
          //                   onTap: () async {
          //                     _controller.positionButton = 0.001;
          //                     await Future.delayed(
          //                         const Duration(milliseconds: 1000));
          //                     _controller.scrollList;
          //                     _controller.toScroll;
          //                   },
          //                   maxLines: 5,
          //                   minLines: 1,
          //                   keyboardType: TextInputType.text,
          //                   decoration: InputDecoration(
          //                       hintText: hintText ?? 'Send your message..',
          //                       border: InputBorder.none),
          //                 )),
          //           ),
          //         ),
          //         IconButton(
          //             onPressed: () async {
          //               await showModalBottomSheet(
          //                   backgroundColor:
          //                       backgroundBottom ?? Colors.white,
          //                   elevation: 6,
          //                   shape: const RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(15),
          //                     topRight: Radius.circular(15),
          //                   )),
          //                   constraints: BoxConstraints(maxHeight: size.width * .3),
          //                   context: context,
          //                   builder: (context) => Center(
          //                           child: Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: Row(
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             IconButton(
          //                                 onPressed: () async {
          //                                   Navigator.of(context).pop();
          //                                   _controller
          //                                       .getImage(ImageSource.camera);
          //                                   await Future.delayed(
          //                                       const Duration(milliseconds: 1000));
          //                                   _controller.scrollList;
          //                                   _controller.toScroll;
          //                                 },
          //                                 icon: Icon(
          //                                   FontAwesomeIcons.camera,
          //                                   size: size.width * .085,
          //                                   color: colorIconSend ??
          //                                       const Color.fromARGB(
          //                                           255, 130, 127, 234),
          //                                 )),
          //                             SizedBox(
          //                               width: size.width * .15,
          //                             ),
          //                             IconButton(
          //                                 onPressed: () async {
          //                                   Navigator.of(context).pop();
          //                                   _controller
          //                                       .getImage(ImageSource.gallery);
          //                                   await Future.delayed(
          //                                       const Duration(milliseconds: 1000));
          //                                   _controller.scrollList;
          //                                   _controller.toScroll;
          //                                 },
          //                                 icon: Icon(
          //                                   FontAwesomeIcons.image,
          //                                   size: size.width * .085,
          //                                   color: colorIconSend ??
          //                                       const Color.fromARGB(
          //                                           255, 130, 127, 234),
          //                                 )),
          //                             SizedBox(
          //                               width: size.width * .15,
          //                             ),
          //                             IconButton(
          //                                 onPressed: () async {
          //                                   Navigator.of(context).pop();
          //                                   await _controller.getAnyFile();
          //                                   await Future.delayed(
          //                                       const Duration(milliseconds: 1000));
          //                                   _controller.scrollList;
          //                                   _controller.toScroll;
          //                                 },
          //                                 icon: Icon(
          //                                   FontAwesomeIcons.file,
          //                                   size: size.width * .085,
          //                                   color: colorIconSend ??
          //                                       const Color.fromARGB(
          //                                           255, 130, 127, 234),
          //                                 )),
          //                           ],
          //                         ),
          //                       )));
          //             },
          //             icon: Icon(
          //               FontAwesomeIcons.paperclip,
          //               color: colorIconSend ??
          //                   const Color.fromARGB(255, 130, 127, 234),
          //             )),
          //         IconButton(
          //             onPressed: () {
          //               if (_text.text.trim().isNotEmpty) {
          //                 _controller.sendMessage('text', _text.text.trim());
          //                 _text.clear();
          //                 _controller.scrollList;
          //               }
          //             },
          //             icon: Icon(
          //               Icons.send,
          //               color: colorIconSend ??
          //                   const Color.fromARGB(255, 130, 127, 234),
          //             ))
          //       ],
          //     ),
          //   ),
          // ),
        );
      }
    );
  }

  Widget buildMyCarts(ChatModel data) {
    switch (data.type) {
      case 'text':
        return CardMyMessage(
          colorMyCard: colorMyCard,
          colorTextMyMessage: colorTextMyMessage,
          chat: data,
        );
      case 'image':
        return CardMyImages(
          colorMyCard: colorMyCard,
          colorTextMyMessage: colorTextMyMessage,
          chat: data,
          imLast: (_controller.chat.length - 1) ==
              (_controller.chat
                  .indexWhere((element) => element.val == data.val)),
        );
      default:
        return CardMyFiles(
          colorMyCard: colorMyCard,
          colorTextMyMessage: colorTextMyMessage,
          chat: data,
        );
    }
  }

  Widget buildRobotCarts(ChatModel data) {
    switch (data.type) {
      case 'text':
        return data.isImage != null && data.isImage! == true
            ? CardRobotImages(
                hasIcon: hasIcon,
                colorRobotCard: colorRobotCard,
                colorRobotIcon: colorRobotIcon,
                colorTextRobotMessage: colorTextRobotMessage,
                iconRobot: iconRobot,
                chat: data,
              )
            : CardRobotMessage(
                hasIcon: hasIcon,
                colorRobotCard: colorRobotCard,
                colorRobotIcon: colorRobotIcon,
                colorTextRobotMessage: colorTextRobotMessage,
                iconRobot: iconRobot,
                chat: data,
              );
      case 'image':
        return CardRobotImages(
          hasIcon: hasIcon,
          colorRobotCard: colorRobotCard,
          colorRobotIcon: colorRobotIcon,
          colorTextRobotMessage: colorTextRobotMessage,
          iconRobot: iconRobot,
          chat: data,
        );
      default:
        return CardRobotFiles(
          hasIcon: hasIcon,
          colorRobotCard: colorRobotCard,
          colorRobotIcon: colorRobotIcon,
          colorTextRobotMessage: colorTextRobotMessage,
          iconRobot: iconRobot,
          chat: data,
        );
    }
  }

  Widget buildMyOrAnotherMessages(ChatModel data) {
    switch (data.fromMe) {
      case true:
        return Container(
            alignment: Alignment.centerRight, child: buildMyCarts(data));
      default:
        return Container(
            alignment: Alignment.centerLeft, child: buildRobotCarts(data));
    }
  }

  _init() async {
    await _controller.getHistoryMessages();
    if (_controller.chat.isEmpty || _verifyAlreadyHasMessageToday()) {
      _controller.chat.add(ChatModel(
          messageId: 'initMessage',
          createdOn: DateTime.now(),
          type: 'text',
          fromMe: false,
          val: 'Olá, como podemos te ajudar?'));
      await Future.delayed(const Duration(milliseconds: 1000));
      _controller.scroll;
      _controller.scrollList;
    }
  }

  bool _verifyAlreadyHasMessageToday() {
    if (_controller.chat.isEmpty) return true;
    return !(_controller.chat
        .any((element) => (element.createdOn!.day == DateTime.now().day)));
  }

  String? showTodayYesterdayOrAnother(DateTime? date) {
    if (date == null) return null;
    try {
      final datetoday = DateTime.now();
      final datetodayString = datetoday.toIso8601String().split('T').first;
      final dateParamsString = date.toIso8601String().split('T').first;
      final newDateToday = DateTime.parse(datetodayString);
      final newDateParams = DateTime.parse(dateParamsString);
      if ((newDateToday.difference(newDateParams).inDays) == 0) {
        return 'Hoje';
      } else if ((newDateToday.difference(newDateParams).inDays) == 1) {
        return 'Ontem';
      } else {
        return date.formattDate();
      }
    } catch (e) {
      debugPrint(e.toString());
      return date.formattDate();
    }
  }

  // _listenButtons() {
  //   _controller.buttons.listen((p0) {
  //     _controller.positionButton = 0.065;
  //     _verifyHowShowButtons();
  //   });
  // }

  // _verifyHowShowButtons() {
  //   // if (mounted) {
  //   //   setState(() {
  //   //     verifyHeight;
  //   //   });
  //   // }
  // }

  // void get verifyHeight => {
  //       if (limitSwitchTypeButtons != null)
  //         {
  //           if (_controller.buttons.length <= limitSwitchTypeButtons!)
  //             {
  //               _controller.buttonsInFloat = false,
  //               FocusManager.instance.primaryFocus?.unfocus(),
  //               _controller.heightListView.value =
  //                   _controller.size.width * 1.59,
  //             }
  //           else
  //             {
  //               _controller.buttonsInFloat = true,
  //               _controller.heightListView.value =
  //                   _controller.size.width * 1.59,
  //             }
  //         }
  //       else
  //         {
  //           if (_controller.buttons.length <= 3)
  //             {
  //               _controller.buttonsInFloat = false,
  //               FocusManager.instance.primaryFocus?.unfocus(),
  //               _controller.heightListView.value = _controller.size.width * .95,
  //             }
  //           else
  //             {
  //               _controller.buttonsInFloat = true,
  //               _controller.heightListView.value = _controller.size.width * .95
  //             }
  //         }
  //     };
}

String? showTodayYesterdayOrAnother(DateTime? date) {
  if (date == null) return null;
  try {
    final datetoday = DateTime.now();
    final datetodayString = datetoday.toIso8601String().split('T').first;
    final dateParamsString = date.toIso8601String().split('T').first;
    final newDateToday = DateTime.parse(datetodayString);
    final newDateParams = DateTime.parse(dateParamsString);
    if ((newDateToday.difference(newDateParams).inDays) == 0) {
      return 'Hoje';
    } else if ((newDateToday.difference(newDateParams).inDays) == 1) {
      return 'Ontem';
    } else {
      return date.formattDate();
    }
  } catch (e) {
    debugPrint(e.toString());
    return date.formattDate();
  }
}

class BuildMyOrAnotherMessages extends StatelessWidget {
  final ChatModel data;
  final ChatBot widget;
  final ChatBotController controller;
  const BuildMyOrAnotherMessages({
    super.key,
    required this.data,
    required this.widget,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return data.fromMe ?? false
        ? Container(
            key: UniqueKey(),
            alignment: Alignment.centerRight,
            child: BuildMyCarts(
                data: data, widget: widget, controller: controller))
        : Container(
            key: UniqueKey(),
            alignment: Alignment.centerLeft,
            child: buildRobotCarts(data, widget));
  }
}

class BuildMyCarts extends StatelessWidget {
  final ChatModel data;
  final ChatBot widget;
  final ChatBotController controller;

  const BuildMyCarts({
    super.key,
    required this.data,
    required this.widget,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    switch (data.type) {
      case 'text':
        return CardMyMessage(
          colorMyCard: widget.colorMyCard,
          colorTextMyMessage: widget.colorTextMyMessage,
          chat: data,
        );
      case 'image':
        return CardMyImages(
          colorMyCard: widget.colorMyCard,
          colorTextMyMessage: widget.colorTextMyMessage,
          chat: data,
          imLast: (controller.chat.length - 1) ==
              (controller.chat
                  .indexWhere((element) => element.val == data.val)),
        );
      default:
        return CardMyFiles(
          colorMyCard: widget.colorMyCard,
          colorTextMyMessage: widget.colorTextMyMessage,
          chat: data,
        );
    }
  }
}

Widget buildRobotCarts(ChatModel data, ChatBot widget) {
  switch (data.type) {
    case 'image':
      return CardRobotImages(
        hasIcon: widget.hasIcon,
        colorRobotCard: widget.colorRobotCard,
        colorRobotIcon: widget.colorRobotIcon,
        colorTextRobotMessage: widget.colorTextRobotMessage,
        iconRobot: widget.iconRobot,
        chat: data,
      );
    case "file":
      return CardRobotFiles(
        hasIcon: widget.hasIcon,
        colorRobotCard: widget.colorRobotCard,
        colorRobotIcon: widget.colorRobotIcon,
        colorTextRobotMessage: widget.colorTextRobotMessage,
        iconRobot: widget.iconRobot,
        chat: data,
      );
    default:
      return data.isImage != null && data.isImage! == true
          ? CardRobotImages(
              hasIcon: widget.hasIcon,
              colorRobotCard: widget.colorRobotCard,
              colorRobotIcon: widget.colorRobotIcon,
              colorTextRobotMessage: widget.colorTextRobotMessage,
              iconRobot: widget.iconRobot,
              chat: data,
            )
          : CardRobotMessage(
              hasIcon: widget.hasIcon,
              colorRobotCard: widget.colorRobotCard,
              colorRobotIcon: widget.colorRobotIcon,
              colorTextRobotMessage: widget.colorTextRobotMessage,
              iconRobot: widget.iconRobot,
              chat: data,
            );
  }
}

class ListViewCustom extends StatelessWidget {
  final ChatBotController controller;
  final BoxConstraints size;
  final ChatBot widget;
  const ListViewCustom(
      {super.key,
      required this.controller,
      required this.size,
      required this.widget});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.gettingMessages.value
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    widget.colorIconSend ??
                        const Color.fromARGB(255, 130, 127, 234)),
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: scrollOfList,
              key: UniqueKey(),
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              restorationId: "root",
              cacheExtent: 2000,
              reverse: true,
              addSemanticIndexes: true,
              semanticChildCount: controller.lengthList,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              shrinkWrap: true,
              itemCount: controller.lengthList,
              itemBuilder: (context, i) {
                final data = controller.chat[i];
                return Column(
                  children: [
                    if (showDateTime(data, i, controller) ||
                        (i == (controller.lengthList - 1)))
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: size.maxWidth * .06),
                          child: Text(
                            showTodayYesterdayOrAnother(data.createdOn) ?? '',
                            style: TextStyle(
                                color: widget.dateColorMessagesList ??
                                    Colors.black),
                          )),
                    BuildMyOrAnotherMessages(
                        data: data, widget: widget, controller: controller),
                    if (i == 0)
                      SizedBox(
                        height: size.maxHeight * .158,
                      )
                  ],
                );
              });
    });
  }
}

final ScrollController scrollOfList = ScrollController();

bool showDateTime(ChatModel data, int i, ChatBotController controller) {
  bool showDate = false;

  if (i < controller.chat.length && (i + 1) >= 0) {
    final iterator =
        controller.chat.getRange(i, controller.chat.length - 1).iterator;
    if (iterator.moveNext()) {
      final index = controller.chat.indexOf(iterator.current);
      final next = controller.chat[index + 1];
      if ((next.createdOn?.formattDate() != data.createdOn?.formattDate())) {
        showDate = true;
      }
    }
    // if (controller.chat.iterator.moveNext()) {
    //   final before = controller.chat[i + 1];
    //   if ((before.createdOn?.formattDate() != data.createdOn?.formattDate())) {
    //     showDate = true;
    //   }
    // }
  }
  return showDate;
}
