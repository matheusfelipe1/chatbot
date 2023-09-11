import 'dart:convert';

import 'button_model.dart';

class ChatModel {
  String? messageId;
  DateTime? createdOn;
  String? val;
  String? type;
  bool? fromMe;
  // if has button
  List<ButtonsModel>? buttons;
  // if has image
  bool? isImage;
  String? linkImage;
  String? textInImage;
  bool? hasError;
  ChatModel({
    this.createdOn,
    this.messageId,
    this.type,
    this.val,
    this.fromMe,
    this.buttons,
    this.isImage,
    this.linkImage,
    this.hasError,
    this.textInImage,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    bool isImage = isImageUrl(json['val']);
    messageId = json["messageId"];
    val = generatingButtons(json['val']);
    createdOn = DateTime.parse(json["createdOn"]);
    type = json['type'] != 'image' && !isImage ? json['type'] : 'text';
    fromMe = json['fromMe'];
    isImage = isImage;
  }

  String generatingButtons(dynamic val) {
    if (val is String) {
      val = val;
      if (val.contains("* ")) {
        val = val.replaceAll("*", "**");
        val = val.replaceAll("**", "*").replaceAll("******", "***").replaceAll("****", "**");
        final List<String> vals = val.split("\n");
        final values = <String>[];
        for (var item in vals) {
          var text = item;
          if (item.startsWith("* ")) {
            text = item.replaceRange(0, 2, "\t• ");
          }
          values.add(text);
        }
        if (values.isNotEmpty) val = values.join("\n");
      } else if (val.contains("- ")) {
        final List<String> vals = val.split("\n");
        final values = <String>[];
        for (var item in vals) {
          var text = item;
          if (item.startsWith("- ")) {
            text = item.replaceRange(0, 2, "\t• ");
          }
          values.add(text);
        }
        if (values.isNotEmpty) val = values.join("\n");
      }
    }
    if (val is Map) {
      val = val['text'].replaceAll('&quot;', '"');
      if (val.contains("* ")) {
        val = val.replaceAll("*", "**");
        val = val.replaceAll("**", "*").replaceAll("******", "***").replaceAll("****", "**");
        final List<String> vals = val.split("\n");
        final values = <String>[];
        for (var item in vals) {
          var text = item;
          if (item.startsWith("* ")) {
            text = item.replaceRange(0, 2, "\t• ");
          } else if (item.startsWith("- ")) {
            text = item.replaceRange(0, 2, "\t• ");
          }
          values.add(text);
        }
        if (values.isNotEmpty) val = values.join("\n");
      } else if (val.contains("- ")) {
        final List<String> vals = val.split("\n");
        final values = <String>[];
        for (var item in vals) {
          var text = item;
          if (item.startsWith("- ")) {
            text = item.replaceRange(0, 2, "\t• ");
          } else if (item.startsWith("- ")) {
            text = item.replaceRange(0, 2, "\t• ");
          }
          values.add(text);
        }
        if (values.isNotEmpty) val = values.join("\n");
      }
    }
    List<String> buttonInVal = [];
    if (val.toLowerCase().contains('a)')) {
      val = val.replaceAll('&quot;', '"');
      final newVal = val.split('a)').last;
      final listOptions = newVal.split('\n');
      buttons ??= [];
      for (var i = 0; i < listOptions.length; i++) {
        final element = listOptions[i];
        if (element.isNotEmpty) {
          if (i == 0) {
            buttonInVal.add('a) $element');
          } else {
            buttonInVal.add(element);
          }
        }
      }
      for (var element in buttonInVal) {
        buttons!.add(ButtonsModel(
            action: element, type: 0, label: element.split(') ').last));
      }
      return val.split('a)').first;
    }
    if (val.toLowerCase().contains('template_type')) {
      val = val.replaceAll('&quot;', '"');
      final Map json = jsonDecode(val);
      final Map payload = json['payload'];
      if (payload['template_type'] == 'button') {
        val = payload['text'];
        final listButtons = payload['buttons'] as List;
        buttons ??= [];
        for (var element in listButtons) {
          buttons!.add(ButtonsModel(
              action: element["payload"], type: 0, label: element['title']));
        }
        return val;
      }
    }
    return val;
  }

  bool isImageUrl(dynamic val) {
    if (val is Map) return false;
    if (val.toLowerCase().contains('![') &&
        val.toLowerCase().contains(']') &&
        val.toLowerCase().contains('(') &&
        val.toLowerCase().contains(')')) {
      late int indexColchetesFechando;
      late int indexColchetesAbrindo;
      late int linkInArrayOpening;
      late int linkInArrayClosing;
      late String key;
      final dataVal = val.split('');
      dataVal.insert(0, " ");
      dataVal.add(" ");
      for (var i = 1; i < dataVal.length; i++) {
        final current = dataVal[i];
        final before = dataVal[i - 1];
        if (current == '[' && before == '!') {
          indexColchetesAbrindo = i;
        } else if (current == ']' && before != '!') {
          indexColchetesFechando = i;
        } else if (current == '(' && before == ']') {
          linkInArrayOpening = i;
        } else if (current == ')') {
          linkInArrayClosing = i;
        }
      }

      linkImage =
          dataVal.getRange(linkInArrayOpening + 1, linkInArrayClosing).join('');
      textInImage = val.replaceAll('![', '[');
      return true;
    }
    return false;
  }
}
