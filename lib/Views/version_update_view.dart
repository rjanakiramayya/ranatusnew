import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';

class VersionUpdateView extends StatelessWidget {
  static const String routeName = '/VersionUpdateView';

  VersionUpdateView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Renatus'),),
      body: Center(
        child: ElevatedButton(onPressed: (){
          StoreRedirect.redirect(androidAppId: 'com.mobileapp.renatus',iOSAppId: '');
        },child: const Text('Click Here TO Update'),),
      ),
    );
  }
}
