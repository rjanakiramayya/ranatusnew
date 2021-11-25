import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';


class BankDetailsView extends StatefulWidget {
  static const String routeName = '/BankDetailsView';
  const BankDetailsView({Key? key}) : super(key: key);
  @override
  _BankDetailsViewState createState() => _BankDetailsViewState();
}

class _BankDetailsViewState extends State<BankDetailsView> {
  late TextEditingController accountCtrl,bankCtrl,branchCtrl,ifscCtrl,addressCtrl,cityCtrl,districtCtrl,stateCtrl;
  String base64Image = '';
  bool isImagepicked = false;
  late bool isLoading,isEnable,isBank;
  final _bankformKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accountCtrl = TextEditingController();
    bankCtrl = TextEditingController();
    branchCtrl = TextEditingController();
    ifscCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    cityCtrl = TextEditingController();
    districtCtrl = TextEditingController();
    stateCtrl = TextEditingController();
    isLoading = true;
    isEnable = true;
    isBank = true;

    Future.delayed(Duration.zero).then((value) {
      var data = Get.arguments;
      if(data =='1') {
        setState((){
          isLoading = false;
          isEnable = false;
        });
        callGetDetails();
      }
    });
  }

  void callGetDetails() {
    Map<String, dynamic> param = {
      'regid':SessionManager.getString(Constants.PREF_RegId),
      'prooftype':'BANK',
    };
    NetworkCalls().callServer(Constants.apiGetUploadBankDetailsUsr, param).then((value) {
      var data = jsonDecode(value!.body);
      if(data['Msg'].toString().toUpperCase()==Constants.success) {
        accountCtrl.text = data['Accno'];
        ifscCtrl.text = data['Ifscode'];
        bankCtrl.text = data['Bank'];
          branchCtrl.text = data['Branch'];
          addressCtrl.text = data['Address'];
          cityCtrl.text = data['City'];
          stateCtrl.text = data['State'];
          districtCtrl.text = data['District'];
        setState(() {
          isLoading =true;
          isEnable = false;
          isBank = false;
        });
      } else {
        Logger.ShowWorningAlert('Warning', data['Message']);
      }
    });
  }

  Future _userChoice() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return  SimpleDialog(
            title: const Text('Select '),
            children: <Widget>[
               RaisedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
                color: Colors.white,
                elevation: 0,
                onPressed: () {
                  chooseImageAadhar();
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
                  chooseGalleryAadhar();
                },
              ),
            ],
          );
        });
  }


  chooseGalleryAadhar() async {
    ImagePicker picker = ImagePicker();
    final aadharfile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      File img = File(aadharfile!.path);
      final bytes = img.readAsBytesSync();
      base64Image = base64Encode(bytes);
      if (base64Image != "") {
        isImagepicked = true;
      }
    });
  }

  chooseImageAadhar() async {
    ImagePicker picker = ImagePicker();
    final aadharfile = await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      File img = File(aadharfile!.path);
      final bytes = img.readAsBytesSync();
      base64Image = base64Encode(bytes);
      print("base64Image $base64Image");
      if (base64Image != "") {
        isImagepicked = true;
      }
    });
  }

  _onSubmit() {
    if(_bankformKey.currentState!.validate()){
      if(base64Image == '') {
        Get.snackbar('Input Warning', 'Please Pick Id Proof Front Image',margin: EdgeInsets.fromLTRB(10, 30, 10, 10),backgroundColor: Colors.blue);
      } else {
        Random ranint = Random();
        String SessionId = DateTime.now().millisecondsSinceEpoch.toString()+ranint.nextInt(10000000).toString();
        Map<String, dynamic> param = {
          'Regid':SessionManager.getString(Constants.PREF_IDNo),
          'accno':accountCtrl.text,
          'proftype':'BANK',
          'bank':bankCtrl.text,    // ID No
          'branch':branchCtrl.text,    // Back Image
          'ifscode':ifscCtrl.text,// Address
          'AccHolderName':'',
          'sesid':SessionId,//Select ID Type
          'filename':base64Image,
        };
        NetworkCalls().callPlanServer(Constants.apiUploadBankDetailsRequestUsr, param).then((value) {
          var data = jsonDecode(value!.body);
          if(data['Msg'] == Constants.success) {
            Get.back();
            Logger.ShowSuccessAlert('Success', 'Address Proof Uploaded Successfully');
          } else {
            Logger.ShowWorningAlert('Warning', 'Please Try Again After Some Time');
          }
        });
      }
    }
  }

  _getBankDetails() {
    if(Validator.ifscValidator(ifscCtrl.text)==null) {
      Map<String, dynamic> param = {
        'IFSC':ifscCtrl.text,
        'action':'GET',
      };
      NetworkCalls().callServer(Constants.apiBankDetails, param).then((value) {
        var data = jsonDecode(value!.body);
        if(data['Message'].toString().toUpperCase() == Constants.success) {
          bankCtrl.text = data['Bank'];
          branchCtrl.text = data['Branch'];
          addressCtrl.text = data['Address'];
          cityCtrl.text = data['City'];
          stateCtrl.text = data['State'];
          districtCtrl.text = data['District'];
          setState(() {
            isBank = false;
          });
        } else {
          bankCtrl.text = '';
          branchCtrl.text = '';
          addressCtrl.text = '';
          cityCtrl.text = '';
          stateCtrl.text = '';
          districtCtrl.text = '';
          setState(() {
            isBank = true;
          });
          Logger.ShowWorningAlert('Warning', 'Given IFSC Code is not available with us, Please enter your bank details below.');
        }
      });
    } else {
      Logger.ShowWorningAlert('Warning', 'Please Enter Valid IFSC Code');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Details'),),
      body: isLoading ? SingleChildScrollView(
        child: Form(
          key: _bankformKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: accountCtrl,
                    keyboardType: TextInputType.number,
                    enabled: isEnable,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    validator: (v) => Validator.inputValidate(v!),
                    maxLines: 1,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Account No ",
                        labelText: "Account No ",
                        labelStyle: const TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: ifscCtrl,
                    keyboardType: TextInputType.text,
                    enabled: isEnable,
                    maxLines: 1,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp(r'\s')),
                    ],
                    maxLength: 11,
                    validator: (v) => Validator.ifscValidator(v!),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "IFSC Code",
                        labelText: "IFSC Code",
                        labelStyle: const TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(onPressed: () => _getBankDetails(), child: const Text('Get Bank Details')),
                    const SizedBox(
                      height: 10,
                    ),
                  TextFormField(
                    controller: bankCtrl,
                    keyboardType: TextInputType.text,
                    enabled: isBank,
                    maxLines: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]+|\s')),
                    ],
                    validator: (v) => Validator.inputValidate(v!),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Bank Name",
                        labelText: "Bank Name",
                        labelStyle: TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: branchCtrl,
                    keyboardType: TextInputType.text,
                    enabled: isBank,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]+|\s')),
                    ],
                    maxLines: 1,
                    validator: (v) => Validator.inputValidate(v!),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Branch Name",
                        labelText: "Branch Name",
                        labelStyle: const TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: addressCtrl,
                    keyboardType: TextInputType.text,
                    enabled: isBank,
                    maxLines: 3,
                    validator: (v) => Validator.inputValidate(v!),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Address",
                        labelText: "Address",
                        labelStyle: const TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: cityCtrl,
                    keyboardType: TextInputType.text,
                    enabled: isBank,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]+|\s')),
                    ],
                    maxLines: 1,
                    validator: (v) => Validator.inputValidate(v!),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "City",
                        labelText: "City",
                        labelStyle: const TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: districtCtrl,
                    keyboardType: TextInputType.text,
                    enabled: isBank,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]+|\s')),
                    ],
                    maxLines: 1,
                    validator: (v) => Validator.inputValidate(v!),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "District",
                        labelText: "District",
                        labelStyle: const TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: stateCtrl,
                    keyboardType: TextInputType.text,
                    enabled: isBank,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-z]+|\s')),
                    ],
                    maxLines: 1,
                    validator: (v) => Validator.inputValidate(v!),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "State",
                        labelText: "State",
                        labelStyle: const TextStyle(color: Colors.black87)),
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
                          padding: EdgeInsets.only(left: 15, right: 0, top: 0, bottom: 5),
                          child:  Text(
                            "Upload Document",
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500),
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
                                _userChoice();
                              },
                            ),
                          ),
                          padding: const EdgeInsets.only(right: 0, top: 15, bottom: 6),
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
                  Visibility(visible: isEnable,child: ElevatedButton(onPressed: _onSubmit, child: const Text('Submit')))
                ],
              ),
            ),
          ),
        ),
      ) : const Center(),
    );
  }
}
