import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Views/login_view.dart';
import 'package:renatus/Widgets/sub_child_item.dart';

class RegistrationStausView extends StatelessWidget {
  static const String routeName = '/RegistrationStausView';

  const RegistrationStausView({Key? key}) : super(key: key);

  Future<bool> _onBackpress() async {
    //Constants.fromProductDisplay = false;
    Get.offAllNamed(LoginView.routeName);
    return await true;
  }

  @override
  Widget build(BuildContext context) {
    var res = Get.arguments as Map<String, dynamic>;
    return WillPopScope(
      onWillPop: _onBackpress,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registration Success'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _onBackpress,
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    res['Message'],
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
                const SizedBox(height: 25,),
               // SubChildItem('User ID', res['Idno'], true),
                //const SizedBox(height: 10,),
               // SubChildItem('User Password', res['LPwd'], true),
                ElevatedButton(onPressed: () => _onBackpress(), child: const Text('Login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}