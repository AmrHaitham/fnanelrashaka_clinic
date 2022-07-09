import 'dart:async';

import 'package:fanan_elrashaka_clinic/PaymentConstants.dart';
import 'package:fanan_elrashaka_clinic/screens/MainContainerHome.dart';
import 'package:fanan_elrashaka_clinic/widgets/MainContainer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class Paymob extends StatelessWidget {
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    print("PaymobFinalTokenCard is :- ${PaymobFinalTokenCard}");
    print("https://accept.paymob.com/api/acceptance/iframes/${iframeID}?payment_token=${PaymobFinalTokenCard}");
    return MainContainerHome(
        title: "",
        child: Padding(
          padding: EdgeInsets.all(1),
          child: WebView(
            initialUrl: 'https://accept.paymob.com/api/acceptance/iframes/${iframeID}?payment_token=${PaymobFinalTokenCard}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onProgress: (int progress) {
              print('PayMOb iframe is loading (progress : $progress%)');
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
            backgroundColor: const Color(0x00000000),
          ),
        ),
        backIcon: true, patternColor: Colors.grey);
  }
}
