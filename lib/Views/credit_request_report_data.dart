import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:renatus/Models/credit_request_report_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';

class CreditRequestReportData extends StatelessWidget {
  static const String routeName = '/CreditRequestReportData';

  const CreditRequestReportData({Key? key}) : super(key: key);

  Future<List<CreditRequestReportModel>> callCreditRequestReportRpt() async {
    List<CreditRequestReportModel> orderList = [];
    var now = DateTime.now();
    var formatter = DateFormat('MM-dd-yyyy');
    String formattedDate = formatter.format(now);
    Map<String, dynamic> param = {
      'Action': 'Member',
      'Fromdate': '01-01-2015',
      'Todate': formattedDate,
      'id': SessionManager.getString(Constants.PREF_RegId),
    };
    orderList = await NetworkCalls()
        .callServer(Constants.apiCreditRequestReport, param)
        .then((value) {
      var data = jsonDecode(value!.body) as List;
      orderList.addAll(data.map((e) => CreditRequestReportModel.fromJson(e)));
      return orderList;
    });
    Logger.log("tt" + orderList.length.toString());
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Request Report'),
      ),
      body: FutureBuilder(
        future: callCreditRequestReportRpt(),
        builder: (ctx, AsyncSnapshot<List<CreditRequestReportModel>> data) {
          if (data.connectionState!= ConnectionState.done) {
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
                          SubChildItem('Sno','${i + 1}', false),
                          SubChildItem('Request Code', data.data![i].ReqCode!, false),
                          SubChildItem('Request Amount',data.data![i].ReqAmt!, false),
                          SubChildItem('Bank Deposit Details',data.data![i].bank!, false),
                          SubChildItem('Deposit Slip', data.data![i].depslip!, false),
                          SubChildItem('Request Date', data.data![i].Reqdate!, false),
                          SubChildItem('Updated Date', data.data![i].Updated!, false),
                          SubChildItem('Distributor IRD Remarks',data.data![i].UserRemarks!, false),
                          SubChildItem('Admin Remarks', data.data![i].Remarks!, false),
                          SubChildItem('Request Status', data.data![i].Sts!, false),
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
