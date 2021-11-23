import 'package:get/get.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';

class ProfileController extends GetxController {
  var isLoad = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProfieData();
  }

  void getProfieData() {
    Map<String, dynamic> param = {
     'regid':SessionManager.getString(Constants.PREF_RegId),
    };
    NetworkCalls().callServer(Constants.apiMemberProfile, param).then((value) {

    }).catchError((_){

    });

  }

}