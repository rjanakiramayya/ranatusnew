import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/cartcontroller.dart';
import 'package:renatus/Models/order_status_model.dart';
import 'package:renatus/Models/statemodel.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:renatus/Views/Orders/order_status_view.dart';

class CheckOutView extends StatefulWidget {
  static const String routeName = '/CheckOutView';

  const CheckOutView({Key? key}) : super(key: key);

  @override
  _CheckOutViewState createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  late List<StateModel> dispatchList;
  late List<StateModel> paymentModeList;
  final cartCtrl = Get.find<CartController>();
  late int dispatchIndex, paymentModeIndex;
  late double courierCharges, walletBalance;
  late bool isCourier, isWallet, isTrans;
  late TextEditingController tranCtrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isCourier = false;
    isWallet = false;
    isTrans = false;
    dispatchIndex = 0;
    paymentModeIndex = 0;
    courierCharges = 0.0;
    walletBalance = 0.0;
    dispatchList = [];
    paymentModeList = [];
    tranCtrl = TextEditingController();
    dispatchList.add(StateModel(Id: '0', Value: 'Select Mode of Dispatch'));
    dispatchList.add(StateModel(Id: 'By Courier', Value: 'By Courier'));
    dispatchList.add(StateModel(Id: 'By Hand', Value: 'By Hand'));
    paymentModeList.add(StateModel(Id: '0', Value: 'Select Mode of Payment'));
    paymentModeList.add(StateModel(Id: 'E-Wallet', Value: 'EWALLET'));
  }

  callCourierCharges() {
    Map<String, dynamic> param = {
      'mod': 'By Courier',
      'regid': SessionManager.getString(Constants.PREF_RegId),
      'amt': cartCtrl.tottalWeight,
    };
    NetworkCalls().callServer(Constants.apiGetModeDetails, param).then((value) {
      var data = jsonDecode(value!.body);
      if (data[0]['msg'].toString().toUpperCase() == Constants.success) {
        setState(() {
          courierCharges = double.parse(data[0]['chgs'].toString());
          isCourier = true;
        });
      } else {
        Logger.ShowWorningAlert('Warning', data['msg'].toString());
      }
    });
  }

  callWalletBalance() {
    Map<String, dynamic> param = {
      'action': 'Member',
      'Idno': SessionManager.getString(Constants.PREF_RegId),
    };
    NetworkCalls()
        .callServer(Constants.apiEwalletBalanceUsr, param)
        .then((value) {
      var data = jsonDecode(value!.body);
      if (data['Msg'].toString().toUpperCase() == Constants.success) {
        setState(() {
          walletBalance = double.parse(data['Balance']);
          isWallet = true;
        });
      } else {
        Logger.ShowWorningAlert('Warning', data['Message'].toString());
      }
    });
  }

  callFinalOrder() {
    Map<String, dynamic> param = {
      'RegID': SessionManager.getString(Constants.PREF_RegId),
      'FCode': 'SP001',
      'Sesid': SessionManager.getString(Constants.PREF_OrderCartSSID),
      'UQID': SessionManager.getString(Constants.PREF_OrderCartUUID),
      'Mop': paymentModeList[paymentModeIndex].Id,
      'MopNo': SessionManager.getString(Constants.PREF_OrderUserId),
      'DwnIdno': SessionManager.getString(Constants.PREF_OrderUserId),
      "Billby":"MEMBER",
      'DispMode': dispatchList[dispatchIndex].Id,
      'ShipName': SessionManager.getString(Constants.PREF_ShipName),
      'ShipAddress': SessionManager.getString(Constants.PREF_ShipAddress),
      'ShipCity': SessionManager.getString(Constants.PREF_ShipCity),
      'ShipState': SessionManager.getString(Constants.PREF_ShipStateId),
      'ShipPincode': SessionManager.getString(Constants.PREF_ShipPincode),
      'ShipMobile': SessionManager.getString(Constants.PREF_ShipMobile),
      'OTP': tranCtrl.text,
    };
    NetworkCalls()
        .callServer(Constants.apiInsRepurchaseOrder, param)
        .then((value) {
      var data = jsonDecode(value!.body);
      if(data['Msg'].toString().toUpperCase()==Constants.success) {
        OrderStatusModel model = OrderStatusModel.fromJson(data);
        Get.toNamed(OredrStatusView.routeName,arguments: model);
      } else {
        Logger.ShowWorningAlert('Warning', data['Message']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              width: Get.width,
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Billing Address',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '  ${SessionManager.getString(Constants.PREF_ShipName)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '  ${SessionManager.getString(Constants.PREF_ShipMobile)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '  ${SessionManager.getString(Constants.PREF_ShipCity)} - ${SessionManager.getString(Constants.PREF_ShipPincode)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        )),
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
            Container(
              padding: const EdgeInsets.all(5),
              width: Get.width,
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width / 2 - 10,
                          child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              ' Order Total',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 2 - 10,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              ' ${cartCtrl.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    isCourier
                        ? Row(
                            children: [
                              SizedBox(
                                width: Get.width / 2 - 10,
                                child: const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    ' Courier Charges',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width / 2 - 10,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    ' ${courierCharges.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : const Center(),
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width / 2 - 10,
                          child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              ' Total CC',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 2 - 10,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              ' ${cartCtrl.totalCC.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width / 2 - 10,
                          child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              ' Grand Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 2 - 10,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              ' ${(cartCtrl.totalAmount + courierCharges).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.black38,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<StateModel>(
                    iconEnabledColor: Colors.black,
                    isExpanded: true,
                    hint: Text(
                      dispatchList[dispatchIndex].Value,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontFamily: 'Nunito'),
                    ),
                    items: dispatchList.map((StateModel map) {
                      return DropdownMenuItem<StateModel>(
                        value: map,
                        child: Text(
                          map.Value,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dispatchIndex = dispatchList.indexOf(value!);
                        if (value.Id == 'By Courier') {
                          callCourierCharges();
                        } else {
                          setState(() {
                            courierCharges = 0.0;
                            isCourier = false;
                          });
                        }
                      });
                    }),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.black38,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<StateModel>(
                    iconEnabledColor: Colors.black,
                    isExpanded: true,
                    hint: Text(
                      paymentModeList[paymentModeIndex].Value,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontFamily: 'Nunito'),
                    ),
                    items: paymentModeList.map((StateModel map) {
                      return DropdownMenuItem<StateModel>(
                        value: map,
                        child: Text(
                          map.Value,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        paymentModeIndex = paymentModeList.indexOf(value!);
                      });
                      if (paymentModeIndex != 0) {
                        callWalletBalance();
                      } else {
                        setState(() {
                          isWallet = false;
                          walletBalance = 0.0;
                        });
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            isWallet
                ? Row(
                    children: [
                      SizedBox(
                        width: Get.width / 2 - 10,
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '   Wallet Amount',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width / 2 - 10,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            ' ${walletBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : const Center(),
            const SizedBox(height: 10,),
            isWallet
                ? walletBalance <= (cartCtrl.totalAmount + walletBalance)
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: tranCtrl,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: 'Enter Transaction Password',
                          ),
                          onChanged: (val){
                            setState(() {
                              if(val.length>1){
                                isTrans = true;
                              } else {
                                isTrans = false;
                              }
                            });
                          },
                        ),
                    )
                    : const Text(
                        'Insufficient Funds',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )
                : const Center(),
              isTrans ?
                  Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.green),
                  width: 150,
                  child: TextButton(
                    onPressed: () => callFinalOrder(),
                    child: const Text(
                      'Order',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ),
              ) : const Center()
          ],
        ),
      ),
    );
  }
}
