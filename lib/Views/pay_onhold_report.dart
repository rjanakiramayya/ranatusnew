import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:renatus/Models/my_referrals_model.dart';
import 'package:renatus/Models/pay_onhold_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';


class PayOnholdReport extends StatelessWidget {
  static const String routeName = '/PayOnholdReport';

  const PayOnholdReport ({Key? key}) : super(key: key);

  Future<List<OnholdReportModel>> callPayOnholdReport() async {
    List<OnholdReportModel> orderList = [];
    Map<String, dynamic> param = {
      'rtype': 'UserID',
      'id': SessionManager.getString(Constants.PREF_RegId),
    };
    orderList = await NetworkCalls()
        .callServer(Constants.apiOnholdReport, param)
        .then((value) {
      var data = jsonDecode(value!.body) as List;
      if(data.length > 0) {
        orderList.addAll(data.map((e) => OnholdReportModel.fromJson(e)));
        return orderList;
      } else {
        return [];
      }
    });
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnHold Report'),
      ),
      body: FutureBuilder(
        future: callPayOnholdReport(),
        builder: (ctx, AsyncSnapshot<List<OnholdReportModel>> data) {
          if (data.connectionState != ConnectionState.done) {
            return const Center(
              child: Text(''),
            );
          } else if (data.hasData) {
            return
              data.data!.length > 0 ?
              ListView.builder(
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
                          SubChildItem('Closing No', '${data.data![i].Payno!},${data.data![i].ClosingDate!}', false),
                          SubChildItem('Rank Name', data.data![i].DesgName!, false),
                          SubChildItem('Matched CC', '${double.parse(data.data![i].MatchedCC!).toStringAsFixed(2)}', false),
                          SubChildItem('Matching%', '${double.parse(data.data![i].MPer!).toStringAsFixed(2)}', false),
                          SubChildItem('Amount', '${double.parse(data.data![i].amt!).toStringAsFixed(2)}', false),
                          SubChildItem('Income Type', data.data![i].Status!, false),
                          SubChildItem('Remarks', data.data![i].remarks!, false),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: data.data!.length,
            ) : const Center(
                child: Text('No Orders Data Found...'),
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
