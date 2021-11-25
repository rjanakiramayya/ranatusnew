import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Views/business_report_view.dart';
import 'package:renatus/Views/order_report_view.dart';

class MyDateFilter extends StatefulWidget {
  static const routeName = '/MyOrdersDateFilter';

  @override
  State<StatefulWidget> createState() {
    return _MyDateFilterState();
  }
}

class _MyDateFilterState extends State<MyDateFilter> {
  final GlobalKey<FormState> _formKey =  GlobalKey<FormState>();
  late int _groupValue;
  late String orderName;
  final myControllerpincode = TextEditingController();
  TextEditingController ondateController =  TextEditingController(text: '');
  TextEditingController todateController =  TextEditingController(text: '');
  TextEditingController FromDateController = TextEditingController(text: '');
  DateFormat format = DateFormat("MM-dd-yyyy");
  late Map<String, dynamic> args;
  late String Type;


  @override
  void initState() {
    super.initState();
    _groupValue =-1;
    args = Get.arguments as Map<String, dynamic>;
    Type = args['type'];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  Widget _myRadioButton({required String title,required int value}) {
    return RadioListTile<int>(
      value: value,
      groupValue: _groupValue,
      onChanged: (val)  {
        setState(() {
          _groupValue=val!;
        });
      },
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _callFinalFilter(from,to) {
      if(Type == 'Order Report Filter') {
        Map<String, dynamic> args = {
          'from':from,
          'to':to
        };
        Get.toNamed(OrderReportView.routeName,arguments: args);
      } else if(Type == 'Business Report Filter') {
        Map<String, dynamic> args = {
          'from':from,
          'to':to
        };
        Get.toNamed(BusinessReportView.routeName,arguments: args);
      }
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(Type),
      ),
      body:  SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 12, top: 10),
        child:  Form(
          key: _formKey,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _myRadioButton(
                        title: "All",
                        value: 0,
                      ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _myRadioButton(
                        title: "On Date",
                        value: 1,
                        ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, right: 2, top: 0),
                      child: DateTimeField(
                        controller: ondateController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.date_range,
                            color: Colors.red,
                          ),
                          labelText: 'On Date',
                          labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontFamily: 'Nunito'),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime.now(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _myRadioButton(
                      title: "From Date",
                      value: 2,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, right: 2, top: 0),
                      child: DateTimeField(
                        controller: FromDateController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.date_range,
                            color: Colors.red,
                          ),
                          labelText: 'From Date',
                          labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontFamily: 'Nunito'),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime.now(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Container()),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, right: 2, top: 0),
                      child: DateTimeField(
                        controller: todateController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.date_range,
                            color: Colors.red,
                          ),
                          labelText: 'To Date',
                          labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontFamily: 'Nunito'),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime.now(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: Get.width - 180,
                  height: 50.0,
                  child:  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius:  BorderRadius.circular(22.0),
                    ),
                    child:  const Text(
                      'SUBMIT',
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () async {
                      if (_groupValue == 0) {
                        var now =  DateTime.now();
                        var formatter =  DateFormat('MM-dd-yyyy');
                        String formattedDate = formatter.format(now);
                        _callFinalFilter("01-01-2000", formattedDate);
                      } else if (_groupValue == 1) {
                        if (ondateController.text.trim() == '') {
                          Logger.ShowWorningAlert('Warning', 'Select Date');
                        } else {
                          _callFinalFilter(ondateController.text, ondateController.text);
                        }
                      } else if (_groupValue == 2) {
                        if (FromDateController.text.trim() == '') {
                          Logger.ShowWorningAlert('Warning', 'Select From Date');
                        } else if (todateController.text.trim() == '') {
                          Logger.ShowWorningAlert('Warning', 'Select To Date');
                        } else {
                          _callFinalFilter(FromDateController.text, todateController.text);
                        }
                      } else {
                        Logger.ShowWorningAlert('Warning', 'Select Type');
                      }
                    },
                    color: Colors.green,
                  ),
                  margin: const EdgeInsets.only(top: 10.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
