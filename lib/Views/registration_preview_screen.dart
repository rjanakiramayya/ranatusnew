import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Views/registration_status_view.dart';
import 'package:renatus/Widgets/sub_child_item.dart';
import 'package:renatus/Widgets/sub_header.dart';

class RegistrationPreviewScreen extends StatelessWidget {
  static const String routeName = '/RegistrationPreviewScreen';
  late Map<String, dynamic> args;

  RegistrationPreviewScreen({Key? key}) : super(key: key);

  _onSubmit() {
    Map<String, dynamic> param = {
      'Sprno':args['sprId'],
      'Name':'${args['fName']}  ',
      'Dob':args['dob'],
      'Address1':args['address'],
      'Address2':args['address1'],
      'City':args['city'],
      'State':args['stateId'],
      'PINCode':args['pincode'],
      'Mobile':args['mobile'],
      'Email':args['email'],
      'LPassword':args['password'],
      'dwnidno':'',
      'Nominee':args['nomineeName'],
      'Relation':args['nomineeRelation']=='Select' ? '' : args['nomineeRelation'],
      'title':args['title'],
      'MiddleName':args['mName'],
      'LastName':args['lName'],
      'District':args['district'],
      'UserIDNo':args['userId'],
      'NomDOB':args['nomineeDob'] == 'Select Nominee DOB' ? '' : args['nomineeDob'],
    };
    NetworkCalls().callServer(Constants.apiInsertReg, param).then((value) {
      var data = jsonDecode(value!.body);
      if(data['Msg'].toString().toUpperCase()==Constants.success) {
        Get.toNamed(RegistrationStausView.routeName,arguments: data);
      } else {
        Logger.ShowWorningAlert('Warning', data['Message']);
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
    args = Get.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Preview')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SubHeader('Login Details'),
              SubChildItem('Login', args['userId'], true),
              const SubHeader('Sponsor Details'),
              SubChildItem('Title', args['title'], true),
              SubChildItem('Sponsor Id', args['sprId'], true),
              SubChildItem('Sponsor Name', args['sprName'], true),
              SubChildItem('Placement Id', args['placId'], true),
              SubChildItem('Placement Name', args['placName'], true),
              const SubHeader('Personal Details'),
              SubChildItem('Name', '${args['fName']} ${args['mName']} ${args['lName']}', true),
              SubChildItem('Date of Birth', args['dob'], true),
              const SubHeader('Address Details'),
              SubChildItem('Address', args['address'], true),
              SubChildItem('Address1', args['address1'], true),
              SubChildItem('City', args['city'], true),
              SubChildItem('District', args['district'], true),
              SubChildItem('State', args['stateName'], true),
              SubChildItem('Pincode', args['pincode'], true),
              SubChildItem('Email', args['email'], true),
              SubChildItem('Mobile No', args['mobile'], true),
              const SubHeader('Nominee Details'),
              SubChildItem('Nominee', args['nomineeName'], true),
              SubChildItem('Relation', args['nomineeRelation']=='Select' ? '' : args['nomineeRelation'], true),
              SubChildItem('Nominee DOB', args['nomineeDob'] == 'Select Nominee DOB' ? '' : args['nomineeDob'], true),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: () => _onSubmit(), child: const Text('SUBMIT')),
            ],
          ),
        ),
      ),
    );
  }
}
