import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot_koreai/src/shared/dictionary.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/chat_model.dart';

class CardRobotImages extends StatelessWidget {
  Color? colorTextRobotMessage;
  Color? colorRobotCard;
  Color? colorRobotIcon;
  IconData? iconRobot;
  ChatModel? chat;
  bool hasIcon;
  CardRobotImages({
    super.key,
    this.chat,
    this.colorRobotCard,
    this.colorRobotIcon,
    this.colorTextRobotMessage,
    required this.hasIcon,
    this.iconRobot,
  });

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
                margin: EdgeInsets.only(
                    top: size.width * .031, right: size.width * .02),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * .6,
                              height: size.width * .9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: CachedNetworkImage(
                                    imageUrl: chat!.linkImage!,
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
                            ),
                            RichText(
                              text: TextSpan(
                                  children: returnMarkDownText(
                                      chat!.textInImage ?? '')),
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * .04,
                              vertical: size.width * .025),
                          child: Text(
                            chat?.createdOn?.formattTime() ?? '',
                            style: TextStyle(
                                color: colorTextRobotMessage ?? Colors.grey),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ));
  }

  List<TextSpan> returnMarkDownText(String val) {
    List<TextSpan> texts = [];
    String texto = val;
    List<int> indexColchetesAbrindo = [];
    List<int> indexColchetesFechando = [];
    List<int> indexPathLinkAbrindo = [];
    List<int> indexPathLinkFechando = [];
    List<int> indexNegritos = [];
    List<int> indexItalicos = [];
    List<String> negritos = [];
    List<String> italicos = [];
    List<Map> links = [];
    // if ((val.contains('[') ||
    //         val.contains(']') ||
    //         val.contains('(') ||
    //         val.contains(')') ||
    //         val.contains('**') ||
    //         val.contains('*') ||
    //         val.contains('__') ||
    //         val.contains('_')) &&
    //     !val.contains('template')) {
    final List<String> values = val.split('');
    values.add(' ');
    values.insert(0, ' ');
    for (var i = 1; i < values.length; i++) {
      final text = values[i];
      if (text == '[') {
        indexColchetesAbrindo.add(i);
      } else if (text == ']') {
        indexColchetesFechando.add(i);
      } else if (text == '*' && values[i - 1] == '*') {
        indexNegritos.add(i - 1);
      } else if (text == '_' && values[i - 1] == '_') {
        indexNegritos.add(i - 1);
      } else if (text == '*' && values[i - 1] != '*' && values[i + 1] != '*') {
        indexItalicos.add(i);
      } else if (text == '_' && values[i - 1] != '_' && values[i + 1] != '_') {
        indexItalicos.add(i);
      } else if (text == '(') {
        indexPathLinkAbrindo.add(i);
      } else if (text == ')') {
        indexPathLinkFechando.add(i);
      }
    }
    for (var i = 0; i < indexPathLinkAbrindo.length; i++) {
      final first = indexPathLinkAbrindo[i];
      final second = indexPathLinkFechando[i];
      indexItalicos
          .removeWhere((element) => first < element && second > element);
    }
    if (indexNegritos.isNotEmpty) {
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

    if (indexColchetesAbrindo.isNotEmpty && indexColchetesFechando.isNotEmpty) {
      for (var i = 0; i < indexColchetesAbrindo.length; i++) {
        final firstIndex = indexColchetesAbrindo[i];
        final lastIndex = indexColchetesFechando[i];
        final firstIndex2 = indexPathLinkAbrindo[i];
        final lastIndex2 = indexPathLinkFechando[i];
        final chave = values.getRange(firstIndex + 1, lastIndex).join('');
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
      if (textNew.contains('%N')) {
        final newVal = negritos.firstWhere((element) => element == textNew);
        texts.add(TextSpan(
          text: newVal.replaceAll('%N', '').replaceAll('%s', ' '),
          style: TextStyle(
            color: colorTextRobotMessage ?? Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ));
        print(newVal);
      } else if (textNew.contains('%I')) {
        final newVal = italicos.firstWhere((element) => element == textNew);
        texts.add(TextSpan(
          text: newVal.replaceAll('%I', '').replaceAll('%s', ' '),
          style: TextStyle(
            color: colorTextRobotMessage ?? Colors.black,
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
              .replaceAll(' ', ''),
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
      } else {
        if (!linksNotShow.contains(textNew)) {
          texts.add(TextSpan(
            text: textNew,
            style: TextStyle(color: colorTextRobotMessage ?? Colors.black),
          ));
        }
      }
      texts.add(TextSpan(
        text: ' ',
        style: TextStyle(color: colorTextRobotMessage ?? Colors.black),
      ));
    }
    return texts;
  }
}
