import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class FWebView extends StatefulWidget {
  static const String routeName = '/FWebView';
  @override
  FWebViewState createState() => FWebViewState();
}

class FWebViewState extends State<FWebView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    EasyLoading.show(status: 'Loading...');
  }
  @override
  Widget build(BuildContext context) {
    Map<String,String> param = Get.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(title: Text('${param['title']}'),),
      body: WebView(
        initialUrl: '${param['url']}',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('${param['url']}')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          EasyLoading.show(status: 'Loading...');
        },
        onPageFinished: (String url) {
          EasyLoading.dismiss();
        },
        gestureNavigationEnabled: true,
      ),
    );
  }
}
