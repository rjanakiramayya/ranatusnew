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
import 'package:renatus/Views/scheme_offer_status.dart';



class PaySchemeOffer extends StatefulWidget {
  static const String routeName = '/PaySchemeOffer';

  const PaySchemeOffer({Key? key}) : super(key: key);

  @override
  _PaySchemeOfferState createState() => _PaySchemeOfferState();

}

class _PaySchemeOfferState extends State<PaySchemeOffer> {
  final _formKey = GlobalKey<FormState>();
  late List<StateModel> schemearray;
  late int schemeIndex;


  @override
  void initState() {
    super.initState();
    schemeIndex = 0;
    schemearray = [];
    schemearray.add(StateModel(Id: 'Select', Value: 'Select'));
    callStates();
  }

  void callStates() {
    Map<String, dynamic> param = {
      'Action': 'SchemeOffer',
      'Condition': "",
      'ItemId':'0',
    };
    NetworkCalls().callServer(Constants.apiDropDown, param).then((value) {
      var data = jsonDecode(value!.body) as List;
      schemearray.clear();
      schemearray.add(StateModel(Id: 'Select', Value: 'Select'));
           Logger.log("mmm" + schemearray.length.toString());
      setState(() {
        schemearray.addAll(data.map((e) => StateModel.schemeJson(e)));
        Logger.log("mmm" + schemearray.length.toString());
      });
    });
  }
  callNext() {
    Map<String,dynamic> args = {
      'text':schemearray[schemeIndex].Value,
    };
    Get.toNamed(SchemeOfferStatus.routeName,arguments: args);
  }
  _validate() {
    if (_formKey.currentState!.validate()) {
      if (schemeIndex == 0) {
        Logger.ShowWorningAlert('Warning', 'Select Scheme Offer');
      }else{
        callNext();
      }
    }}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scheme Offer'),
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
                            schemearray[schemeIndex].Id,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 15.0,
                                fontFamily: 'Nunito'),
                          ),
                          items: schemearray.map((StateModel map) {
                            return DropdownMenuItem<StateModel>(
                              value: map,
                              child: Text(
                                map.Id,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (Id) {
                            setState(() {
                              schemeIndex = schemearray.indexOf(Id!);
                            });
                          }),
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
