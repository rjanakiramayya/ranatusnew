import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Models/order_report_model.dart';
import 'package:renatus/Models/tabular_report_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Views/tabular_count_view.dart';
import 'package:renatus/Widgets/sub_child_item.dart';

class TabularGenealogy extends StatelessWidget {
  static const String routeName = '/TabularGenealogy';

  const TabularGenealogy({Key? key}) : super(key: key);

  Future<List<TabularGenealogyModel>> callTabularReport() async {
    List<TabularGenealogyModel> orderList = [];
    Map<String, dynamic> param = {
      'Action': 'LvlCount',
      'IDNo': SessionManager.getString(Constants.PREF_IDNo),
      'LevelNo': "0",

    };
    orderList = await NetworkCalls()
        .callServer(Constants.apiTabularGenealogyOrderRpt, param)
        .then((value) {
      var data = jsonDecode(value!.body) as List;
      orderList.addAll(data.map((e) => TabularGenealogyModel.fromJson(e)));
      return orderList;
    });
    return orderList;
  }

  void _onSelectCount(String Levelno) {
   // Logger.log(Levelno);
    Map<String, dynamic> args = {

      'LevelNo': Levelno,

    };
    Get.toNamed(TabularCountView.routeName,arguments: args);

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabular Genealogy'),
      ),

      body:
      FutureBuilder(
        future: callTabularReport(),
        builder: (ctx, AsyncSnapshot<List<TabularGenealogyModel>> data) {
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
                          InkWell(onTap:(){},child: SubChildItem('Level No', data.data![i].LevelNo!, false,)),
                          InkWell(onTap: ()=>_onSelectCount(data.data![i].LevelNo!),child: SubChildItem('Level Count',data.data![i].LevelCount!, false,Colors.blue)),
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
