import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';


class ChangePasswordView extends StatefulWidget {
  static const String routeName = '/ChangePasswordView';

  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _passwordformKey = GlobalKey<FormState>();

  TextEditingController oldCtrl = TextEditingController();

  TextEditingController newpswCtrl = TextEditingController();

  TextEditingController repwdCtrl = TextEditingController();

  _onSubmitHandller() {
    if(_passwordformKey.currentState!.validate()) {
      if(newpswCtrl.text==repwdCtrl.text){
        Map<String, dynamic> param = {
          'Action':'ChgMemPwd',
          'regid' : SessionManager.getString(Constants.PREF_RegId),
          'oldpwd':oldCtrl.text,
          'newpwd':newpswCtrl.text,
          'thru':SessionManager.getString(Constants.PREF_RegId),
        };
        NetworkCalls().callServer(Constants.apiAChangePassword, param).then((value) {
          var data = jsonDecode(value!.body);
          if(data['Msg'] == Constants.success) {
            oldCtrl.text = '';
            newpswCtrl.text = '';
            repwdCtrl.text ='';
            Get.snackbar('Success', 'Password Changed Successfully',margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),backgroundColor: Colors.blue);
          } else {
            Get.snackbar('Warning', 'Password Not Changed Try After Some Time',margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),backgroundColor: Colors.blue);
          }
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password'),),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _passwordformKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: oldCtrl,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (val) => Validator.passwordValidator(val!),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: 'Old Password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: newpswCtrl,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator:(val) => Validator.passwordValidator(val!),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: 'New Password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: repwdCtrl,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (val) => Validator.passwordValidator(val!),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: 'Re-Enter Password',
                ),
              ),
              const SizedBox(
                height: 10,

              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green),
                width: Get.width - 150,
                height: 50,
                child: TextButton(
                  onPressed: () => _onSubmitHandller(),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
