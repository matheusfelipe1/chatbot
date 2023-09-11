import 'package:chatbot_koreai/src/model/chat_model.dart';
import 'package:chatbot_koreai/src/shared/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardRobotFiles extends StatelessWidget {
  Color? colorTextRobotMessage;
  Color? colorRobotCard;
  Color? colorRobotIcon;
  IconData? iconRobot;
  ChatModel? chat;
  bool hasIcon;
  CardRobotFiles(
      {super.key,
      this.colorRobotCard,
      this.colorRobotIcon,
      this.chat,
      this.colorTextRobotMessage,
      required this.hasIcon,
      this.iconRobot});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(right: size.width * .01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasIcon)
          Container(
            margin: EdgeInsets.only(top: size.width * .031, right: size.width * .02),
            child: SizedBox(
              height: 45,
              width: 45,
              child: Material(
                color: colorRobotIcon ??
                    const Color.fromARGB(255, 130, 127, 234),
                elevation: 5,
                borderRadius: BorderRadius.circular(size.width * .1),
                child: Icon(
                  iconRobot ?? FontAwesomeIcons.robot,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
      constraints: BoxConstraints(maxWidth: size.width * .6),
            child: Card(
                color: colorRobotCard ?? Colors.white,
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(size.width * .045),
                  topLeft: Radius.circular(size.width * .045),
                  topRight: Radius.circular(size.width * .045))),
                elevation: 5,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(size.width * .02),
                      child: Column(
                        children: [
                          Container(
                            height: size.width * .09,
                            width: size.width * .6,
                            decoration: BoxDecoration(
                                color: (colorTextRobotMessage ?? Colors.black)
                                    .withOpacity(.26),
                                borderRadius: BorderRadius.circular(9)),
                            child: Padding(
                              padding: EdgeInsets.all(size.width * .01),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.paperclip,
                                    color: colorTextRobotMessage ?? Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.width * .02,
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: size.width * .5),
                            child: Text(
                              chat?.val?.split('/').last ?? '',
                              softWrap: true,
                              style:
                                  TextStyle(color: colorTextRobotMessage ?? Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * .04, vertical: size.width * .025),
                              child: Text(
                                chat?.createdOn?.formattTime() ?? '',
                                style: TextStyle(color: colorTextRobotMessage ?? Colors.grey),
                              ),
                            ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
