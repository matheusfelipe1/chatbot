import 'package:chatbot_koreai/src/shared/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/chat_model.dart';

class CardMyFiles extends StatelessWidget {
  Color? colorTextMyMessage;
  Color? colorMyCard;
  ChatModel? chat;
  CardMyFiles(
      {super.key, this.colorMyCard, this.colorTextMyMessage, this.chat});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(right: size.width * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(right: size.width * .01),
            constraints: BoxConstraints(maxWidth: size.width * .6),
            child: Card(
                color: colorMyCard ?? const Color.fromARGB(255, 150, 147, 241),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(size.width * .045),
                        topLeft: Radius.circular(size.width * .045),
                        topRight: Radius.circular(size.width * .045))),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(size.width * .02),
                      child: Column(
                        children: [
                          Container(
                            height: size.width * .09,
                            width: size.width * .5,
                            decoration: BoxDecoration(
                                color: (colorTextMyMessage ?? Colors.black)
                                    .withOpacity(.26),
                                borderRadius: BorderRadius.circular(9)),
                            child: Padding(
                              padding: EdgeInsets.all(size.width * .01),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.paperclip,
                                    color: colorTextMyMessage ?? Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.width * .02,
                          ),
                          Text(
                            chat?.val ?? '',
                            style: TextStyle(
                                color: colorTextMyMessage ?? Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .04,
                          vertical: size.width * .025),
                      child: Text(
                        chat?.createdOn?.formattTime() ?? '',
                        style: TextStyle(
                            color: (colorTextMyMessage ?? Colors.black)
                                .withOpacity(.5)),
                      ),
                    )
                  ],
                )),
          ),
          if (chat?.hasError != null && chat?.hasError == true)
            const Icon(
              FontAwesomeIcons.xmark,
              color: Colors.red,
            )
        ],
      ),
    );
  }
}
