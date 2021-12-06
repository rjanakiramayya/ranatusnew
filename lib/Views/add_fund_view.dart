import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:renatus/Models/add_fund_input_model.dart';
import 'package:renatus/Models/statemodel.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/loaclpackageinfo.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Utils/validator.dart';
import 'package:renatus/Views/add_fund_pre_view.dart';
import 'package:renatus/Widgets/adaptive_flat_button.dart';

class AddFundView extends StatefulWidget {
  static const String routeName = '/AddFundView';

  const AddFundView({Key? key}) : super(key: key);

  @override
  _AddFundViewState createState() => _AddFundViewState();
}

class _AddFundViewState extends State<AddFundView> {
  var _formKey = GlobalKey<FormState>();
  late TextEditingController amountCtrl,
      tranIdCtrl,
      remarkCtrl,
      balanceCtrl,
      dateCtrl,
      cityCtrl,
      mobileCtrl,
      nameCtrl;
  late int mopIndex, cbankIndex, bankIndex, stateIndex, cardIndex;
  late List<StateModel> staties, CardTypes;
  late List<AddFundInpurModelGetDropDownpayout> mop;
  late List<AddFundInpurModelCompanyBanks> banks;
  late String date, base64Image = '', sindex;
  DateFormat format = DateFormat("yyyy-MM-dd");
  late DateTime pikeddateg;
  late bool isImagepicked = false, isonline, isLoad, isOnline;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amountCtrl = TextEditingController();
    tranIdCtrl = TextEditingController();
    remarkCtrl = TextEditingController();
    balanceCtrl = TextEditingController();
    dateCtrl = TextEditingController();
    cityCtrl = TextEditingController();
    mobileCtrl = TextEditingController();
    nameCtrl = TextEditingController();
    mopIndex = 0;
    cbankIndex = 0;
    bankIndex = 0;
    stateIndex = 0;
    cardIndex = 0;
    date = 'Select Date';
    isonline = true;
    isLoad = true;
    isOnline = false;
    sindex = '0';
    mop = [];
    staties = [];
    CardTypes = [];
    banks = [];
    staties.add(StateModel(Id: 'Select State', Value: '0'));
    mop.add(AddFundInpurModelGetDropDownpayout(
        Text: 'Select Mode Of Payment', Value: '-1'));
    banks.add(
        AddFundInpurModelCompanyBanks(CBId: '-1', Bank: 'Select Deposit Bank'));
    CardTypes.add(StateModel(Id: 'Selected', Value: 'Select Payment Mode'));
    CardTypes.add(StateModel(Id: 'creditcard', Value: 'Credit Card'));
    CardTypes.add(StateModel(Id: 'debitcard', Value: 'Debit Card'));
    CardTypes.add(StateModel(Id: 'netbanking', Value: 'Net Banking'));
    CardTypes.add(StateModel(Id: 'upi', Value: 'UPI'));
    callInputs();
    Future.delayed(Duration.zero).then((value) {});
  }

  void callInputs() {
    Map<String, dynamic> param = {
      "id": SessionManager.getString(Constants.PREF_RegId)
    };
    NetworkCalls()
        .callServer(Constants.apiCreditRequestddl, param)
        .then((value) {
      var data = jsonDecode(value!.body);
      if (data['Msg'].toString().toUpperCase() == 'SUCC') {
        AddFundInpurModel model = AddFundInpurModel.fromJson(data);
        staties.addAll(model.GetDropDownstateout!.map((e) => e!));
        mop.addAll(model.GetDropDownpayout!.map((e) => e!));
        banks.addAll(model.CompanyBanks!.map((e) => e!));
        balanceCtrl.text = model.Balance!;
        setState(() {
          isLoad = false;
        });
      } else {
        Logger.ShowWorningAlert('Warning', data['Message']);
      }
    });
  }

  _onSubmit() {
    if (mopIndex == 0) {
      Logger.ShowWorningAlert('Warning', 'Please Select Mode Of Payment.');
    } else if (isOnline) {
      if (cardIndex == 0) {
        Logger.ShowWorningAlert('Warning', 'Please Select Payment Type.');
      } else {
        _gotoNext();
      }
    } else {
      if (_formKey.currentState!.validate()) {
        if (cbankIndex == 0) {
          Logger.ShowWorningAlert('Warning', 'Please Select Deposit Bank.');
        } else if (stateIndex == 0) {
          Logger.ShowWorningAlert('Warning', 'Please Select State.');
        } else if (date == 'Select Date') {
          Logger.ShowWorningAlert('Warning', 'Please pick Diposit Date');
        } else if (base64Image == '') {
          Logger.ShowWorningAlert('Warning', 'Please pick Diposit Slip');
        } else {
          _gotoNext();
        }
      }
    }

    // if(sindex=='1') {
    //
    // } else if(sindex=='2') {
    //
    // } else if(sindex=='3') {
    //
    // } else if(sindex=='4') {
    //
    // } else if(sindex=='5') {
    //
    // } else if(sindex=='6') {
    //
    // } else if(sindex=='7') {
    //
    // }
  }

  _gotoNext() {
    Random ranint = Random();
    String SessionId = DateTime.now().millisecondsSinceEpoch.toString() +
        ranint.nextInt(100000).toString();
    Map<String, dynamic> args = {
      'Action': 'Insert',
      'UserType': 'Member',
      'RP': amountCtrl.text,
      'MOP': mop[mopIndex].Text,
      'BankName': banks[cbankIndex].CBId,
      'Branch': sindex == '1' ? nameCtrl.text : '',
      'City': cityCtrl.text,
      'DOPDATE': date,
      'AdminRemarks': staties[stateIndex].Value,
      'Status': '0',
      'ReqID': SessionManager.getString(Constants.PREF_RegId),
      'UpdatedBy': SessionManager.getString(Constants.PREF_RegId),
      'Remarks': remarkCtrl.text,
      'OutAmt': '0',
      'ReqCode': '',
      'sessionid': SessionId,
      'DEPNAME': sindex != '1' ? nameCtrl.text : '',
      'DEPNO': tranIdCtrl.text,
      'DEPMOBILE': mobileCtrl.text,
      'MOPid': mop[mopIndex].Value,
      'FileName': base64Image,
      'balance':balanceCtrl.text,
      'statename':staties[stateIndex].Id,
    };
    Get.toNamed(AddFundPreView.routeName,arguments: args);
  }

  Future _userChoice() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select '),
            children: <Widget>[
              RaisedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
                color: Colors.white,
                elevation: 0,
                onPressed: () {
                  chooseImageAadhar();
                },
              ),
              const Divider(
                color: Colors.black,
              ),
              RaisedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
                color: Colors.white,
                elevation: 0,
                onPressed: () {
                  chooseGalleryAadhar();
                },
              ),
            ],
          );
        });
  }

  chooseGalleryAadhar() async {
    ImagePicker picker = ImagePicker();
    var aadharfile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      File img = File(aadharfile!.path);
      final bytes = img.readAsBytesSync();
      base64Image = base64Encode(bytes);
      if (base64Image != "") {
        isImagepicked = true;
      }
    });
  }

  chooseImageAadhar() async {
    ImagePicker picker = ImagePicker();
    var aadharfile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      File img = File(aadharfile!.path);
      final bytes = img.readAsBytesSync();
      base64Image = base64Encode(bytes);
      print("base64Image $base64Image");
      if (base64Image != "") {
        isImagepicked = true;
      }
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        pikeddateg = pickedDate;
        date = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fund Request'),
      ),
      body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: balanceCtrl,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Wallet Balance ",
                          labelText: "Wallet Balance ",
                          labelStyle: TextStyle(color: Colors.black87)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      maxLines: 1,
                      validator: (v) => Validator.amountValidator(v!),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Request Amount ",
                          labelText: "Request Amount ",
                          labelStyle: TextStyle(color: Colors.black87)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(
                          color: Colors.black38,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child:
                            DropdownButton<AddFundInpurModelGetDropDownpayout>(
                                iconEnabledColor: Colors.black,
                                isExpanded: true,
                                hint: Text(
                                  mop[mopIndex].Text ?? '',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontFamily: 'Nunito'),
                                ),
                                items: mop.map(
                                    (AddFundInpurModelGetDropDownpayout map) {
                                  return DropdownMenuItem<
                                      AddFundInpurModelGetDropDownpayout>(
                                    value: map,
                                    child: Text(
                                      map.Text ?? '',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    mopIndex = mop.indexOf(value!);
                                    setState(() {
                                      if (value!.Value == '7') {
                                        isOnline = true;
                                        sindex = value!.Value!;
                                      } else {
                                        isOnline = false;
                                        sindex = value!.Value!;
                                      }
                                    });
                                  });
                                }),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: !isOnline,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(
                            color: Colors.black38,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<AddFundInpurModelCompanyBanks>(
                              iconEnabledColor: Colors.black,
                              isExpanded: true,
                              hint: Text(
                                banks[cbankIndex].Bank ?? '',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: 'Nunito'),
                              ),
                              items: banks
                                  .map((AddFundInpurModelCompanyBanks map) {
                                return DropdownMenuItem<
                                    AddFundInpurModelCompanyBanks>(
                                  value: map,
                                  child: Text(
                                    map.Bank ?? '',
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  cbankIndex = banks.indexOf(value!);
                                });
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: !isOnline,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 55,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('${date}'),
                            ),
                            FlatButton(
                              textColor: Color(0xff020f72),
                              child: const Text(
                                'Pick Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () => _presentDatePicker(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IgnorePointer(
                      ignoring: sindex != '1',
                      child: Visibility(
                        visible: sindex == '1',
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: nameCtrl,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              validator: (v) => Validator.inputValidate(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: " Branch Code ",
                                  labelText: "Branch Code ",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: tranIdCtrl,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              validator: (v) => Validator.inputValidate(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: " Reconciliation reference ",
                                  labelText: "Reconciliation reference ",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IgnorePointer(
                      ignoring: sindex != '2',
                      child: Visibility(
                        visible: sindex == '2',
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: nameCtrl,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              validator: (v) => Validator.inputValidate(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: " Depositor Name ",
                                  labelText: "Depositor Name ",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: mobileCtrl,
                              keyboardType: TextInputType.phone,
                              maxLines: 1,
                              maxLength: 10,
                              validator: (v) => Validator.mobileValidator(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: " Depositor Mobile ",
                                  labelText: "Depositor Mobile ",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: sindex != '3',
                      child: Visibility(
                        visible: sindex == '3',
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: tranIdCtrl,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              validator: (v) => Validator.inputValidate(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Transaction ID/ UPI/ UTR",
                                  labelText: "Transaction ID/ UPI/ UTR",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: sindex != '4',
                      child: Visibility(
                        visible: sindex == '4',
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: tranIdCtrl,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              maxLength: 10,
                              validator: (v) => Validator.inputValidate(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Transaction No",
                                  labelText: "Transaction No",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: nameCtrl,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              validator: (v) => Validator.inputValidate(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText:
                                      "Name of the person who done by NEFT",
                                  labelText:
                                      "Name of the person who done by NEFT",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: sindex != '5',
                      child: Visibility(
                        visible: sindex == '5',
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: tranIdCtrl,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              validator: (v) => Validator.inputValidate(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Reference No",
                                  labelText: "Reference No",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: mobileCtrl,
                              keyboardType: TextInputType.phone,
                              maxLines: 1,
                              maxLength: 10,
                              validator: (v) => Validator.mobileValidator(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Mobile No",
                                  labelText: "Mobile No",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: sindex != '6',
                      child: Visibility(
                        visible: sindex == '6',
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: tranIdCtrl,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              validator: (v) => Validator.inputValidate(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Account No",
                                  labelText: "Account No",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: nameCtrl,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              validator: (v) => Validator.inputValidate(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Account Holder Name",
                                  labelText: "Account Holder Name",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: mobileCtrl,
                              keyboardType: TextInputType.phone,
                              maxLines: 1,
                              maxLength: 10,
                              validator: (v) => Validator.mobileValidator(v!),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Account Holder Mobile No",
                                  labelText: "Account Holder Mobile No",
                                  labelStyle: TextStyle(color: Colors.black87)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isOnline,
                      child: TextFormField(
                        controller: cityCtrl,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        inputFormatters: [
                          BlacklistingTextInputFormatter(RegExp(r'\s'))
                        ],
                        validator: (v) => Validator.inputValidate(v!),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black87),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Enter City",
                            labelText: "Enter City",
                            labelStyle: const TextStyle(color: Colors.black87)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: !isOnline,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(
                            color: Colors.black38,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<StateModel>(
                              iconEnabledColor: Colors.black,
                              isExpanded: true,
                              hint: Text(
                                staties[stateIndex].Id,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: 'Nunito'),
                              ),
                              items: staties.map((StateModel map) {
                                return DropdownMenuItem<StateModel>(
                                  value: map,
                                  child: Text(
                                    map.Id,
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: isOnline,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(
                            color: Colors.black38,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<StateModel>(
                              iconEnabledColor: Colors.black,
                              isExpanded: true,
                              hint: Text(
                                CardTypes[cardIndex].Value ?? '',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: 'Nunito'),
                              ),
                              items: CardTypes.map((StateModel map) {
                                return DropdownMenuItem<StateModel>(
                                  value: map,
                                  child: Text(
                                    map.Value ?? '',
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  cardIndex = CardTypes.indexOf(value!);
                                });
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: remarkCtrl,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      validator: (v) => Validator.inputValidate(v!),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black87),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Enter Remarks ",
                          labelText: "Enter Remarks ",
                          labelStyle: const TextStyle(color: Colors.black87)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: !isOnline,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 0, top: 0, bottom: 5),
                            child: Container(
                              child: const Text(
                                "Upload Diposit Slip",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Padding(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 36,
                                ),
                                onPressed: () {
                                  _userChoice();
                                },
                              ),
                            ),
                            padding: const EdgeInsets.only(
                                right: 0, top: 15, bottom: 6),
                          ),
                          Padding(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Visibility(
                                visible: isImagepicked,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.assignment_turned_in,
                                    size: 22,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    //print("dhdhduy");
                                  },
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 0, top: 15),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: _onSubmit, child: const Text('Preview')),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
                ),
              ),
            ),
    );
  }
}
