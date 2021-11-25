import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:renatus/Models/statemodel.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/validator.dart';
import 'package:renatus/Views/registration_preview_screen.dart';
import 'package:renatus/Widgets/adaptive_flat_button.dart';
import 'package:renatus/Widgets/sub_header.dart';

class RegistrationForm extends StatefulWidget {
  static const String routeName = '/RegistrationForm';

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  var _key = GlobalKey<FormState>();
  late TextEditingController sprIdCtrl,
      sprNameCtrl,
      placeId,
      placeName,
      firstCtrl,
      middleCtrl,
      lastCtrl,
      addressCtrl,
      address1Ctrl,
      cityCtrl,
      districCtrl,
      pincodeCtrl,
      mobileCtrl,
      emailCtrl,
      nomineeNameCtrl,
      userIdCtrl,
      passCtrl,
      cpassCtrl;
  DateFormat format = DateFormat("yyyy-MM-dd");
  late DateTime pikeddateg;
  late String dobdate, nomineedob;
  late List<StateModel> staties,titlearray;
  late int stateIndex, relationindex, titleIndex;
  late bool isChack, isLoad;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stateIndex = 0;
    relationindex = 0;
    titleIndex = 0;
    staties = [];
    titlearray = [];
    isChack = false;
    isLoad = true;
    staties.add(StateModel(Id: '0', Value: 'Select State'));
    titlearray.add(StateModel(Id: 'Mr', Value: 'Mr'));
    titlearray.add(StateModel(Id: 'Ms', Value: 'Ms'));
    titlearray.add(StateModel(Id: 'Mrs', Value: 'Mrs'));
    sprIdCtrl = TextEditingController();
    sprNameCtrl = TextEditingController();
    placeId = TextEditingController();
    placeName = TextEditingController();
    firstCtrl = TextEditingController();
    middleCtrl = TextEditingController();
    lastCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    address1Ctrl = TextEditingController();
    cityCtrl = TextEditingController();
    districCtrl = TextEditingController();
    pincodeCtrl = TextEditingController();
    mobileCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    nomineeNameCtrl = TextEditingController();
    userIdCtrl = TextEditingController();
    passCtrl = TextEditingController();
    cpassCtrl = TextEditingController();
    dobdate = 'Select DOB';
    nomineedob = 'Select Nominee DOB';
    var args = Get.arguments;
    sprIdCtrl.text = args['spId'];
    sprNameCtrl.text = args['spName'];
    placeId.text = args['spId'];
    placeName.text = args['spName'];
    callStates();
  }

  _validate() {
    if (_key.currentState!.validate()) {
      if(stateIndex==0) {
        Logger.ShowWorningAlert('Warning', 'Select State.');
      } else if(dobdate=='Select DOB') {
        Logger.ShowWorningAlert('Warning', 'Select Date of Birth.');
      } else if(passCtrl.text!=cpassCtrl.text) {
        Logger.ShowWorningAlert('Warning', 'Password and Confirm Password Not Same.');
      }  else  if(!isChack) {
        Logger.ShowWorningAlert('Warning', 'Check Terms and Conditions.');
      } else if(emailCtrl.text=='') {
        callNext();
      } else {
        if(Validator.emailValidator(emailCtrl.text).isNull){
          callNext();
        } else {
          Logger.ShowWorningAlert('Warning', 'Enter Valid Email ID.');
        }
      }
    }
  }

  callNext() {
    Map<String,dynamic> args = {
      'title':titlearray[titleIndex].Value,
      'sprId':sprIdCtrl.text,
      'sprName':sprNameCtrl.text,
      'placId':placeId.text,
      'placName':placeName.text,
      'fName':firstCtrl.text,
      'mName':middleCtrl.text,
      'lName':lastCtrl.text,
      'dob':dobdate,
      'address':addressCtrl.text,
      'address1':address1Ctrl.text,
      'city':cityCtrl.text,
      'district':districCtrl.text,
      'stateId':staties[stateIndex].Id,
      'stateName':staties[stateIndex].Value,
      'pincode':pincodeCtrl.text,
      'mobile':mobileCtrl.text,
      'email':emailCtrl.text,
      'nomineeName':nomineeNameCtrl.text,
      'nomineeDob':nomineedob,
      'nomineeRelation':Constants.relations[relationindex],
      'userId':userIdCtrl.text,
      'password':passCtrl.text,
    };
    Get.toNamed(RegistrationPreviewScreen.routeName,arguments: args);
  }

  void callStates() {
    Map<String, dynamic> param = {
      'Action': 'GetStatesWithoutOthers',
    };
    NetworkCalls().callServer(Constants.apiStates, param).then((value) {
      var data = jsonDecode(value!.body) as List;
      staties.clear();
      staties.add(StateModel(Id: '0', Value: 'Select State'));
      setState(() {
        staties.addAll(data.map((e) => StateModel.stateJson(e)));
        setState(() {
          isLoad = false;
        });
      });
    });
  }

  void _presentDatePicker(String datakey) {
    showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialDate: DateTime.now().subtract(const Duration(days: 7305)),
      lastDate: DateTime.now().subtract(const Duration(days: 7305)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        pikeddateg = pickedDate;
        if (datakey == 'dob') {
          dobdate = DateFormat.yMd().format(pikeddateg);
        } else {
          nomineedob = DateFormat.yMd().format(pikeddateg);
        }
        //_profileData.nomineeDOB = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  Widget datePicker(String datakey) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              dobdate,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          FlatButton(
            textColor: Color(0xff020f72),
            child: const Text(
              'Choose Date',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            onPressed: () => _presentDatePicker('dob'),
          ),
        ],
      ),
    );
  }

  Widget nomineedatePicker(String datakey) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              nomineedob,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          FlatButton(
            textColor: Color(0xff020f72),
            child: const Text(
              'Choose Date',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            onPressed: () => _presentDatePicker('nominee'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
      ),
      body: isLoad
          ? const Center()
          : SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'New SignUp',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 6,
                          ),
                          const SubHeader('Sponsor Details'),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: sprIdCtrl,
                              keyboardType: TextInputType.text,
                              validator: (val) => Validator.inputValidate(val!),
                              textInputAction: TextInputAction.next,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white12,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Sponsor ID',
                                labelText: 'Sponsor ID',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: sprNameCtrl,
                              keyboardType: TextInputType.text,
                              validator: (val) => Validator.inputValidate(val!),
                              textInputAction: TextInputAction.next,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white12,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Sponsor Name',
                                labelText: 'Sponsor Name',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: placeId,
                              keyboardType: TextInputType.text,
                              validator: (val) => Validator.inputValidate(val!),
                              textInputAction: TextInputAction.next,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white12,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Placement ID',
                                labelText: 'Placement ID',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: placeName,
                              keyboardType: TextInputType.text,
                              validator: (val) => Validator.inputValidate(val!),
                              textInputAction: TextInputAction.next,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white12,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Placement Name',
                                labelText: 'Placement Name',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SubHeader('Personal Details'),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.black38,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<StateModel>(
                                  iconEnabledColor: Colors.black,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: firstCtrl,
                              keyboardType: TextInputType.text,
                              validator: (val) => Validator.inputValidate(val!),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'First Name *',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: middleCtrl,
                              keyboardType: TextInputType.text,
                              validator: (val) => Validator.noValidate(val!),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [

                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Middle Name ',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: lastCtrl,
                              keyboardType: TextInputType.text,
                              validator: (val) => Validator.inputValidate(val!),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [

                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Last Name *',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          datePicker('DOB'),
                          const SubHeader('Address Details'),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: addressCtrl,
                              keyboardType: TextInputType.text,
                              maxLines: 3,
                              validator: (val) => Validator.inputValidate(val!),
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Address1 *',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: address1Ctrl,
                              keyboardType: TextInputType.text,
                              maxLines: 3,
                              validator: (val) => Validator.noValidate(val!),
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Address2',
                                labelText: 'Address2',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: cityCtrl,
                              keyboardType: TextInputType.text,
                              validator: (val) => Validator.inputValidate(val!),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'City *',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: districCtrl,
                              keyboardType: TextInputType.text,
                              validator: (val) => Validator.inputValidate(val!),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'District *',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.black38,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<StateModel>(
                                  iconEnabledColor: Colors.black,
                                  isExpanded: true,
                                  hint: Text(
                                    staties[stateIndex].Value,
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15.0,
                                        fontFamily: 'Nunito'),
                                  ),
                                  items: staties.map((StateModel map) {
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
                                      stateIndex = staties.indexOf(value!);
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: pincodeCtrl,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              validator: (val) =>
                                  Validator.pinCodeValidator(val!),
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'PinCode *',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: mobileCtrl,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              validator: (val) =>
                                  Validator.mobileValidator(val!),
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Mobile No *',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              validator: (val) => Validator.noValidate(val!),
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Email Id',
                              ),
                            ),
                          ),
                          const SubHeader('Nominee Details'),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: nomineeNameCtrl,
                              keyboardType: TextInputType.name,
                              validator: (val) => Validator.noValidate(val!),
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Nominee Name',
                              ),
                            ),
                          ),
                          nomineedatePicker('NomineeDOB'),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.black38,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  iconEnabledColor: Colors.black,
                                  isExpanded: true,
                                  hint: Text(
                                    Constants.relations[relationindex],
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15.0,
                                        fontFamily: 'Nunito'),
                                  ),
                                  items: Constants.relations.map((String map) {
                                    return DropdownMenuItem<String>(
                                      value: map,
                                      child: Text(
                                        map,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      relationindex =
                                          Constants.relations.indexOf(value!);
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          const SubHeader('Login Details'),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: userIdCtrl,
                              keyboardType: TextInputType.text,
                              validator: (val) => Validator.userValidator(val!),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(r'\s')
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'User Id',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: passCtrl,
                              keyboardType: TextInputType.text,
                              validator: (val) =>
                                  Validator.passwordValidator(val!),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Password',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: TextFormField(
                              controller: cpassCtrl,
                              keyboardType: TextInputType.text,
                              validator: (val) =>
                                  Validator.passwordValidator(val!),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Confirm Password',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: isChack,
                                  onChanged: (va) {
                                    setState(() {
                                      isChack = !isChack;
                                    });
                                  }),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('I Agree & Understand'),
                              const Text(
                                ':Terms and Conditions',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            width: Get.width - 150,
                            height: 50,
                            child: TextButton(
                              onPressed: () => _validate(),
                              child: const Text(
                                'PREVIEW',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
