import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:renatus/Models/scheme_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';


class SchemeOfferStatus extends StatelessWidget {
  static  String routeName = '/SchemeOfferStatus';
  late Map<String, dynamic> args;

  SchemeOfferStatus ({Key? key}) : super(key: key);

  Future<List<SchemeOfferModel>> callPayOnholdReport() async {
    List<SchemeOfferModel> orderList = [];
    Map<String, dynamic> param = {
      'Action':'MEMBER',
      'Regid': SessionManager.getString(Constants.PREF_RegId),
      'SchNo': args['text'],
    };
    orderList = await NetworkCalls()
        .callServer(Constants.apischemeofferstatus, param)
        .then((value) {
      var data = jsonDecode(value!.body);
      List data1 = data['SchemeandOfferStatus_OPt']  as List;
      orderList.addAll(data1.map((e) => SchemeOfferModel.fromJson(e)));
      return orderList;
    });
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    args = Get.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheme and Offer Status'),
      ),
      body: FutureBuilder(
        future: callPayOnholdReport(),
        builder: (ctx, AsyncSnapshot<List<SchemeOfferModel>> data) {
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
                          SubChildItem('Sno', '${i+1}', true),
                          SubChildItem('Scheme Name', data.data![i].SchemeName!, true),
                          SubChildItem('Scheme Description', data.data![i].SchemeDescr!, true),
                          SubChildItem('Left CC','${double.parse(data.data![i].LeftCC!).toStringAsFixed(2)}', true),
                          SubChildItem('Right CC', '${double.parse(data.data![i].RightCC!).toStringAsFixed(2)}', true),
                          SubChildItem('Actual Left CC', '${double.parse(data.data![i].actualleftcc!).toStringAsFixed(2)}', true),
                          SubChildItem('Actual Right CC', '${double.parse(data.data![i].actualrightcc!).toStringAsFixed(2)}', true),
                          SubChildItem('Required Left CC', '${double.parse(data.data![i].requiredleftcc!).toStringAsFixed(2)}', true),
                          SubChildItem('Required Right CC','${double.parse(data.data![i].requiredrightcc!).toStringAsFixed(2)}', true),
                          SubChildItem('Status', data.data![i].Status!, true),
                          SubChildItem('Claim Now', data.data![i].ProcessedUptoDate!, false),
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
