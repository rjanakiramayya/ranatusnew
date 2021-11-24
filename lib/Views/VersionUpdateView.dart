import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';

class VersionUpdateView extends StatelessWidget {
  static const String routeName = 'VersionUpdateView';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Extacy'),),
      body: Container(
        child: Center(
          child: ElevatedButton(onPressed: (){
            StoreRedirect.redirect(androidAppId: 'com.mobileapp.renatus',iOSAppId: '');
          },child: Text('Click Here TO Update'),),
        ),
      ),
    );
  }
}
