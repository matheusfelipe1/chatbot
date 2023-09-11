import 'package:chatbot_koreai/src/model/chat_model.dart';
import 'package:chatbot_koreai/src/shared/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardMyMessage extends StatefulWidget {
  Color? colorTextMyMessage;
  Color? colorMyCard;
  ChatModel? chat;
  CardMyMessage(
      {super.key, this.colorTextMyMessage, this.colorMyCard, this.chat});

  @override
  State<CardMyMessage> createState() => _CardMyMessageState();
}

class _CardMyMessageState extends State<CardMyMessage> {
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
                color: widget.colorMyCard ?? const Color.fromARGB(255, 150, 147, 241),
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
                      padding: EdgeInsets.all(size.width * .034),
                      child: Text(
                        widget.chat?.val ?? '',
                        style: TextStyle(
                            color: widget.colorTextMyMessage ?? Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .04, vertical: size.width * .025),
                      child: Text(
                        widget.chat?.createdOn?.formattTime() ?? '',
                        style: TextStyle(
                            color: (widget.colorTextMyMessage ?? Colors.black)
                                .withOpacity(.5)),
                      ),
                    )
                  ],
                )),
          ),
          if (widget.chat?.hasError != null && widget.chat?.hasError == true)
            const Icon(FontAwesomeIcons.xmark, color: Colors.red,)
        ],
      ),
    );
  }
}
