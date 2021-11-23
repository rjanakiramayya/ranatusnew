
import 'dart:convert';


import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:renatus/Models/homedata.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  late HomeData homeData;

  @override
  void onInit(){
    super.onInit();
    getHomeData();
  }

  void getHomeData() {
    isLoading(true);
    Map<String, dynamic> param = {};
    NetworkCalls().callServer(Constants.apiHome, param).then((value) {
      var data = jsonDecode(jsonDecode(value!.body));
      homeData = HomeData.fromJson(data);
      isLoading(false);
      isError(false);
    }).catchError((onError){
      isLoading(false);
      isError(true);
      EasyLoading.showToast(Constants.somethingWrong);
    });
  }


}