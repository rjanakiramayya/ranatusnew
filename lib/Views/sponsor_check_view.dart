import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';
import 'package:renatus/Views/registration_form.dart';

class SponsorCheckView extends StatelessWidget {
  static const String routeName = '/SponsorCheckView';
  SponsorCheckView({Key? key}) : super(key: key);
  final _key = GlobalKey<FormState>();
  TextEditingController sprCtrl = TextEditingController();

  void _checkSponsor() {
    if(_key.currentState!.validate()){
      Map<String, String> param = {
        'Idno':sprCtrl.text,
      };
      NetworkCalls().callServer(Constants.apiRegSponsorCheck, param).then((value) {
        var data = jsonDecode(value!.body);
        if(data['Msg'].toString().toUpperCase()==Constants.success) {
          Map<String, dynamic> args = {
            'spRegId':data['Sprno'],
            'spId':data['SponsorID'],
            'spName':data['SponsorName'],
          };
          Get.toNamed(RegistrationForm.routeName,arguments: args);
        } else {
          Logger.ShowWorningAlert(data['Msg'].toString(), data['Message'].toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    sprCtrl.text = SessionManager.getString(Constants.PREF_IDNo);
    return Scaffold(
      appBar: AppBar(title: const Text('Sponsor Check'),),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              const SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 20),
                child: TextFormField(
                  controller: sprCtrl,
                  keyboardType: TextInputType.text,
                  validator: (val) => Validator.idValidator(val!),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(r'\s')
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: 'Sponsor IRD',
                  ),
                ),
              ),
              const SizedBox(
                height: Constants.spaceL,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green),
                width: 150,
                height: 50,
                child: TextButton(
                  onPressed: () => _checkSponsor(),
                  child: const Text(
                    'Check',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
