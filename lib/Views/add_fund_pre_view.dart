import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Views/main_view.dart';
import 'package:renatus/Widgets/sub_child_item.dart';

class AddFundPreView extends StatelessWidget {
  static const String routeName = '/AddFundPreView';
  late Map<String, dynamic> param;
  //late bool isLoad;

  AddFundPreView({Key? key}) : super(key: key);

  _onSubmit(String mop) {
    NetworkCalls().callPlanServer(Constants.apiCreditRequest, param).then((value) {
      var data = jsonDecode(value!.body);
      if(data['Msg'].toString().toUpperCase()==Constants.success) {
        Get.offAllNamed(MainView.routeName);
        Logger.ShowSuccessAlert('Success', data['Message']);
      } else {
        Logger.ShowWorningAlert('Warning', 'Please Try Again After Sometime');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    param = Get.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(title:const Text('Preview'),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 15,),
              SubChildItem('Balance Amount', param['balance'], true),
              SubChildItem('Request Amount', param['RP'], true),
              SubChildItem('Mode Of Payment', param['MOP'], true),
              SubChildItem('Diposite Bank', param['BankName'], true),
             Visibility(
               visible: param['MOPid'] == '1',
               child: Column(
                 children: [
                   SubChildItem('Branch Code', param['Branch'], true),
                   SubChildItem('Reconciliation reference', param['DEPNO'], true),
                 ],
               ),
             ),
              Visibility(
                visible: param['MOPid'] == '2',
                child: Column(
                  children: [
                    SubChildItem('Depositor Name', param['DEPNAME'], true),
                    SubChildItem('Depositor Mobile', param['DEPMOBILE'], true),
                  ],
                ),
              ),
              Visibility(
                visible: param['MOPid'] == '3',
                child: Column(
                  children: [
                    SubChildItem('Transaction ID/ UPI/ UTR', param['DEPNO'], true),
                  ],
                ),
              ),
              Visibility(
                visible: param['MOPid'] == '4',
                child: Column(
                  children: [
                    SubChildItem('Transaction No', param['DEPNO'], true),
                    SubChildItem('Dipositer Name', param['DEPNAME'], true),
                  ],
                ),
              ),
              Visibility(
                visible: param['MOPid'] == '5',
                child: Column(
                  children: [
                    SubChildItem('Reference No', param['DEPNO'], true),
                    SubChildItem('Mobile No', param['DEPMOBILE'], true),
                  ],
                ),
              ),
              Visibility(
                visible: param['MOPid'] == '6',
                child: Column(
                  children: [
                    SubChildItem('Account No', param['DEPNO'], true),
                    SubChildItem('Account Holder Name', param['DEPNAME'], true),
                    SubChildItem('Account Holder Mobile No', param['DEPMOBILE'], true),
                  ],
                ),
              ),
              SubChildItem('City', param['City'], true),
              SubChildItem('State', param['statename'], true),
              Image.memory(base64Decode( param['FileName']),width: 150,height: 150,),
              SubChildItem('Remarks', param['Remarks'], true),
              ElevatedButton(onPressed: () => _onSubmit(param['MOP']), child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
