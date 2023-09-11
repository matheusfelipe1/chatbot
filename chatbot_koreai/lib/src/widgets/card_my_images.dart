import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot_koreai/src/shared/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../model/chat_model.dart';
import '../viewModel/progress_files.dart';

class CardMyImages extends StatefulWidget {
  Color? colorTextMyMessage;
  Color? colorMyCard;
  ChatModel? chat;
  bool? imLast;
  CardMyImages(
      {super.key,
      this.colorMyCard,
      this.colorTextMyMessage,
      this.chat,
      this.imLast});

  @override
  State<CardMyImages> createState() => _CardMyImagesState();
}

class _CardMyImagesState extends State<CardMyImages> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(right: size.width * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(right: size.width * .01),
                  constraints: BoxConstraints(maxWidth: size.width * .6),
                  child: Card(
                      color: widget.colorMyCard ??
                          const Color.fromARGB(255, 150, 147, 241),
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
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: (widget.chat?.val ?? '')
                                        .contains('https://')
                                    ? CachedNetworkImage(
                                        imageUrl: widget.chat?.val ?? '',
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                        })
                                    : Image.file(
                                        File(widget.chat?.val ?? ''),
                                        frameBuilder: (context, child, frame,
                                            wasSynchronouslyLoaded) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            child: child,
                                          );
                                        },
                                      )),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * .04,
                                vertical: size.width * .025),
                            child: Text(
                              widget.chat?.createdOn?.formattTime() ?? '',
                              style: TextStyle(
                                  color: (widget.colorTextMyMessage ??
                                          Colors.black)
                                      .withOpacity(.5)),
                            ),
                          )
                        ],
                      ))),
              if (widget.imLast ?? false)
                Obx(
                  () => ProgressFiles.value.value == 0.0
                      ? const SizedBox()
                      : CircularPercentIndicator(
                          radius: 20.0,
                          progressColor: (widget.colorMyCard ??
                                  const Color.fromARGB(255, 150, 147, 241))
                              .withOpacity(.8),
                          percent: ProgressFiles.value.value,
                        ),
                )
            ],
          ),
          if (widget.chat?.hasError != null && widget.chat?.hasError == true)
            const Icon(
              FontAwesomeIcons.xmark,
              color: Colors.red,
            )
        ],
      ),
    );
  }
}
