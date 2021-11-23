import 'dart:convert';

import 'package:get/get.dart';
import 'package:renatus/Models/dashboard_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  late DashboardModel model;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDashboardData();
  }

  void getDashboardData() {
      Map<String, dynamic> param = {
        'Idno':SessionManager.getString(Constants.PREF_RegId),
      };
      NetworkCalls().callServer(Constants.apiDashboard, param).then((value) {
        var data = jsonDecode(value!.body);
        model = DashboardModel.fromJson(data);
        isLoading(false);
      }).catchError((_){
        isError(true);
        isLoading(false);
      });
  }

}