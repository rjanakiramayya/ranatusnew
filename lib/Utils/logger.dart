import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Logger{
  static log(dynamic msg) {
    print('Renatus :: ${msg}');
  }

  static void ShowErrorAlert(String title,String msg) {
    Get.snackbar(title, msg,margin: const EdgeInsets.fromLTRB(5, 20, 10, 5),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
  }
  static void ShowWorningAlert(String title,String msg) {
    Get.snackbar(title, msg,margin: const EdgeInsets.fromLTRB(5, 20, 10, 5),
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white);
  }
  static void ShowSuccessAlert(String title,String msg) {
    Get.snackbar(title, msg,margin: const EdgeInsets.fromLTRB(5, 20, 10, 5),
        backgroundColor: Colors.green,
        colorText: Colors.white);
  }

}