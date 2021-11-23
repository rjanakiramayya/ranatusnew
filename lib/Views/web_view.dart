import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

class FWebView extends StatefulWidget {
  static const String routeName = '/FWebView';
  @override
  FWebViewState createState() => FWebViewState();
}

class FWebViewState extends State<FWebView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    Map<String,String> param = Get.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(title: Text('${param['title']}'),),
      body: WebView(
        initialUrl: '${param['url']}',
      ),
    );
  }
}
