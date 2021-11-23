import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Models/order_report_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';

class OrderReportView extends StatelessWidget {
  static const String routeName = '/OrderReportView';

  const OrderReportView({Key? key}) : super(key: key);

  Future<List<OrderReportModel>> callOrderReport(
      String? from, String? to) async {
    List<OrderReportModel> orderList = [];
    Map<String, dynamic> param = {
      'rtype': 'MEMBER',
      'Id': SessionManager.getString(Constants.PREF_RegId),
      'fromdate': from,
      'todate': to,
      'reptype': '0',
    };
    orderList = await NetworkCalls()
        .callServer(Constants.apiRepurchaseOrderRpt, param)
        .then((value) {
      var data = jsonDecode(value!.body) as List;
      orderList.addAll(data.map((e) => OrderReportModel.fromJson(e)));
      return orderList;
    });
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Report'),
      ),
      body: FutureBuilder(
        future: callOrderReport(args['from'], args['to']),
        builder: (ctx, AsyncSnapshot<List<OrderReportModel>> data) {
          if (data.connectionState != ConnectionState.done) {
            return const Center(
              child: Text(''),
            );
          } else if (data.hasData) {
            return ListView.builder(
              itemBuilder: (ctx, i) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SubChildItem('Sno', '${i+1}', false),
                          InkWell(onTap:(){},child: SubChildItem('Order No', data.data![i].BillNo!, false,Colors.blue)),
                          InkWell(onTap: (){},child: SubChildItem('Invoice No', data.data![i].InvNo!, false,Colors.blue)),
                          SubChildItem('Quantity', data.data![i].TotQty!, false),
                          SubChildItem('Amount', data.data![i].TotAmt!, false),
                          SubChildItem('CC', data.data![i].TotBV!, false),
                          SubChildItem('Order Date', data.data![i].OrdDate!, false),
                          SubChildItem('Confirm Date', data.data![i].BillDate!, false),
                          SubChildItem('Disp Details', data.data![i].DispDetails!, false),
                          SubChildItem('Disp By', data.data![i].DispBy!, false),
                          SubChildItem('Disp Remarks', data.data![i].DispRemarks!, false),
                          SubChildItem('Status', data.data![i].OrdStatus!, false),
                          SubChildItem('Purchase Type', data.data![i].RepType!, false),
                          SubChildItem('Disp Mode', data.data![i].DispMode!, false),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: data.data!.length,
            );
          } else {
            return const Center(
              child: Text('No Orders Data Found...'),
            );
          }
        },
      ),
    );
  }
}
