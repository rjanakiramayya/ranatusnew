import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:renatus/Models/profile_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';
import 'package:renatus/Views/web_view.dart';

class PanDetailsView extends StatefulWidget {
  static const String routeName = '/PanDetailsView';

  const PanDetailsView({Key? key}) : super(key: key);

  @override
  _PanDetailsViewState createState() => _PanDetailsViewState();
}

class _PanDetailsViewState extends State<PanDetailsView> {
  late TextEditingController panNumber;
  late bool isLoading, isEnable;
  String base64Image = '';
  bool isImagepicked = false;
  final _panformKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    panNumber = TextEditingController();
    isEnable = true;
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
      'regid': SessionManager.getString(Constants.PREF_RegId),
    };
    NetworkCalls().callServer(Constants.apiMemberProfile, param).then((value) {
      var data = jsonDecode(value!.body);
      ProfileModel _profileModel = ProfileModel.fromJson(data);
      panNumber.text = _profileModel.MemberProfile![0]!.Panno!;
      setState(() {
        isLoading = true;
        isEnable = false;
      });
    }).catchError((_) {
      EasyLoading.showToast(Constants.somethingWrong);
    });
  }

  void getKycImage() {
    Map<String, dynamic> param = {
      'regid': SessionManager.getString(Constants.PREF_RegId),
      "tblname": "MemberKYC",
      "stscolumn": "KYCImg",
      "kyctype": "PAN"
    };
    NetworkCalls().callServer(Constants.apiMemberUploads, param).then((value) {
      var data = jsonDecode(value!.body);
      String img = data['Mphoto'];
      Map<String, String> args = {
        'title': 'Pancard Image',
        'url': '${Constants.panUrl}${img}',
      };
      Get.toNamed(FWebView.routeName, arguments: args);
    }).catchError((_) {
      EasyLoading.showToast(Constants.somethingWrong);
    });
  }

  Future _userChoice() async {
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
    var aadharfile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
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
    var aadharfile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
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

  _onSubmit() {
    if (_panformKey.currentState!.validate()) {
      if (base64Image == '') {
        Get.snackbar('Input Warning', 'Please Pick Id Proof Front Image',
            margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
            backgroundColor: Colors.blue);
      } else {
        Random ranint = Random();
        String SessionId = DateTime.now().millisecondsSinceEpoch.toString() +
            ranint.nextInt(100000).toString();
        Map<String, dynamic> param = {
          'Regid': SessionManager.getString(Constants.PREF_RegId),
          'accno': '',
          'proftype': 'PAN',
          'bank': panNumber.text, // ID No
          'branch': '', // Back Image
          'ifscode': '', // Address
          'AccHolderName': '',
          'sesid': SessionId, //Select ID Type
          'filename': base64Image,
        };
        NetworkCalls()
            .callPlanServer(Constants.apiUploadBankDetailsRequestUsr, param)
            .then((value) {
          var data = jsonDecode(value!.body);
          if (data['Msg'].toString().toUpperCase() == Constants.success) {
            Get.back();
            Get.snackbar('Success', 'PAN Uploaded Successfully',
                margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                backgroundColor: Colors.green);
          } else {
            Get.snackbar('Warning', 'Please Try Again After Some Time',
                margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
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
        title: const Text('Pan Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _panformKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    controller: panNumber,
                    keyboardType: TextInputType.text,
                    enabled: isEnable,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp(r'\s')),
                    ],
                    maxLines: 1,
                    maxLength: 10,
                    validator: (v) => Validator.panCardValidator(v!),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black87),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "PAN No ",
                      labelText: "PAN No ",
                    ),
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
                          "Upload Pan",
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
                              _userChoice();
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
                        child: Text('PAN Card Image'),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextButton(
                          child: const Text('View'),
                          onPressed: () => getKycImage(),
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
