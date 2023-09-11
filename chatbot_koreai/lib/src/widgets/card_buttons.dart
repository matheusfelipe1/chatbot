import 'package:flutter/material.dart';

import '../model/button_model.dart';

class CardButtons extends StatefulWidget {
  ButtonsModel button;
  Color? colorBackgroundButtonCards;
  Color? colorTextButtonCards;
  CardButtons({super.key, required this.button, this.colorBackgroundButtonCards, this.colorTextButtonCards});

  @override
  State<CardButtons> createState() => _CardButtonsState();
}

class _CardButtonsState extends State<CardButtons> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: widget.colorBackgroundButtonCards ?? Colors.white,
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width * .34),
        child: Padding(padding: EdgeInsets.all(size.width * .03),
        child: Center(child: Text(widget.button.label ?? '',
                  style: TextStyle(
                      color: widget.colorTextButtonCards ?? Colors.black))),),
      ),
    );
  }
}