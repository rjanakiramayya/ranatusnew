import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/devicedata.dart';
import 'package:renatus/Utils/loaclpackageinfo.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Views/version_update_view.dart';
import 'package:renatus/Views/forget_password_view.dart';
import 'package:renatus/Views/login_view.dart';
import 'package:renatus/Views/main_view.dart';


class AuthController extends GetxController {
  var _isLogin = ''.obs;
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isvisable = false;
  var mainDrawer;
  //var CartCount = Get.put(CartController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  String get isLogin {
    _isLogin.value = SessionManager.getString(Constants.PREF_IsLogin);
    return _isLogin.value;
  }


  void onLogin(String userId, String password) async {
    Map<String, dynamic> param = {
      'Idno': userId,
      'Pwd': password,
      'FCMId': '',//await _firebaseMessaging.getToken(),
      'MobileInfo': await DeviceData.getDeviceInfo(),
      'Version': LocalPackageInfo.getBuildId(),
      'AppType': LocalPackageInfo.getPlatformType(),
    };
    NetworkCalls().callServer(Constants.apiLogin, param).then((value) async {
      var data = jsonDecode(value!.body);
      if (data['Msg'].toString().toUpperCase() == Constants.success) {
        await SessionManager.setString(Constants.PREF_IsLogin, '1');
        await SessionManager.setString(Constants.PREF_UserId, userId);

        SessionManager.setString(Constants.PREF_password, password);
        await SessionManager.setString(Constants.PREF_RegId, data['Regid']);
        await SessionManager.setString(Constants.PREF_IDNo, data['Idno']);
        SessionManager.setString(Constants.PREF_UserName, data['Name']);
        SessionManager.setString(Constants.PREF_mStatus, data['Mstatus'].toString());
        SessionManager.setString(Constants.PREF_lessAccess, data['LassAccess'].toString());
        SessionManager.setString(Constants.PREF_profilePic, data['ProfilePic'].toString());
        SessionManager.setString(Constants.PREF_EncriptRegId, data['EncRegid'].toString());
        //if(Constants.isFromLogin) {
          Logger.log('main');
          Get.offAllNamed(MainView.routeName);
       // } else {
       //   Get.back();
       // }
      } else if (data[0]['Result'] == 'VERSIONUPDATE') {
        Get.offAllNamed(VersionUpdateView.routeName);
      } else if(data[0]['MobileNo']=='') {
        Get.snackbar('Login Failed', 'Please Contact Admin For Update Mobile Number',
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 40),
            colorText: Colors.white);
      } else {
        Get.snackbar('Login Failed', data[0]['Result'],
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 40),
            colorText: Colors.white);
      }
    });
  }

  void onTransForgotPassword() async {
    Map<String, dynamic> param = {
      'Action':'TPWD',
      'Idno': SessionManager.getString(Constants.PREF_IDNo),
    };
    NetworkCalls()
        .callServer(Constants.apiForgotPassword, param)
        .then((value) {
      var data = jsonDecode(value!.body);
      if (data['Msg'] == 'Success') {
        Get.snackbar('Success', data['Message'],
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 40),
            colorText: Colors.white);
      } else {
        Get.snackbar('Failed', data['Message'],
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 40),
            colorText: Colors.white);
      }
    });
  }

  void onForgotPassword(String userId) async {
    Map<String, dynamic> param = {
      'Action':'Login',
      'Idno': userId,
    };
    NetworkCalls()
        .callServer(Constants.apiForgotPassword, param)
        .then((value) {
      var data = jsonDecode(value!.body);
      if (data['result'] == 'SUCC') {
        Get.offAllNamed(LoginView.routeName);
        Get.snackbar('Success', data['Message'],
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 40),
            colorText: Colors.white);
      } else if (data['result'] == 'VERSIONUPDATE') {
        Get.offAllNamed(VersionUpdateView.routeName);
      } else {
        Get.snackbar('Failed', data['Message'],
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 40),
            colorText: Colors.white);
      }
    });
  }

  void onAutoLogin() async {
    Map<String, dynamic> param = {
      'Idno': SessionManager.getString(Constants.PREF_UserId),
      'Pwd': SessionManager.getString(Constants.PREF_password),
      'FCMId': '',//await _firebaseMessaging.getToken(),
      'MobileInfo': await DeviceData.getDeviceInfo(),
      'Version': LocalPackageInfo.getBuildId(),
      'AppType': LocalPackageInfo.getPlatformType(),
    };
    NetworkCalls().callServer(Constants.apiLogin, param).then((value) async {
      var data = jsonDecode(value!.body);
      if (data['Msg'].toString().toUpperCase() == Constants.success) {
        await SessionManager.setString(Constants.PREF_IsLogin, '1');
        await SessionManager.setString(Constants.PREF_RegId, data['Regid']);
        await SessionManager.setString(Constants.PREF_IDNo, data['Idno']);
        SessionManager.setString(Constants.PREF_UserName, data['Name']);
        SessionManager.setString(Constants.PREF_mStatus, data['Mstatus'].toString());
        SessionManager.setString(Constants.PREF_lessAccess, data['LassAccess'].toString());
        SessionManager.setString(Constants.PREF_profilePic, data['ProfilePic'].toString());
        SessionManager.setString(Constants.PREF_EncriptRegId, data['EncRegid'].toString());
        Get.offAndToNamed(MainView.routeName);
      } else if (data[0]['Result'] == 'VERSIONUPDATE') {
        Get.offAllNamed(VersionUpdateView.routeName);
      } else if(data[0]['MobileNo']=='') {
      Get.snackbar('Login Failed', 'Please Contact Admin For Update Mobile Number',
      backgroundColor: Colors.red,
      padding: EdgeInsets.symmetric(vertical: 40),
      colorText: Colors.white);
      } else {
        Get.offAndToNamed(LoginView.routeName);
      }
    });
  }


}
