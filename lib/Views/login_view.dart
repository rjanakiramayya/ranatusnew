import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/authcontroller.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/loaclpackageinfo.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';
import 'package:renatus/Views/forget_password_view.dart';

class LoginView extends StatefulWidget {
  static const String routeName = '/LoginView';

  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var authCtrl = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  late bool passwordVisible;
  late TextEditingController userIdCtrl, passwordCtrl;

  @override
  void initState() {

    super.initState();
    SessionManager.ClearAllPREF();
    passwordVisible = true;
    userIdCtrl = TextEditingController();
    userIdCtrl.text = 'Monadnaturals';
    passwordCtrl = TextEditingController();
    passwordCtrl.text = 'STAGINGSWRNTS21';
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      authCtrl.onLogin(userIdCtrl.text, passwordCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset(
                  '${Constants.iconPath}rlogo.png',
                  height: 150,
                ),
                const SizedBox(
                  height: Constants.spaceM,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        child: Image.asset(
                          '${Constants.imagePath}loginbg.png',
                         // height: Get.height - 198,
                          width: Get.width,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 45,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20),
                              child: TextFormField(
                                  controller: userIdCtrl,
                                  keyboardType: TextInputType.text,
                                  validator: (val) => Validator.idValidator(val!),
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
                                    hintText: 'User Name',
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20),
                              child: TextFormField(
                                controller: passwordCtrl,
                                keyboardType: TextInputType.text,
                                obscureText: passwordVisible,
                                validator: (val) =>
                                    Validator.passwordValidator(val!),
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(r'\s')
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  hintText: 'Password',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: Constants.spaceL,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Get.toNamed(ForgetPasswordView.routeName);
                                },
                                child: const Text(
                                  'Forgot Password ?',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: Constants.spaceM,
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
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: Constants.spaceL,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'New to Renatus? Create an account',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: Constants.spaceM,
                            ),
                            Text(
                              'Version: ${LocalPackageInfo.getVersion()}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
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
