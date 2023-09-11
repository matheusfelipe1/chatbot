import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RobotTyping extends StatefulWidget {
  Color? colorTextRobotMessage;
  Color? colorRobotCard;
  Color? colorRobotIcon;
  IconData? iconRobot;
  RobotTyping(
      {super.key,
      this.colorRobotCard,
      this.colorRobotIcon,
      this.colorTextRobotMessage,
      this.iconRobot});

  @override
  State<RobotTyping> createState() => _RobotTypingState();
}

class _RobotTypingState extends State<RobotTyping> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: size.width * .01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 45,
            width: 45,
            child: Material(
              color: widget.colorRobotIcon ??
                  const Color.fromARGB(255, 130, 127, 234),
              elevation: 5,
              borderRadius: BorderRadius.circular(size.width * .1),
              child: Icon(
                widget.iconRobot ?? FontAwesomeIcons.robot,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: size.width * .6),
            child: Card(
                color: widget.colorRobotCard ?? Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width * .065)),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(size.width * .034),
                  child: Text(
                    '...',
                    style: TextStyle(
                        color: widget.colorTextRobotMessage ?? Colors.black),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
