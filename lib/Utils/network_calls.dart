import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;

import 'constants.dart';
import 'logger.dart';

class NetworkCalls {
  var client = http.Client();
  NetworkCalls();
  Future<http.Response?> callServer(
      String method, Map<String, dynamic> param,[bool isProgress = true]) async {
    EasyLoading.show(status: 'loading...',dismissOnTap: false);
    var connectivityResult = await (Connectivity().checkConnectivity());
    try {
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
        {
          Logger.log('logger url::: ${Constants.baseUrl}${method}');
          Logger.log('logger param::: ${json.encode(param)}');

          final key1 = enc.Key.fromUtf8("ReraaNashMlTu1AAbRdA28fhkiytrwsS");
          final iv = enc.IV.fromUtf8('IKJLMNOPABCDEFGH');
          final plainText = jsonEncode(param);
          var encrypter = enc.Encrypter(enc.AES(key1,mode: enc.AESMode.cbc));
          var encrypted = encrypter.encrypt(plainText,iv: iv);
          Map<String,dynamic> enparam = {
            'Info':encrypted.base64,
          };
          Logger.log('logger Encripted param::: ${json.encode(enparam)}');
          final response = await client.post(Uri.parse(Constants.baseUrl+method),
                headers: {
                  'Content-Type': 'application/json',
                },
                body: json.encode(enparam))
                .whenComplete(() async =>  EasyLoading.dismiss());

          EasyLoading.dismiss();
          Logger.log("logger response code:::${response.statusCode}");
          Logger.log("logger response:::${response.body}");
          if(response.statusCode == 503) {
            if(response.body.contains('under maintenance')) {
             // Get.offAllNamed(MaintananceScreen.routeName);
            }
          } else {
            return response;
          }
        } else {
        EasyLoading.dismiss();
        Logger.ShowErrorAlert('NetWorkError','No Internet Connection');
     }
    } on SocketException catch (_) {
      EasyLoading.dismiss();
      Logger.ShowErrorAlert('NetWorkError','No Internet Connection');
    } finally {
      client.close();
    }
  }

  Future<http.Response?> callPlanServer(
      String method, Map<String, dynamic> param,[bool isProgress = true]) async {
    EasyLoading.show(status: 'loading...',dismissOnTap: false);
    var connectivityResult = await (Connectivity().checkConnectivity());
    try {
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
      {
        Logger.log('logger url::: ${Constants.baseUrl}${method}');
        Logger.log('logger param::: ${json.encode(param)}');

        final response = await client.post(Uri.parse(Constants.baseUrl+method),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(param))
            .whenComplete(() async =>  EasyLoading.dismiss());

        EasyLoading.dismiss();
        Logger.log("logger response code:::${response.statusCode}");
        Logger.log("logger response:::${response.body}");
        if(response.statusCode == 503) {
          if(response.body.contains('under maintenance')) {
            // Get.offAllNamed(MaintananceScreen.routeName);
          }
        } else {
          return response;
        }
      } else {
        EasyLoading.dismiss();
        Logger.ShowErrorAlert('NetWorkError','No Internet Connection');
      }
    } on SocketException catch (_) {
      EasyLoading.dismiss();
      Logger.ShowErrorAlert('NetWorkError','No Internet Connection');
    } finally {
      client.close();
    }
  }
}