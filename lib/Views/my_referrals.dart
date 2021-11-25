
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:renatus/Models/my_referrals_model.dart';
import 'package:renatus/Models/order_report_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';


class MyReferralsPage extends StatelessWidget {
  static const String routeName = '/MyReferralsPage';

  const MyReferralsPage ({Key? key}) : super(key: key);

  Future<List<MyReferralsModel>> callMyReferralReport() async {
    List<MyReferralsModel> orderList = [];
  Map<String, dynamic> param = {
    'regid': SessionManager.getString(Constants.PREF_RegId),

  };
    orderList = await NetworkCalls()
        .callServer(Constants.apiMyReferralsViewRpt, param)
        .then((value) {
      var data = jsonDecode(value!.body) as List;
      orderList.addAll(data.map((e) => MyReferralsModel.fromJson(e)));
      return orderList;
    });
    return orderList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Referrals'),
      ),
      body: FutureBuilder(
        future: callMyReferralReport(),
        builder: (ctx, AsyncSnapshot<List<MyReferralsModel>> data) {
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
                          SubChildItem('DistributorIRD', data.data![i].Idno!, false),
                          SubChildItem('DistributorName', data.data![i].Name!, false),
                          SubChildItem('State', data.data![i].StateName!, false),
                          SubChildItem('City', data.data![i].CityName!, false),
                          SubChildItem('Mobile', data.data![i].Mobile!, false),
                          SubChildItem('Date', data.data![i].JoinDate!, false),
                          SubChildItem('Status', data.data![i].Mstatus!, false),
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
