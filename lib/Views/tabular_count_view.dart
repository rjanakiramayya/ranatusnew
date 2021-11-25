import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Models/order_report_model.dart';
import 'package:renatus/Models/tabular_count_model.dart';
import 'package:renatus/Models/tabular_report_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';

class TabularCountView extends StatelessWidget {
  static const String routeName = '/TabularCountView';

  const TabularCountView({Key? key}) : super(key: key);

  Future<List<TabularCountModel>> callTabularReport(String Levelno) async {
    List<TabularCountModel> orderList = [];
    Map<String, dynamic> param = {
      'Action': 'Report',
      'IDNo': SessionManager.getString(Constants.PREF_IDNo),
      'LevelNo': Levelno,
    };
    orderList = await NetworkCalls()
        .callServer(Constants.apiTabularCountViewRpt, param)
        .then((value) {
      var data = jsonDecode(value!.body) as List;
      orderList.addAll(data.map((e) => TabularCountModel.fromJson(e)));
      return orderList;

    });
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args=Get.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabular Genealogy'),
      ),
      body: FutureBuilder(
        future: callTabularReport(args['LevelNo']),
        builder: (ctx, AsyncSnapshot<List<TabularCountModel>> data) {
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
                          SubChildItem('IDNo', data.data![i].IDNo!, false),
                          SubChildItem('Name', data.data![i].Name!, false),
                          SubChildItem('City', data.data![i].City!, false),
                          SubChildItem('State', data.data![i].State!, false),
                          SubChildItem('DOJ', data.data![i].DOJ!, false),
                          SubChildItem('Sponsor', data.data![i].Sponsor!, false),
                          SubChildItem('Sponsorname', data.data![i].Sponsorname!, false),
                          SubChildItem('status', data.data![i].status!, false),
                          SubChildItem('Msg', data.data![i].Msg!, false),

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
