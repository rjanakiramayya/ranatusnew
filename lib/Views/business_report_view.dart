import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Models/business_report_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';

class BusinessReportView extends StatelessWidget {
  static const String routeName = '/BusinessReportView';
  const BusinessReportView({Key? key}) : super(key: key);

  Future<List<BusinessReportModel>> callBusinessReport(String from,String to) async {
    List<BusinessReportModel> report = [];
    Map<String,dynamic> param = {
      'regid':SessionManager.getString(Constants.PREF_RegId),
      'purtype':'',
      'fromdate':from,
      'todate':to,
      'Action':'Monthly',
    };
    report = await NetworkCalls().callServer(Constants.apiBusinessReport, param).then((value) {
      var data = jsonDecode(value!.body) as List;
      report.addAll(data.map((e) => BusinessReportModel.fromJson(e)));
      return report;
    });
    return report;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    return FutureBuilder(
      future: callBusinessReport(args['from'], args['to']),
      builder: (context, AsyncSnapshot<List<BusinessReportModel>> snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return  Scaffold(
            appBar: AppBar(title:  const Text("Business Report"),),
            body:  Container(),
          );
        } else if (snapshot.hasData) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Business Report"),
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "Self Business",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Group Business",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            children: [
                              const SubChildItem("S.No", "1", false),
                              SubChildItem(
                                "Distributor ID",
                                snapshot.data?[0].Idno ?? '',
                                false,
                              ),
                              SubChildItem(
                                "Name",
                                snapshot.data?[0].Name ?? '',
                                false,
                              ),
                              SubChildItem(
                                "Status",
                                snapshot.data?[0].Status ?? '',
                                false,
                              ),
                              SubChildItem(
                                "City Name",
                                snapshot.data?[0].CityName ?? '',
                                false,
                              ),
                              SubChildItem(
                                "State Name",
                                snapshot.data?[0].StateName ?? '',
                                false,
                              ),

                              SubChildItem(
                                "Join Date",
                                snapshot.data?[0].JoinDate ?? '',
                                false,
                              ),
                              SubChildItem(
                                "Activation Date",
                                snapshot.data?[0].ActDate ?? '',
                                false,
                              ),
                              SubChildItem(
                                "Self CC",
                                double.parse( snapshot.data?[0].SelfJBV ?? '0.00').toStringAsFixed(0),
                                false,
                              ),
                              SubChildItem(
                                "Downline CC",
                                double.parse(snapshot.data?[0].DownJBV ?? '0.00').toStringAsFixed(0),
                                false,
                              ),
                              SubChildItem(
                                "Total CC",
                                double.parse(snapshot.data?[0].TotJBV ?? '0.00').toStringAsFixed(0),
                                false,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  snapshot.data!.length>1 ?
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: snapshot.data!.length - 1,
                    itemBuilder: (BuildContext context, int i) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              SubChildItem("Team", '${snapshot.data?[i+1].Purchase}${snapshot.data?[i+1].RNo}', false),
                              SubChildItem(
                                "Distributor ID",
                                snapshot.data?[i+1].Idno ?? '',
                                false,
                              ),
                              SubChildItem(
                                "Name",
                                snapshot.data?[i+1].Name ?? '',
                                false,
                              ),
                              SubChildItem(
                                "Status",
                                snapshot.data?[i+1].Status ?? '',
                                false,
                              ),
                              SubChildItem(
                                "City Name",
                                snapshot.data?[i+1].CityName ?? '',
                                false,
                              ),
                              SubChildItem(
                                "State Name",
                                snapshot.data?[i+1].StateName ?? '',
                                false,
                              ),
                              SubChildItem(
                                "Join Date",
                                snapshot.data?[i+1].JoinDate ?? '',
                                false,
                              ),
                              SubChildItem(
                                "Activation Date",
                                snapshot.data?[i+1].ActDate ?? '',
                                false,
                              ),
                              SubChildItem(
                                "Self CC",
                                double.parse( snapshot.data?[i+1].SelfJBV ?? '0.00').toStringAsFixed(0),
                                false,
                              ),
                              SubChildItem(
                                "Downline CC",
                                double.parse(snapshot.data?[i+1].DownJBV ?? '0.00').toStringAsFixed(0),
                                false,
                              ),
                              SubChildItem(
                                "Total CC",
                                double.parse(snapshot.data?[i+1].TotJBV ?? '0.00').toStringAsFixed(0),
                                false,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ) : const Center(child: Text(Constants.NODATAFOUND),),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('No Orders Data Found...'),
          );
        }
      }
    );
  }
}
