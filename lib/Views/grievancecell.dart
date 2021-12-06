import 'dart:convert';

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

class GrievanceCell extends StatefulWidget {
  static const String routeName = '/GrievanceCell';

  const GrievanceCell({Key? key}) : super(key: key);

  @override
  _GrievanceCellState createState() => _GrievanceCellState();

}

class _GrievanceCellState extends State<GrievanceCell> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController subject = TextEditingController();
  TextEditingController description = TextEditingController();

  late int titleIndex;
  late List<StateModel> staties, titlearray;

  @override
  void initState() {
    super.initState();
    subject = TextEditingController();
    description = TextEditingController();
    titleIndex = 0;
    titlearray = [];
    titlearray.add(StateModel(Id: 'Select', Value: 'Select'));
    titlearray.add(StateModel(Id: 'Product & Quality', Value: 'Product & Quality'));
    titlearray.add(StateModel(Id: 'DirectSeller', Value: 'DirectSeller'));
    titlearray.add(StateModel(Id: 'Franchisee', Value: 'Franchisee'));
    titlearray.add(StateModel(Id: 'Others', Value: 'Others'));
  }


  _validate() {
    if (_formKey.currentState!.validate()) {
      if (titleIndex == 0) {
        Logger.ShowWorningAlert('Warning', 'Select Grievance Type.');
      } else {
        Map<String, dynamic> param = {
          'action': 'Member',
          'Idno': SessionManager.getString(Constants.PREF_IDNo),
          'GriType': titlearray[titleIndex].Value,
          'Subject': subject.text,
          'Description': description.text,
          'sesid': '1',
          'Name': SessionManager.getString(Constants.PREF_UserName),
          'Mobile': '',
          'Email': '',
        };
        NetworkCalls().callServer(Constants.apiGrievanceCellRpt, param).then((
            value) {
          var data = jsonDecode(value!.body);
          if (data['Msg'] == Constants.success) {
            Get.back();
            Logger.ShowWorningAlert('Success', data['Message']);
          } else {
            Logger.ShowWorningAlert('Warning', data['Message']);

          }
        });
      }
  }}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grievance cell'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 3),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black38,
                      ),

                    ),

                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<StateModel>(
                          iconEnabledColor: Colors.green,
                          isExpanded: true,
                          hint: Text(
                            titlearray[titleIndex].Value,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 15.0,
                                fontFamily: 'Nunito'),
                          ),
                          items: titlearray.map((StateModel map) {
                            return DropdownMenuItem<StateModel>(
                              value: map,
                              child: Text(
                                map.Value,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              titleIndex = titlearray.indexOf(value!);
                            });
                          }),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: subject,
                    keyboardType: TextInputType.text,
                    validator: (val) => Validator.inputValidate(val!),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(

                      ),
                      labelText: 'Subject',
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: description,

                    keyboardType: TextInputType.text,
                    validator: (val) => Validator.inputValidate(val!),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(

                      ),
                      labelText: 'Description',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.green),
                    width: Get.width - 150,
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
                ],
              ),
            ),

          ),


        )

    );
  }
}
