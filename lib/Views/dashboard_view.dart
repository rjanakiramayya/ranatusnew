import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/dashboardcontroller.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Widgets/sub_child_item.dart';
import 'package:renatus/Widgets/sub_header.dart';

class DashboardView extends StatelessWidget {
  static const String routeName = '/DashboardView';

  DashboardView({Key? key}) : super(key: key);
  final _dashboardCtrl = Get.put(DashboardController());
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Obx(
        () {
          return _dashboardCtrl.isLoading.value
              ? const Center()
              : _dashboardCtrl.isError.value
                  ? const Center(
                      child: Text('No Data Found...'),
                    )
                  : SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: _dashboardCtrl.model.Profiledetals![0]!.ProfilePic ?? '',
                      height: 100,
                      width: 100,
                      placeholder: (context, url) => const SizedBox(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image:
                          DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      errorWidget: (context, url, error) => SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset('${Constants.imagePath}No_Product.png'),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        children: [
                          const SubHeader('My Profile'),
                          SubChildItem('User Name', _dashboardCtrl.model.Profiledetals![0]!.Name!, true),
                          SubChildItem(
                              'Date Of Reg.', _dashboardCtrl.model.Profiledetals![0]!.joindate!, true),
                          SubChildItem('Date Of Activation',
                              _dashboardCtrl.model.Profiledetals![0]!.stsdate!, true),
                          SubChildItem(
                              'Status', _dashboardCtrl.model.Profiledetals![0]!.mstatus!, true),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        children: [
                          const SubHeader('Rank Status'),
                          SubChildItem('Current Rank', _dashboardCtrl.model.Profiledetals![0]!.RankName!, true),
                          SubChildItem(
                              'Data Sync Upto', _dashboardCtrl.model.Profiledetals![0]!.ProcessedUpto!, true),
                          SubChildItem('Highest Achieved Rank',
                              _dashboardCtrl.model.Profiledetals![0]!.AccumulativeRank!, true),
                          SubChildItem(
                              'Last Closing Rank', _dashboardCtrl.model.Profiledetals![0]!.LastClosingRank!, true),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        children: [
                          const SubHeader('KYC Status'),
                          SubChildItem('Bank', _dashboardCtrl.model.Profiledetals![0]!.banksts!, true),
                          SubChildItem(
                              'PAN', _dashboardCtrl.model.Profiledetals![0]!.pansts!, true),
                          SubChildItem('GST No',
                              _dashboardCtrl.model.Profiledetals![0]!.GSTStatus!, true),
                          SubChildItem(
                              'ID Proof', _dashboardCtrl.model.Profiledetals![0]!.IDProofSts!, true),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        children: [
                          const SubHeader('TURNOVER %'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('${_dashboardCtrl.model.Profiledetals![0]!.PackageName!}'),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 70,
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange),
                                height: 50,
                                child: Center(
                                  child: Text(
                                    '${double.parse(_dashboardCtrl.model.Profiledetals![0]!.EWalletBalance!).toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Positioned(
                                top: -15,
                                left: 10,
                                child: SizedBox(
                                  height: 30,
                                  child: Card(
                                    elevation: 5,
                                    child: Center(child: Text('  Wallet Bal  ')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 70,
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue),
                                height: 50,
                                child: Center(
                                  child: Text(
                                    '${double.parse(_dashboardCtrl.model.Profiledetals![0]!.NetAmt!).toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Positioned(
                                top: -15,
                                left: 10,
                                child: SizedBox(
                                  height: 30,
                                  child: Card(
                                    elevation: 5,
                                    child: Center(
                                        child: Text('  My Income  ')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 70,
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.cyan),
                                height: 50,
                                child: Center(
                                  child: Text(
                                    '${double.parse(_dashboardCtrl.model.Profiledetals![0]!.sprcnt!).toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Positioned(
                                top: -15,
                                left: 10,
                                child: SizedBox(
                                  height: 30,
                                  child: Card(
                                    elevation: 5,
                                    child: Center(
                                        child: Text('  My Directs  ')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _dashboardCtrl.model.memberDetals!.length>0 ?
                      Column(
                        children: [
                          const SubHeader('Live Statistics'),
                          const SizedBox(height: 10,),
                          Align(alignment: Alignment.topLeft,child: Text('${_dashboardCtrl.model.memberDetals![0]!.Team}',style: const TextStyle(fontWeight: FontWeight.bold),)),
                          const SizedBox(height: 10,),
                          Align(alignment: Alignment.topLeft,child: Text('${_dashboardCtrl.model.memberDetals![1]!.Team}',style: const TextStyle(fontWeight: FontWeight.bold),)),
                          const SizedBox(height: 10,),
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1.8),
                              1: FlexColumnWidth(4),
                              2: FlexColumnWidth(4),
                            },
                            border: TableBorder.all(color: Colors.black),
                            children: [
                              TableRow(children: [
                                const TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Center(child: Text('')),
                                ),
                                TableCell(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height:25,
                                        child: Center(child: Text('Today')),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: const Center(child: Text('Team 1')))),
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: const Center(child: Text('Team 2')))),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                TableCell(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height:25,
                                        child: Center(child: Text('Closing')),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: const Center(child: Text('Team 1')))),
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: const Center(child: Text('Team 2')))),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ]
                              ),
                              TableRow(
                                  children: [
                                    const TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Center(child: Text('Pending')),
                                    ),
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![0]!.TDPendingCnt!}')))),
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![1]!.TDPendingCnt!}')))),
                                        ],
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![0]!.CCPendingCnt!}')))),
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![1]!.CCPendingCnt!}')))),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                              TableRow(
                                  children: [
                                    const TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Center(child: Text('Active')),
                                    ),
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![0]!.TDActiveCnt!}')))),
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![1]!.TDActiveCnt!}')))),
                                        ],
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![0]!.CCActiveCnt!}')))),
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![1]!.CCActiveCnt!}')))),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                              TableRow(
                                  children: [
                                    const TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Center(child: Text('CC')),
                                    ),
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![0]!.TDCC!}')))),
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![1]!.TDCC!}')))),
                                        ],
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![0]!.CCCC!}')))),
                                          Expanded(flex:1,child: Container(decoration:BoxDecoration(border: Border.all(color: Colors.black)),height:30,child: Center(child: Text('${_dashboardCtrl.model.memberDetals![1]!.CCCC!}')))),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ],
                          ),
                        ],
                      ) : const Center(),

                  const SizedBox(height: 10,)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
