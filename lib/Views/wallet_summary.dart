
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:renatus/Controllers/authcontroller.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';
import 'package:renatus/Views/add_fund_view.dart';
import 'package:renatus/Views/wallet_transfer_data.dart';


class  WalletSummary extends StatefulWidget {

  const WalletSummary({Key? key}) : super(key: key);
  static const String routeName = '/WalletSummary';

  @override
  _WalletSummaryState createState() => _WalletSummaryState();
}


class _WalletSummaryState extends State<WalletSummary> {
  var authCtrl = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController tpassword = TextEditingController();
  late String type;

  _onSubmitHandller() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> param = {
        'Action': 'CheckTranPwd',
        'regid': SessionManager.getString(Constants.PREF_RegId),
        'oldpwd': tpassword.text,
        'newpwd': tpassword.text,
        'thru': SessionManager.getString(Constants.PREF_RegId),
      };
      NetworkCalls().callServer(Constants.apiAChangePassword, param).then((
          value) {
        var data = jsonDecode(value!.body);
        if (data['Msg'] == Constants.success) {
          if(type=='Wallet Summary') {
            Get.toNamed(WalletTransferData.routeName);
          } else if(type=='Credit Request') {
            Get.toNamed(AddFundView.routeName);
          }
        } else{
          Logger.ShowWorningAlert('Warning',data['Message']);
        }
      });
    }}
    _validate() {
      if (_formKey.currentState!.validate()) {
        authCtrl.onTransForgotPassword();
      }
    }

    @override
    Widget build(BuildContext context) {
    type = Get.arguments;
      return Scaffold(
        appBar: AppBar(title: const Text('EWallet Summary'),),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'E-Wallet Login ',
                      style: TextStyle(fontSize: 20),
                    )),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: tpassword,
                  obscureText: true,
                  validator: (val) => Validator.passwordValidator(val!),
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                    ),
                    labelText: 'Transaction Password',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                TextButton(
                  onPressed: () => _validate(),
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                        color: Colors.green, fontSize: 16),

                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.green),
                  width: Get.width - 250,
                  height: 50,
                  child: TextButton(
                    onPressed: () => _onSubmitHandller(),
                    child: const Text(
                      'Next',
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





