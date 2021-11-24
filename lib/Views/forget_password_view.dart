
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/authcontroller.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/validator.dart';


class ForgetPasswordView extends StatefulWidget {
  static const String routeName = '/ForgetPasswordView';

  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  _ForgetPasswordViewState createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  var authCtrl = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController userIdCtrl,passwordCtrl;

  @override
  void initState() {
    super.initState();
    userIdCtrl = TextEditingController();

  }

  _validate() {
    if(_formKey.currentState!.validate()) {
      authCtrl.onForgotPassword(userIdCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
          width: Get.width,
          height: Get.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('${Constants.iconPath}rlogo.png'),
                const SizedBox(height: 15,),
                TextFormField(
                  controller: userIdCtrl,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                   BlacklistingTextInputFormatter(RegExp(r'\s')),
                  ],
                  validator: (val) =>
                      Validator.passwordValidator(val!),
                  decoration: const InputDecoration(
                      labelText: 'Enter User Id',
                      suffixIcon: Icon(Icons.person)),
                ),

                const SizedBox(height: 25,),
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
      ),
    );
  }
}
