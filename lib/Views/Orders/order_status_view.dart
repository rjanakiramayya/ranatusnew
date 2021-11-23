
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Models/order_status_model.dart';

import '../main_view.dart';

class OredrStatusView extends StatelessWidget {
  static const String routeName = '/OrderStatusView';

  const OredrStatusView({Key? key}) : super(key: key);

  Future<bool> _onBackpress() async {
    Get.offAllNamed(MainView.routeName);
    return await true;
  }

  @override
  Widget build(BuildContext context) {
    OrderStatusModel res = Get.arguments as OrderStatusModel;
    return WillPopScope(
      onWillPop: _onBackpress,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Success'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _onBackpress,
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Your Order placed successfully with Order No: ${res.BillNo}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ),
        ),
      ),
    );
  }
}
