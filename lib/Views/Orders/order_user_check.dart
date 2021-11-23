import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/cartcontroller.dart';
import 'package:renatus/Models/order_bill_address_model.dart';
import 'package:renatus/Models/order_products_model.dart';
import 'package:renatus/Models/statemodel.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';
import 'package:renatus/Views/Orders/order_products.dart';
import 'package:renatus/Widgets/sub_child_item.dart';
import 'package:renatus/Widgets/sub_header.dart';

class OrderUserCheck extends StatefulWidget {
  static const String routeName = '/OrderUserCheck';

  OrderUserCheck({Key? key}) : super(key: key);

  @override
  State<OrderUserCheck> createState() => _OrderUserCheckState();
}

class _OrderUserCheckState extends State<OrderUserCheck> {
  late ScrollController _controller;
  final _key = GlobalKey<FormState>();
  late TextEditingController userIdCtrl,nameCtrl,addressCtrl,cityCtrl,pincodeCtrl,mobileCtrl;
  late bool isBillAddressExist,isCheck;
  late OrderBillAddressModel billModel;
  late List<StateModel> staties,orginalStates;
  late int stateIndex;
  final _cartCtrl = Get.find<CartController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isBillAddressExist = false;
    isCheck = false;
    stateIndex = 0;
    billModel = OrderBillAddressModel();
    staties =[];
    orginalStates=[];
    staties.add(StateModel(Id:'0',Value: 'Select State'));
    _controller = ScrollController();
    userIdCtrl = TextEditingController();
    userIdCtrl.text = SessionManager.getString(Constants.PREF_IDNo);
    nameCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    cityCtrl = TextEditingController();
    pincodeCtrl = TextEditingController();
    mobileCtrl = TextEditingController();
  }

  void _checkUser() {
    if (userIdCtrl.text.trim() == '') {
      Logger.ShowWorningAlert('Waring', 'Enter Distributor IRD');
    } else {
      callUserCheck();
    }
  }

  void callUserCheck() {
    FocusScope.of(context).unfocus();
    Map<String, String> param = {
      'action': 'CheckCR_TrnNo',
      'Idno': userIdCtrl.text,
    };
    NetworkCalls().callServer(Constants.apiOrderUserCheck, param).then((value) {
      var data = jsonDecode(value!.body);
      if (data['Msg'].toString().toUpperCase() == Constants.success) {
        SessionManager.setString(Constants.PREF_OrderUserId, userIdCtrl.text);
        callOrderCheck();
      } else {
        Logger.ShowWorningAlert('Waring', data['Message']);
      }
    });
  }

  void callOrderCheck() {
    Map<String, String> param = {
      'action': 'OrderChk',
      'Idno': userIdCtrl.text,
    };
    NetworkCalls().callServer(Constants.apiOrderCheck, param).then((value) {
      var data = jsonDecode(value!.body);
     // if (data['Msg'].toString().toUpperCase() == Constants.success) {
      setState(() {
        billModel = OrderBillAddressModel.fromJson(data);
      });

        callStates();
     // } else {
      //  Logger.ShowWorningAlert('Waring', data['Message']);
     // }
    });
  }

  void callStates() {
    Map<String,dynamic> param = {
      'Action': 'GetStatesWithoutOthers',
    };
    NetworkCalls().callServer(Constants.apiStates, param).then((value) {
      var data = jsonDecode(value!.body) as List;
      orginalStates.add(StateModel(Id: '0', Value: 'Select State'));
      orginalStates.addAll(data.map((e) => StateModel.stateJson(e)));
      staties.clear();
      staties.addAll(orginalStates);
      setState(() {
        isBillAddressExist=true;
      });
    });
  }

  void _callGetShipping() {
    setState(() {
      nameCtrl.text = billModel.Name!;
      addressCtrl.text = billModel.Address!;
      cityCtrl.text = billModel.City!;
      pincodeCtrl.text = billModel.PinCode!;
      //mobileCtrl.text = billModel!.Mobile!;
      staties.clear();
      stateIndex = 0;
      staties.add(StateModel(Id: billModel.StateId!, Value: billModel.StateName!));
    });
  }

  void _callClearShipping() {
    setState(() {
      nameCtrl.text = '';
      addressCtrl.text = '';
      cityCtrl.text = '';
      pincodeCtrl.text = '';
      mobileCtrl.text = '';
      staties.clear();
      stateIndex = 0;
      staties.addAll(orginalStates);
    });
  }

  void _validate() {
    if(_key.currentState!.validate()){
      if(staties[stateIndex].Id!='0') {
        callOrderProducts();
      } else {
        Logger.ShowWorningAlert('Warning', 'Please Select State.');
      }
    }
  }

  void callOrderProducts() {
    Map<String,dynamic> param = {
      'Action':'',
      'Fcode':'',
      'ID':SessionManager.getString(Constants.PREF_OrderUserId),
    };
    NetworkCalls().callServer(Constants.apiGetOrderProducts, param).then((value) {
      var data = jsonDecode(value!.body);
      OrderProductsModel productsModel = OrderProductsModel.fromJson(data);
      if(productsModel.OrderProducts!.length>0) {
        SessionManager.setString(Constants.PREF_ShipName, nameCtrl.text);
        SessionManager.setString(Constants.PREF_ShipAddress, addressCtrl.text);
        SessionManager.setString(Constants.PREF_ShipCity, cityCtrl.text);
        SessionManager.setString(Constants.PREF_ShipPincode, pincodeCtrl.text);
        SessionManager.setString(Constants.PREF_ShipStateId, staties[stateIndex].Id);
        SessionManager.setString(Constants.PREF_ShipStateName, staties[stateIndex].Value);
        SessionManager.setString(Constants.PREF_ShipMobile, mobileCtrl.text);
        Map<String, dynamic> args = {
          'name':nameCtrl.text,
          'address':addressCtrl.text,
          'city':cityCtrl.text,
          'pincode':pincodeCtrl.text,
          'stateId':staties[stateIndex].Id,
          'stateName':staties[stateIndex].Value,
          'mobile':mobileCtrl.text,
          'products':productsModel.OrderProducts,
        };
        SessionManager.setString(Constants.PREF_OrderCartUUID, '');
        SessionManager.setString(Constants.PREF_OrderCartSSID, '');
        SessionManager.setInt(Constants.PREF_OpenCartCount, 0);
        _cartCtrl.count=0;
        Get.toNamed(OrderProducts.routeName,arguments: args);
      } else {
        Logger.ShowWorningAlert('Waring', 'Products Not Available');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Now'),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _key,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: userIdCtrl,
                  keyboardType: TextInputType.text,
                  validator: (val) => Validator.idValidator(val!),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.deny(r'\s')],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: 'Enter Distributor IRD',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: !isBillAddressExist,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.green),
                    width: 150,
                    height: 50,
                    child: TextButton(
                      onPressed: () => _checkUser(),
                      child: const Text(
                        'Check',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: isBillAddressExist,
                  child: Column(
                    children: [
                      isBillAddressExist ?
                      Card(
                        child: Column(
                          children: [
                            const SubHeader('Billing Address'),
                            SubChildItem('Name', billModel.Name??'', true),
                            SubChildItem('Address', billModel.Address??'', true),
                            SubChildItem('State', billModel.StateName??'', true),
                            SubChildItem('City', billModel.City??'', true),
                            SubChildItem('Pin code', billModel.PinCode??'', true),
                            SubChildItem('Mobile No', billModel.Mobile??'', true),
                          ],
                        ),
                      ) : const Center() ,
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: isCheck,
                              onChanged: (va) {
                                setState(() {
                                  isCheck = !isCheck;
                                  if (isCheck) {
                                    _callGetShipping();
                                  } else {
                                    _callClearShipping();
                                  }
                                });
                              }),
                         const SizedBox(
                            width: 5,
                          ),
                         const Text('Same As Billing Address.'),
                        ],
                      ),
                      const SubHeader('Shipping Address'),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: nameCtrl,
                        keyboardType: TextInputType.text,
                        validator: (val) => Validator.idValidator(val!),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: 'Enter Name',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: addressCtrl,
                        keyboardType: TextInputType.text,
                        validator: (val) => Validator.idValidator(val!),
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: 'Enter Address',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
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
                                staties[stateIndex].Value,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15.0,
                                    fontFamily: 'Nunito'),
                              ),
                              items: staties.map((StateModel map) {
                                return DropdownMenuItem<StateModel>(
                                  value: map,
                                  child:  Text(
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
                                  stateIndex = staties.indexOf(value!);
                                });
                              }),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: cityCtrl,
                        keyboardType: TextInputType.text,
                        validator: (val) => Validator.inputValidate(val!),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: 'Enter City',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: pincodeCtrl,
                        keyboardType: TextInputType.number,
                        validator: (val) => Validator.pinCodeValidator(val!),
                        maxLength: 6,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: 'Enter Pin Code',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: mobileCtrl,
                        keyboardType: TextInputType.phone,
                        validator: (val) => Validator.mobileValidator(val!),
                        textInputAction: TextInputAction.done,
                        maxLength: 10,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: 'Enter Mobile No',
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.green),
                        width: 150,
                        height: 50,
                        child: TextButton(
                          onPressed: () => _validate(),
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

