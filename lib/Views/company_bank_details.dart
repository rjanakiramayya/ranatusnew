
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:renatus/Models/company_bank_model.dart';
import 'package:renatus/Models/my_referrals_model.dart';
import 'package:renatus/Models/order_report_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Widgets/sub_child_item.dart';


class CompanyBankDetails extends StatelessWidget {
  static const String routeName = '/CompanyBankDetails';

  const CompanyBankDetails ({Key? key}) : super(key: key);

  Future<CompanyBankDetailsModel> callCompanyBankReport() async {
    CompanyBankDetailsModel orderList ;
    Map<String, dynamic> param = {
      'CBId': '',
    };
    orderList = await NetworkCalls()
        .callServer(Constants.apiCompanyBankRpt, param).then((value) {
      var data = jsonDecode(value!.body) ;
       orderList=CompanyBankDetailsModel.fromJson(data);
      return orderList;
    });
    return orderList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Bank Details'),
      ),
      body: FutureBuilder(
        future: callCompanyBankReport(),
        builder: (ctx, AsyncSnapshot<CompanyBankDetailsModel> data) {
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
                          SubChildItem('BankName', data.data!.CompanyBanks![i]!.Bank!, false),
                          SubChildItem('BranchName', data.data!.CompanyBanks![i]!.Branch!, false),
                          SubChildItem('AccountNo', data.data!.CompanyBanks![i]!.Accno!, false),
                          SubChildItem('IFSCCode', data.data!.CompanyBanks![i]!.IFSC!, false),
                          SubChildItem('State', data.data!.CompanyBanks![i]!.State!, false),
                          SubChildItem('City', data.data!.CompanyBanks![i]!.City!, false),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: data.data!.CompanyBanks!.length,
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
