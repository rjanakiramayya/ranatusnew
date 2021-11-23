import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/authcontroller.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/initrouter.dart';
import 'package:renatus/Utils/loaclpackageinfo.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Views/main_view.dart';

import 'Controllers/cartcontroller.dart';

void main() {
  runApp(const MyApp());
  EasyLoading.instance.userInteractions = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Renatus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      builder: EasyLoading.init(),
      initialRoute: '/',
      getPages: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AuthController authCtrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SessionManager.init();
    LocalPackageInfo.init();
    authCtrl = Get.put(AuthController());
    Future.delayed(const Duration(seconds: 2)).then((value) {
      Get.put(CartController());
      if (authCtrl.isLogin == '') {
        // Constants.isFromLogin = true;
         Get.offAllNamed(MainView.routeName);
      } else {
        // Constants.isFromLogin = true;
        authCtrl.onAutoLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        '${Constants.imagePath}splashscr.png',
        width: Get.width,
        height: Get.height,
        fit: BoxFit.fill,
      ),
    );
  }
}
