import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:renatus/Models/my_referrals_model.dart';
import 'package:renatus/Models/order_report_model.dart';
import 'package:renatus/Models/wallet_summary_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';

class WalletTransferData extends StatelessWidget {
  static const String routeName = '/WalletTransferData';

  const WalletTransferData({Key? key}) : super(key: key);

  Future<List<EwalletSummaryRptModel>> callEwalletSummaryRpt() async {
    var now = DateTime.now();
    var formatter = DateFormat('MM-dd-yyyy');
    String formattedDate = formatter.format(now);
    List<EwalletSummaryRptModel> orderList = [];
    Map<String, dynamic> param = {
      'Action': 'IdSummary_Member',
      'frmdate': '01-01-2000',
      'todate': formattedDate,
      'id': SessionManager.getString(Constants.PREF_RegId),
    };
    orderList = await NetworkCalls()
        .callServer(Constants.apiWalletSummary, param)
        .then((value) {
      var data = jsonDecode(value!.body);
      List data1 = data['EwalletSummaryRpt'] as List;
      orderList.addAll(data1.map((e) => EwalletSummaryRptModel.fromJson(e)));
      return orderList;
    });
    Logger.log("ttt" + orderList.length.toString());
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Summary'),
      ),
      body: FutureBuilder(
        future: callEwalletSummaryRpt(),
        builder: (ctx, AsyncSnapshot<List<EwalletSummaryRptModel>> data) {
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
                          SubChildItem('Sno', '${i + 1}', false),
                          SubChildItem(
                              'TransactionDate', data.data![i].dated!, false),
                          SubChildItem('Credit', data.data![i].InAmt!, false),
                          SubChildItem('Debit', data.data![i].OutAmt!, false),
                          SubChildItem(
                              'Balance', data.data![i].Balance!, false),
                          SubChildItem(
                              'Remarks', data.data![i].remarks!, false),
                          SubChildItem(
                              'Description', data.data![i].descr!, false),
                          SubChildItem(
                              'CreditRequestID', data.data![i].RegId!, false),
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
