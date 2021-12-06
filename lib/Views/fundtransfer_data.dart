import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:renatus/Models/statemodel.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';

class FundTransferData extends StatefulWidget {
  static const String routeName = '/FundTransferData';

  const FundTransferData({Key? key}) : super(key: key);

  @override
  _FundTransferDataState createState() => _FundTransferDataState();

}

class _FundTransferDataState extends State<FundTransferData> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController tamount = TextEditingController();
  TextEditingController transferdird = TextEditingController();
  TextEditingController remarks = TextEditingController();

  late bool isUserExist;
  late String name='',balance='';


  @override
  void initState() {
    super.initState();
    isUserExist = false;
    tamount = TextEditingController();
    transferdird = TextEditingController();
    remarks = TextEditingController();

    callWalletBalance();
  }



 callWalletBalance() {
    Map<String, dynamic> param = {
      'action': 'Member',
      'Idno': SessionManager.getString(Constants.PREF_RegId),
    };
    NetworkCalls()
        .callServer(Constants.apiEwalletBalanceUsr, param)
        .then((value) {
      var data = jsonDecode(value!.body);
      if (data['Msg'].toString().toUpperCase() == Constants.success) {
        setState(() {
          balance=data['Balance'];
        });
      } else {
        Logger.ShowWorningAlert('Warning', data['Message'].toString());
      }
    });
  }

  callUserCheck() {
    Map<String, dynamic> param = {
      'action': 'Check',
      'Idno': SessionManager.getString(Constants.PREF_IDNo),
      'dwnidno': transferdird.text,
      'amount': '0',
      'remarks': '',
      'sesid': '',
      'OTP': '0',

    };
    NetworkCalls()
        .callServer(Constants.apiFundTransfer, param)
        .then((value) {
      var data = jsonDecode(value!.body);
      if (data['Msg'].toString().toUpperCase() == Constants.success) {
        setState(() {
          isUserExist = true;
          name = data['Name'];
        });
      } else {
        Logger.ShowWorningAlert('Warning', data['Message'].toString());

      }
    });
  }

  _validate() {
    if (_formKey.currentState!.validate()) {
      Random ranint = Random();
      String SessionId = DateTime.now().millisecondsSinceEpoch.toString()+ranint.nextInt(10000000).toString();
      Map<String, dynamic> param = {
        'action': 'TRANSFER',
        'idno': SessionManager.getString(Constants.PREF_IDNo),
        'dwnidno': transferdird.text,
        'amount': tamount.text,
        'remarks': remarks.text,
        'sesid': SessionId,
        'OTP': '0',
        };
        NetworkCalls().callServer(Constants.apiFundTransfer, param).then((
            value) {
          var data = jsonDecode(value!.body);
          if (data['Msg'] == Constants.success) {
            Get.back();
            Logger.ShowWorningAlert('Success', 'Fund Transfer Success');
          } else {
            Logger.ShowWorningAlert('Warning',data['Message'].toString());
          }
        });
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fund Transfer'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                 Text('Balance Amount :$balance',
                   style: const TextStyle(
                       fontSize: 16,
                       color: Colors.black),
                 ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: tamount,
                    keyboardType: TextInputType.number,
                    validator: (val) => Validator.amountValidator(val!),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                      ),
                      labelText: 'Transfer Amount',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: transferdird,
                    keyboardType: TextInputType.text,
                    maxLength: 11,
                    validator: (val) => Validator.idValidator(val!),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                      ),
                      labelText: 'Transfer to Distributor IRD',

                    ),
                    onChanged: (val){
                      if(isUserExist){
                        setState(() {
                          isUserExist=!isUserExist;
                        });
                      }
                    },
                  ),
                Visibility(
                  visible: !isUserExist,
                  child: ElevatedButton(
                      onPressed: () => callUserCheck(),
                      child: const Text(
                        'Check',
                        style: TextStyle(
                            color: Colors.white, fontSize: 15),
                      ),
                    ),
                ),
                  const SizedBox(
                    height: 8,
                  ),
                  Visibility(
                    visible: isUserExist,
                    child: Text('Name :$name',style: const TextStyle(fontSize: 16,color: Colors.black),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: isUserExist,
                    child: TextFormField(
                      controller: remarks,
                      keyboardType: TextInputType.text,
                      maxLines: 6,
                      validator: (val) => Validator.inputValidate(val!),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                        ),
                        labelText: 'Remarks',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: isUserExist,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.green),
                      width: Get.width - 220,
                      height: 50,
                      child: TextButton(
                        onPressed: () => _validate(),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
