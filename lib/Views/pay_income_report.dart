import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:renatus/Models/pay_income_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';


class PayIncomeReport extends StatelessWidget {
  static const String routeName = '/PayIncomeReport';

  const PayIncomeReport ({Key? key}) : super(key: key);

  Future<List<IncomeReportModel>> callPayIncomeReport() async {
    List<IncomeReportModel> orderList = [];
    Map<String, dynamic> param = {
      'rtype': 'MEMID',
      'id': SessionManager.getString(Constants.PREF_RegId),
    };
    orderList = await NetworkCalls()
        .callServer(Constants.apiIncomeReport, param)
        .then((value) {
      var data = jsonDecode(value!.body) as List;
      if(data.length > 0) {
      orderList.addAll(data.map((e) => IncomeReportModel.fromJson(e)));
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
        title: const Text('Income Report'),
      ),
      body: FutureBuilder(
        future: callPayIncomeReport(),
        builder: (ctx, AsyncSnapshot<List<IncomeReportModel>> data) {
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
                          SubChildItem('Closing No', '${data.data?[i].PayNo},${data.data?[i].SchFrom}-${data.data?[i].SchTo}', false,Colors.blue),
                          SubChildItem('Rank Name', data.data?[i].RankName ?? '', false),
                          SubChildItem('Matched CC', '${double.parse(data.data![i].Epairs!).toStringAsFixed(2)}', false,Colors.blue),
                          SubChildItem('Matching Bonus%', '${double.parse(data.data![i].Mper!).toStringAsFixed(2)}', false),
                          SubChildItem('DTT Bonus(CC)', '${double.parse(data.data![i].BlncAmt!).toStringAsFixed(2)}', false),
                          SubChildItem('DTT ProRateBonus(CC)', '${double.parse(data.data![i].GBACC!).toStringAsFixed(2)}', false),
                          SubChildItem('Final DTTBonus(CC)', '${double.parse(data.data![i].FinalTotalCC!).toStringAsFixed(2)}', false),
                          SubChildItem('GA Bonus(CC)', '${double.parse(data.data![i].GBACC!).toStringAsFixed(2)}', false,Colors.blue),
                          SubChildItem('GA ProRateBonus(CC)', '${double.parse(data.data![i].GBADedCC!).toStringAsFixed(2)}', false),
                          SubChildItem('Final GABonus (CC)', '${double.parse(data.data![i].GBACC!).toStringAsFixed(2)}', false),
                          SubChildItem('TotalCC', '${double.parse(data.data![i].TotalCC!).toStringAsFixed(2)}', false),
                          SubChildItem('BFAmount', '${double.parse(data.data![i].BFAmt!).toStringAsFixed(2)}', false,Colors.blue),
                          SubChildItem('GrossAmount', '${double.parse(data.data![i].GrAmt!).toStringAsFixed(2)}', false),
                          SubChildItem('TDS','${double.parse(data.data![i].TDS!).toStringAsFixed(2)}', false),
                          SubChildItem('Other Deductions', '${double.parse(data.data![i].AdvDed !).toStringAsFixed(2)}', false),
                          SubChildItem('Net Amount','${double.parse(data.data![i].NetAmt!).toStringAsFixed(2)}', false),
                          SubChildItem('TDB Status', data.data![i].TDBEligible!, false),
                          SubChildItem('Payment Status', data.data![i].PaymentStatus!, false),
                          SubChildItem('Payment Date', data.data![i].PaymentDate!, false),
                          SubChildItem('Trn RefNo', data.data![i].TrnRefNo!, false),
                          SubChildItem('Remarks', data.data![i].Remarks!, false),
                          SubChildItem('Bank', data.data![i].Bank!, false),
                          SubChildItem('Account No', data.data![i].Accno!, false),
                          SubChildItem('Branch', data.data![i].Branch!, false),
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
