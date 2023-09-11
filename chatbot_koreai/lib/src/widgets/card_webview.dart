
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatWebview extends StatefulWidget {
  final String html;
  const ChatWebview({super.key, required this.html});

  @override
  State<ChatWebview> createState() => _ChatWebviewState();
}
// PARA IOS

class _ChatWebviewState extends State<ChatWebview> {
  @override
  void initState() {
    super.initState();
  }

  // InAppWebViewController? webViewController;
  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //   crossPlatform: InAppWebViewOptions(
  //     useShouldOverrideUrlLoading: true,
  //     mediaPlaybackRequiresUserGesture: true,
  //     javaScriptEnabled: true,
  //     javaScriptCanOpenWindowsAutomatically: true,
  //   ),
  //   android: AndroidInAppWebViewOptions(
  //     useHybridComposition: true,
  //   ),
  //   ios: IOSInAppWebViewOptions(
  //     allowsInlineMediaPlayback: true,
  //   ),
  // );

  // final Completer<InAppWebViewController> _controller =
  //     Completer<InAppWebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 2.4,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Html(
             style: {
              'body': Style(backgroundColor: Colors.white)
             }, 
              onLinkTap: (url, context, attributes, element) async {
                if (!await launchUrl(Uri.parse(url!),
                    mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              },
              data: widget.html,
            ),
          ),
        ),
      ),
      // body: InAppWebView(
      //   initialOptions: options,
      //   onWebViewCreated: (controller) {
      //     webViewController = controller;
      //     _controller.complete(controller);
      //     controller.addJavaScriptHandler(
      //         handlerName: 'handlerFoo',
      //         callback: (args) {
      //           // return data to the JavaScript side!
      //           return {'bar': 'bar_value', 'baz': 'baz_value'};
      //         });

      //     controller.addJavaScriptHandler(
      //         handlerName: 'handlerFooWithArgs',
      //         callback: (args) {
      //           print(args);
      //           // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
      //         });
      //   },
      //   initialData: InAppWebViewInitialData(data: '''
      // <!DOCTYPE html>
      // <html>
      //   <head>
      //   <style>
      //       .xxxlarge{
      //         font-size:xxx-large;
      //       }
      //   </style>
      //   </head>
      //   <body>
      //     <div class = "xxxlarge">${widget.html};</div>
      //   </body>
      //   <script>
      //     window.addEventListener("touchmove", function(event) {
      //       window.flutter_inappwebview.callHandler('handlerFoo')
      //         .then(function(result) {
      //           console.log({x: event.touches[0].clientX, y: event.touches[0].clientY});
      //           window.flutter_inappwebview
      //             .callHandler('handlerFooWithArgs', 1, true, ['bar', 5], {x: event.touches[0].clientX, y: event.touches[0].clientY}, result);
      //       });
      //     });
      //   </script>
      // </html>
      // '''),
      // ),
    );
  }
}
