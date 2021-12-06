import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:renatus/Models/statemodel.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';
import 'package:renatus/Views/web_view.dart';

class AddressDetailsView extends StatefulWidget {
  static const String routeName = '/AddressDetailsView';

  const AddressDetailsView({Key? key}) : super(key: key);

  @override
  _AddressDetailsViewState createState() => _AddressDetailsViewState();
}

class _AddressDetailsViewState extends State<AddressDetailsView> {
  late TextEditingController IdnumberCtrl, addressCtrl, pincodeCtrl;
  late int idTypeindex; //,districtindex,stateindex,cityindex;
  late List<StateModel> IdList; //,district,states,cities;
  late bool isLoading, isEnable;
  String base64Image = '', base64Imageback = '',image='',backimage='';
  bool isImagepicked = false, isBackImagePicked = false;
  final _addressformKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    IdnumberCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    pincodeCtrl = TextEditingController();
    idTypeindex = 0;
    isEnable = true;
    IdList = [];
    IdList.add(StateModel(Id: 'Voter ID', Value: 'Voter ID'));
    IdList.add(StateModel(Id: 'Aadhar Card', Value: 'Aadhar No'));
    IdList.add(StateModel(Id: 'Driving Licence', Value: 'Driving Licence'));
    IdList.add(StateModel(Id: 'Passport', Value: 'Passport'));
    Future.delayed(Duration.zero).then((value) {
      var data = Get.arguments;
      if (data == '1') {
        setState(() {
          isLoading = false;
          isEnable = false;
        });
        callGetDetails();
      }
    });
  }

  void callGetDetails() {
    Map<String, dynamic> param = {
      "Action": "ID Card",
      "Regid": SessionManager.getString(Constants.PREF_RegId)
    };
    NetworkCalls().callServer(Constants.apiMemberKYC, param).then((value) {
      var data = jsonDecode(value!.body);
      if (data['Msg'].toString().toUpperCase() == Constants.success) {
        IdList.clear();
        IdList.add(StateModel(Id: data['Name'], Value: data['Name']));
        IdnumberCtrl.text = data['Bank'];
        image = data['KYCImg'];
        backimage = data['KYCBackImg'];
        setState(() {
          isLoading = true;
          isEnable = false;
        });
      } else {
        Logger.ShowWorningAlert('Warning', data['Message']);
      }
    });
  }

  Future _userChoice(String type) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select '),
            children: <Widget>[
              RaisedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
                color: Colors.white,
                elevation: 0,
                onPressed: () {
                  chooseImageAadhar(type);
                },
              ),
              const Divider(
                color: Colors.black,
              ),
              RaisedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
                color: Colors.white,
                elevation: 0,
                onPressed: () {
                  chooseGalleryAadhar(type);
                },
              ),
            ],
          );
        });
  }

  chooseGalleryAadhar(String Side) async {
    ImagePicker picker = ImagePicker();
    var aadharfile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      File img = File(aadharfile!.path);
      final bytes = img.readAsBytesSync();
      if (Side == 'front') {
        base64Image = base64Encode(bytes);
        if (base64Image != "") {
          isImagepicked = true;
        }
      } else {
        base64Imageback = base64Encode(bytes);
        if (base64Imageback != "") {
          isBackImagePicked = true;
        }
      }
    });
  }

  chooseImageAadhar(String Side) async {
    ImagePicker picker = ImagePicker();
    var aadharfile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      File img = File(aadharfile!.path);
      final bytes = img.readAsBytesSync();
      if (Side == 'front') {
        base64Image = base64Encode(bytes);
        if (base64Image != "") {
          isImagepicked = true;
        }
      } else {
        base64Imageback = base64Encode(bytes);
        if (base64Imageback != "") {
          isBackImagePicked = true;
        }
      }
    });
  }

  _onSubmit() {
    if (_addressformKey.currentState!.validate()) {
      if (base64Image == '') {
        Get.snackbar('Input Warning', 'Please Pick Id Proof Front Image',
            margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
            backgroundColor: Colors.blue);
      } else if (base64Imageback == '') {
        Get.snackbar('Input Warning', 'Please Pick Id Proof Back Image',
            margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
            backgroundColor: Colors.blue);
      } else {
        Random ranint = Random();
        String SessionId = DateTime.now().millisecondsSinceEpoch.toString() +
            ranint.nextInt(100000).toString();
        Map<String, dynamic> param = {
          'Regid': SessionManager.getString(Constants.PREF_RegId),
          'accno': '',
          'proftype': 'ID Card',
          'bank': IdnumberCtrl.text, // ID No
          'IFSC': IdList[idTypeindex].Id, // Address
          'AccHolderName': '',
          'sesid': SessionId, //
          'Branch': base64Imageback, // Select ID Type
          'filename': base64Image,
        };
        NetworkCalls()
            .callPlanServer(Constants.apiUploadIDProofDetailsRequestUsr, param)
            .then((value) {
          var data = jsonDecode(value!.body);
          if (data['Msg'].toString().toUpperCase() == Constants.success) {
            Get.back();
            Get.snackbar('Success', 'Address Proof Uploaded Successfully',
                margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                backgroundColor: Colors.green);
          } else {
            Get.snackbar('Warning', 'Please Try Again After Some Time',
                margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                backgroundColor: Colors.blue);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Details'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addressformKey,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                IgnorePointer(
                  ignoring: !isEnable,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Colors.black38,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<StateModel>(
                          iconEnabledColor: Colors.black,
                          isExpanded: true,
                          hint: Text(
                            IdList[idTypeindex].Value,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontFamily: 'Nunito'),
                          ),
                          items: IdList.map((StateModel map) {
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
                              idTypeindex = IdList.indexOf(value!);
                            });
                          }),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: IdnumberCtrl,
                  keyboardType: TextInputType.text,
                  enabled: isEnable,
                  maxLines: 1,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(RegExp(r'\s')),
                  ],
                  validator: (v) => Validator.idValidator(v!),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black87),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "ID Number ",
                    labelText: "ID Number ",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: isEnable,
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 0, top: 0, bottom: 5),
                        child: Text(
                          "Upload Address Front",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 36,
                            ),
                            onPressed: () {
                              _userChoice('front');
                            },
                          ),
                        ),
                        padding:
                            const EdgeInsets.only(right: 0, top: 15, bottom: 6),
                      ),
                      Visibility(
                        visible: isEnable,
                        child: Padding(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Visibility(
                              visible: isImagepicked,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.assignment_turned_in,
                                  size: 22,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  //print("dhdhduy");
                                },
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(right: 0, top: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isEnable,
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 0, top: 0, bottom: 5),
                        child: Text(
                          "Upload Address Back",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 36,
                            ),
                            onPressed: () {
                              _userChoice('back');
                            },
                          ),
                        ),
                        padding:
                            const EdgeInsets.only(right: 0, top: 15, bottom: 6),
                      ),
                      Visibility(
                        visible: isEnable,
                        child: Padding(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Visibility(
                              visible: isBackImagePicked,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.assignment_turned_in,
                                  size: 22,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  //print("dhdhduy");
                                },
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(right: 0, top: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isEnable,
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 25, right: 10, top: 00, bottom: 15),
                    child: Text(
                      "Note : supported formats .jpg, .jpeg,.png",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Visibility(
                  visible: isEnable,
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    child: const Text('Submit'),
                  ),
                ),
                Visibility(
                  visible: !isEnable && isLoading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Flexible(
                        flex: 1,
                        child: Text('Front Image'),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextButton(
                          child: const Text('View'),
                          onPressed: () {
                            Map<String,String> args = {
                              'title':'Front Image',
                              'url':'${Constants.addressUrl}${image}',
                            };
                            Get.toNamed(FWebView.routeName,arguments: args);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !isEnable && isLoading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Flexible(
                        flex: 1,
                        child: Text('Back Image'),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextButton(
                          child: const Text('View'),
                          onPressed: () {
                            Map<String,String> args = {
                              'title':'Front Image',
                              'url':'${Constants.addressUrl}${backimage}',
                            };
                            Get.toNamed(FWebView.routeName,arguments: args);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
