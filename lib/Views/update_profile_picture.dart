import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';


class UpdateProfilePicture extends StatefulWidget {
  static const String routeName = '/UpdateProfilePicture';

  const UpdateProfilePicture({Key? key}) : super(key: key);
  @override
  _UpdateProfilePictureState createState() => _UpdateProfilePictureState();
}

class _UpdateProfilePictureState extends State<UpdateProfilePicture> {
  String base64Image = '';
  bool isImagepicked = false;
  var bytes;

  void onSubmitclick() {
    _userChoice();
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
    var aadharfile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      File img = File(aadharfile!.path);
      bytes = img.readAsBytesSync();
      base64Image = base64Encode(bytes);
      if (base64Image != "") {
        isImagepicked = true;
      }
    });
  }

  chooseImageAadhar() async {
    ImagePicker picker = ImagePicker();
    var aadharfile = await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      File img = File(aadharfile!.path);
      bytes = img.readAsBytesSync();
      base64Image = base64Encode(bytes);
      print("base64Image $base64Image");
      if (base64Image != "") {
        isImagepicked = true;
      }
    });
  }

  void onUpdatePic() async {
    Random ranint = Random();
    String SessionId = DateTime.now().millisecondsSinceEpoch.toString() +
        ranint.nextInt(100000).toString();
    Map<String, String> param = {
      "regid":SessionManager.getString(Constants.PREF_RegId),
      "filename":base64Image,
      "sesid":SessionId,
    };
    NetworkCalls().callPlanServer(Constants.apiMemberPhotoRequest, param).then((value){
      var data = jsonDecode(value!.body);
      if(data['Msg'] == Constants.success) {
        Get.snackbar('Success', 'Profile Updated Updated Successfully',margin: EdgeInsets.fromLTRB(10, 30, 10, 10),backgroundColor: Colors.blue);
      } else {
        Get.snackbar('Warning', 'Please Try Again After Some Time',margin: EdgeInsets.fromLTRB(10, 30, 10, 10),backgroundColor: Colors.blue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Update'),),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: Get.width,
        child: Column(
          children: <Widget>[
           const SizedBox(
              height: 10,
            ),
            isImagepicked
                ? Container(
              width: 190.0,
              height: 190.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.memory(
                  base64Decode(base64Image),
                  width: 190.0,
                  height: 190.0,
                  fit: BoxFit.fill,
                ),
              ),
            )
                : SessionManager.getString(Constants.PREF_profilePic) == null
                ? Center()
                : Container(
              width: 190.0,
              height: 190.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  SessionManager.getString(Constants.PREF_profilePic),
                  width: 190.0,
                  height: 190.0,
                  fit: BoxFit.fill,
                  errorBuilder: (ctx, url, error) {
                    return Image.asset(
                      '${Constants.imagePath}No_Product.png',
                      width: 190.0,
                      height: 190.0,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            isImagepicked
                ? ElevatedButton(onPressed: onUpdatePic, child: const Text('UPDATE PROFILE PICTURE'))
                : ElevatedButton(child:const Text('CHANGE PROFILE PICTURE'),onPressed : onSubmitclick),
          ],
        ),
      ),
    );
  }
}
