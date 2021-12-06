import 'dart:core';

class Validator {

  static String? passwordValidator(String val) {
    RegExp reg = RegExp(r'([A-Za-z][0-9])');
    if(val.isEmpty){
      return 'Please Enter Password';
    } else if(val.length<4 || val.length>15) {
      return 'Password Should be Between 4 to 15 Characters';
   // } else if(!reg.hasMatch(val)) {
    //  return 'Password Should Contain Characters And Numbers';
    }else {
      return null;
    }
  }

  static String? idValidator(String val) {
    RegExp reg = RegExp(r'([0-9a-zA-Z])');
    if(val.isEmpty){
      return 'Please Enter User Id';
    } else if(val.length<5) {
      return 'Please Enter Valid User Id';
    } else if(!reg.hasMatch(val)) {
      return 'Please Enter Valid User Id';
    }else {
      return null;
    }
  }

  static bool dobValidate(DateTime date,DateTime now) {
    if (((now.difference(date).inDays) / 365.floor()) > 18) {
      return true;
    } else {
      return false;
    }
  }

  static String? pinCodeValidator(String pin) {
    if (pin.length == 6) {
      return null;
    } else {
      return "Please Enter Valid Pincode";
    }
  }

  static String? userValidator(String user) {
    RegExp reg = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,16}$');
    if(reg.hasMatch(user)) {
      return null;
    } else {
      return 'Enter Valid User Id';
    }
  }

  static String? panCardValidator(String val) {
    RegExp reg = RegExp(r'([A-Za-z]{5}[0-9]{4}[A-Za-z]{1})');
    if(val.isEmpty){
      return 'Please Enter Pan Number';
    } if(!reg.hasMatch(val)) {
      return 'Please Enter Valid Pan Number';
    }else {
      return null;
    }
  }

  static String? mobileValidator(String mobile) {
   RegExp reg = RegExp(r'(^[9876]\d{9}$)');
   if (reg.hasMatch(mobile)) {
    return null;
   } else {
    return 'Enter Valid Mobile Number';
   }
  }

  static String? emailValidator(String email) {
   RegExp reg = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
   if (reg.hasMatch(email)) {
    return null;
   } else {
    return "Enter Valid Email Id";
   }
  }

  static String? gstValidator(String gst) {
    RegExp reg = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    if (reg.hasMatch(gst)) {
      return null;
    } else {
      return "Enter Valid GST NO";
    }
  }

  static String? ifscValidator(String ifsc) {
    RegExp reg = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if(reg.hasMatch(ifsc)) {
      return null;
    } else {
      return 'Enter Valid IFSC Code';
    }
  }

  static String? amountValidator(String amount) {
    if(amount.isEmpty){
      return 'Please Enter Amount';
    } if(int.parse(amount) < 0) {
      return 'Please Enter Positive Amount';
    }else {
      return null;
    }
  }

  static String? inputValidate(String amount) {
    if(amount.isEmpty || amount == ""){
      return 'Please Enter This Field';
    } else if(amount.length < 1) {
      return 'Please Enter Valid Input';
    } else {
      return null;
    }
  }

  static String? idProofValidate(String amount) {
    if(amount.isEmpty || amount == ""){
      return 'Please Enter This Field';
    } else if(amount.length < 6) {
      return 'Please Enter Valid Input';
    } else {
      return null;
    }
  }

  static String? aadharValidate(String no) {
    if(no.isEmpty || no == ""){
      return 'Please Enter Aadhar No';
    } else if(no.length < 12) {
      return 'Please Enter Valid No';
    } else {
      return null;
    }
  }

  static String? noValidate(String n) {
      return null;
  }
}
