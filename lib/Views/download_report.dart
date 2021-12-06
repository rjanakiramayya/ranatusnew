import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:renatus/Models/download_report_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadReportView extends StatefulWidget {
  static const String routeName = '/DownloadReportView';
  const DownloadReportView({Key? key}) : super(key: key);

  @override
  State<DownloadReportView> createState() => _DownloadReportViewState();
}

class _DownloadReportViewState extends State<DownloadReportView> {
  Future<List<DownloadReportModel>> callDownloadReport() async {
    List<DownloadReportModel> orderList = [];
    Map<String, dynamic> param = {
      'Action': 'USER',
    };
    orderList = await NetworkCalls()
        .callServer(Constants.apiDownloads, param).then((value) {
      var data = jsonDecode(value!.body) as List;
      orderList.addAll(data.map((e) => DownloadReportModel.fromJson(e)));
      return orderList;
    });
    return orderList;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Download Report'),),
      body: FutureBuilder(
          future: callDownloadReport(),
          builder: (ctx, AsyncSnapshot<List<DownloadReportModel>> data) {
            if (data.connectionState != ConnectionState.done) {
              return const Center(
                child: Text(''),
              );
            } else if (data.hasData) {
              return ListView.builder(itemBuilder: (ctx, i) {
                return Container(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(data.data![i].Subject!),
                                  IconButton(
                                      icon: const Icon(Icons.arrow_right_alt),
                                      onPressed: () async {
                                        Logger.log(Uri.parse("https://renatuswellness.net/fileUpload/DownloadManager/"+data.data![i].FileName!).toString());
                                        await canLaunch(Uri.parse("https://renatuswellness.net/fileUpload/DownloadManager/"+data.data![i].FileName!).toString())
                                            ? await launch(Uri.parse("https://renatuswellness.net/fileUpload/DownloadManager/"+data.data![i].FileName!).toString())
                                            : throw 'Could not launch ${data.data![i].FileName!}';
                                      }),
                                ]
                            )
                          ]
                      ),
                    ),
                  ),
                );
              }, itemCount: data.data!.length,);
            } else{
              return const Center(child: Text('No Data Found'),);
            }
          }
      ),

    );
  }
}
