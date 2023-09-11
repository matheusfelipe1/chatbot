import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot_koreai/src/model/chat_model.dart';
import 'package:chatbot_koreai/src/shared/dictionary.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'card_webview.dart';

class CardRobotMessage extends StatefulWidget {
  final Color? colorTextRobotMessage;
  final Color? colorRobotCard;
  final Color? colorRobotIcon;
  final IconData? iconRobot;
  final ChatModel? chat;
  final bool hasIcon;
  const CardRobotMessage(
      {super.key,
      this.colorRobotCard,
      this.colorRobotIcon,
      this.colorTextRobotMessage,
      this.chat,
      required this.hasIcon,
      this.iconRobot});

  @override
  State<CardRobotMessage> createState() => _CardRobotMessageState();
}

class _CardRobotMessageState extends State<CardRobotMessage> {
  late String? key;
  late String? value;
  late final StreamController<String> path;

  @override
  void initState() {
    super.initState();
    path = StreamController<String>(
      sync: true,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    path.close();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: size.width * .01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.hasIcon)
            Container(
              margin: EdgeInsets.only(
                  top: size.width * .031, right: size.width * .02),
              child: SizedBox(
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
            ),
          Container(
            constraints: BoxConstraints(maxWidth: size.width * .6),
            child: Card(
                color: widget.colorRobotCard ?? Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(size.width * .045),
                        topLeft: Radius.circular(size.width * .045),
                        topRight: Radius.circular(size.width * .045))),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<String>(
                        stream: path.stream,
                        builder: (context, snapshot) {
                          final value = snapshot.data;

                          if (!snapshot.hasData) return const SizedBox();
                          if (value == null) return const SizedBox();
                          if (value == "") return const SizedBox();
                          return SizedBox(
                            width: size.width * .6,
                            height: size.width * .9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: CachedNetworkImage(
                                  cacheKey: value,
                                  imageUrl: value,
                                  repeat: ImageRepeat.repeat,
                                  key: UniqueKey(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        height: 300,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey,
                                          highlightColor: Colors.white,
                                          child: SizedBox(
                                            height: size.width * 1.2,
                                            width: size.width * .8,
                                          )),
                                  errorWidget: (context, url, error) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  }),
                            ),
                          );
                        }),
                    Padding(
                      padding: EdgeInsets.all(size.width * .034),
                      child: clickLink(widget.chat?.val ?? ''),
                      // Text(
                      //   widget.chat?.val ?? '',
                      //   style: TextStyle(
                      //       color:
                      //           widget.colorTextRobotMessage ?? Colors.black),
                      // ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .04,
                          vertical: size.width * .025),
                      child: Text(
                        widget.chat?.createdOn?.formattTime() ?? '',
                        style: TextStyle(
                            color: widget.colorTextRobotMessage ?? Colors.grey),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget clickLink(String val) {
    final List<TextSpan> datas = returnMarkDownText(val);
    final size = MediaQuery.of(context).size;
    if (datas.isNotEmpty) {
      return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          text: '',
          style: TextStyle(color: widget.colorTextRobotMessage ?? Colors.black),
          children: datas,
        ),
      );
    } else if (val.contains(RegExp(('<(.*)>(.*)</([^br][A-Za-z0-9]+)>'))) ||
        val.contains(
            RegExp(('(<head>([sS]*)</head>)|(<body>([sS]*)</body>)')))) {
      return SizedBox(
        width: size.width,
        height: size.width,
        child: ChatWebview(html: val),
      );
    } else {
      return Text(
        val,
        style: TextStyle(color: widget.colorTextRobotMessage ?? Colors.black),
      );
    }
  }

  // verifyIfIsLink(String val) {
  //   if (val.contains('[') || val.contains(']')) {
  //     final List<String> values = val.split('');
  //     final firstIndex = values.indexWhere((element) => element == '[');
  //     final secondIndex = values.indexWhere((element) => element == ']');
  //     key = values.getRange(firstIndex + 1, secondIndex).join('').toLowerCase();
  //     value = values.getRange(0, firstIndex).join('');
  //     path = values.getRange(secondIndex + 1, values.length).join('');
  //     if (path!.contains('(') && path!.contains(')')) {
  //       path = path!.replaceAll('(', '').replaceAll(')', '');
  //     }
  //     if (path!.contains('https://')) {
  //       path = path!.replaceAll('https://', '');
  //     }
  //     return true;
  //   }
  //   return false;
  // }

  List<TextSpan> returnMarkDownText(String val) {
    if (val.contains("![")) {
      final index1 = val.indexOf("![");
      if (index1 != -1) {
        final List<String> textImage = val.split("");
        final listNew = textImage.getRange(index1, textImage.length - 1);
        final element = listNew.firstWhere((element) => element == "]");
        final indexTextImage = List<String>.from(listNew).indexOf(element);
        final nextElement = listNew.toList()[indexTextImage + 1];
        if (nextElement == "(") {
          final element = listNew
              .toList()
              .getRange(indexTextImage + 1, listNew.length - 1)
              .toList()
              .firstWhere((element) => element == ")");
          final indexElement = listNew.toList().indexOf(element);
          final path = listNew
              .toList()
              .getRange(indexTextImage + 2, indexElement)
              .join("");
          textImage.removeRange(
              index1, indexElement + (textImage.length - listNew.length));
          val = textImage.join("");
          final valFinal = path.replaceAll("https://", '');
          this.path.add("https://$valFinal");
        }
      }
    }

    List<TextSpan> texts = [];
    String texto = val;
    List<int> indexColchetesAbrindo = [];
    List<int> indexColchetesFechando = [];
    List<int> indexPathLinkAbrindo = [];
    List<int> indexPathLinkFechando = [];
    List<int> indexNegritos = [];
    List<int> indexItalicos = [];
    List<int> indexItalicosENegritos = [];
    List<String> negritos = [];
    List<String> italicos = [];
    List<String> italicosENegritos = [];
    List<Map> links = [];
    if ((val.contains('[') ||
            val.contains(']') ||
            val.contains('(') ||
            val.contains(')') ||
            val.contains('**') ||
            val.contains('*') ||
            val.contains('__') ||
            val.contains('_')) &&
        !val.contains('template')) {
      final List<String> values = val.split('');
      values.add(' ');
      values.insert(0, ' ');
      for (var i = 1; i < values.length; i++) {
        final text = values[i];
        if (text == '[') {
          indexColchetesAbrindo.add(i);
        } else if (text == ']') {
          indexColchetesFechando.add(i);
        } else if (text == '*' &&
            values[i - 1] == '*' &&
            values[i + 1] != '*') {
          indexNegritos.add(i - 1);
        } else if (text == '_' &&
            values[i - 1] == '_' &&
            values[i + 1] != '_') {
          indexNegritos.add(i - 1);
        } else if (text == '*' &&
            values[i - 1] != '*' &&
            values[i + 1] != '*') {
          indexItalicos.add(i);
        } else if (text == '_' &&
            values[i - 1] != '_' &&
            values[i + 1] != '_') {
          indexItalicos.add(i);
        } else if (text == '(') {
          indexPathLinkAbrindo.add(i);
        } else if (text == ')') {
          indexPathLinkFechando.add(i);
        } else if (text == '_' &&
            values[i - 1] == '_' &&
            values[i + 1] == '_') {
          indexItalicosENegritos.add(i - 1);
        } else if (text == '*' &&
            values[i - 1] == '*' &&
            values[i + 1] == '*') {
          indexItalicosENegritos.add(i - 1);
        }
      }
      for (var i = 0; i < indexPathLinkAbrindo.length; i++) {
        final first = indexPathLinkAbrindo[i];
        final second = indexPathLinkFechando[i];
        indexItalicos
            .removeWhere((element) => first < element && second > element);
      }
      if (indexItalicosENegritos.isNotEmpty) {
        for (var i = 1; i < indexItalicosENegritos.length; i += 2) {
          final current = indexItalicosENegritos[i];
          final before = indexItalicosENegritos[i - 1];
          String italicoNegrito = values.getRange(before + 3, current).join('');
          if (italicoNegrito.contains(' ')) {
            final n = italicoNegrito.replaceAll(' ', '%s');
            texto = texto.replaceAll(italicoNegrito, n);
            italicoNegrito = italicoNegrito.replaceAll(' ', '%s');
          }

          if (texto.split('***$italicoNegrito***').isNotEmpty) {
            texto = texto
                .split('***$italicoNegrito***')
                .join(' %IN$italicoNegrito ');
          }
          if (texto.split('___${italicoNegrito}___').isNotEmpty) {
            texto = texto
                .split('___${italicoNegrito}___')
                .join(' %IN$italicoNegrito ');
          }
          italicosENegritos.add('%IN$italicoNegrito');
        }
      }
      if (indexNegritos.isNotEmpty) {
        indexNegritos.removeWhere((element) => indexItalicosENegritos.any(
            (element2) => (element == element2 ||
                element + 1 == element2 ||
                element - 1 == element2)));
        for (var i = 1; i < indexNegritos.length; i += 2) {
          String negrito = values
              .getRange(indexNegritos[i - 1] + 2, indexNegritos[i])
              .join('');
          if (negrito.contains(' ')) {
            final n = negrito.replaceAll(' ', '%s');
            texto = texto.replaceAll(negrito, n);
            negrito = negrito.replaceAll(' ', '%s');
          }
          if (texto.split('**$negrito**').isNotEmpty) {
            texto = texto.split('**$negrito**').join(' %N$negrito ');
          }
          if (texto.split('__${negrito}__').isNotEmpty) {
            texto = texto.split('__${negrito}__').join(' %N$negrito ');
          }
          negritos.add('%N$negrito');
        }
      }

      if (indexItalicos.isNotEmpty) {
        for (var i = 1; i < indexItalicos.length; i += 2) {
          String italico = values
              .getRange(indexItalicos[i - 1] + 1, indexItalicos[i])
              .join('');
          if (italico.contains(' ')) {
            final n = italico.replaceAll(' ', '%s');
            texto = texto.replaceAll(italico, n);
            italico = italico.replaceAll(' ', '%s');
          }
          if (texto.split('*$italico*').isNotEmpty) {
            texto = texto.split('*$italico*').join(' %I$italico ');
          }
          if (texto.split('_${italico}_').isNotEmpty) {
            texto = texto.split('_${italico}_').join(' %I$italico ');
          }
          italicos.add('%I$italico');
        }
      }

      if (indexColchetesAbrindo.isNotEmpty &&
          indexColchetesFechando.isNotEmpty) {
        for (var i = 0; i < indexColchetesAbrindo.length; i++) {
          final firstIndex = indexColchetesAbrindo[i];
          final lastIndex = indexColchetesFechando[i];
          final firstIndex2 = indexPathLinkAbrindo[i];
          final lastIndex2 = indexPathLinkFechando[i];
          String chave = values.getRange(firstIndex + 1, lastIndex).join('');
          if (chave.contains(' ')) {
            final n = chave.replaceAll(' ', '%s');
            texto = texto.replaceAll(chave, n);
            chave = chave.replaceAll(' ', '%s');
          }
          final link = values.getRange(firstIndex2 + 1, lastIndex2).join('');
          texto = texto.split('[$chave]').join(' %c$chave ');
          texto = texto.split('(${link.replaceAll(' ', '')})').join('');
          links.add({"text": '%c$chave', "path": link});
        }
      }

      final List<String> novoTexto = texto.split(' ');
      final List<String> linksNotShow = [];
      for (var i = 0; i < novoTexto.length; i++) {
        final textNew = novoTexto[i];
        if (textNew.contains('%N') && !textNew.contains('%IN')) {
          final newVal = negritos.firstWhere((element) => element == textNew);
          texts.add(TextSpan(
            text: newVal.replaceAll('%N', '').replaceAll('%s', ' '),
            style: TextStyle(
              color: widget.colorTextRobotMessage ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ));
        } else if (textNew.contains('%I') && !textNew.contains('%IN')) {
          final newVal = italicos.firstWhere((element) => element == textNew);
          texts.add(TextSpan(
            text: newVal.replaceAll('%I', '').replaceAll('%s', ' '),
            style: TextStyle(
              color: widget.colorTextRobotMessage ?? Colors.black,
              fontStyle: FontStyle.italic,
            ),
          ));
        } else if (textNew.contains('%c')) {
          final Map newVal =
              links.firstWhere((element) => element['text'] == textNew);
          linksNotShow.add(newVal['path']);
          texts.add(TextSpan(
            text: newVal['text']
                .toString()
                .replaceAll('%c', '')
                .replaceAll(' ', '')
                .replaceAll("%s", ' '),
            style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final String path = newVal['path'].replaceAll('https://', '');
                if (!await launchUrl(Uri.parse('https://$path'),
                    mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $path');
                }
              },
          ));
        } else if (textNew.contains('%IN')) {
          final newVal =
              italicosENegritos.firstWhere((element) => element == textNew);
          texts.add(TextSpan(
            text: newVal.replaceAll('%IN', '').replaceAll('%s', ' '),
            style: TextStyle(
                color: widget.colorTextRobotMessage ?? Colors.black,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ));
        } else {
          if (!linksNotShow.contains(textNew)) {
            texts.add(TextSpan(
              text: textNew.replaceAll("%s", ' '),
              style: TextStyle(
                  color: widget.colorTextRobotMessage ?? Colors.black),
            ));
          }
        }
        texts.add(TextSpan(
          text: ' ',
          style: TextStyle(color: widget.colorTextRobotMessage ?? Colors.black),
        ));
      }
    }
    if (links.isEmpty && italicos.isEmpty && negritos.isEmpty) return [];
    return texts;
  }
}
