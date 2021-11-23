import 'dart:convert';
import 'dart:math';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:get/get.dart';
import 'package:renatus/Models/cart_item_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/network_calls.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Views/Orders/cart_view.dart';

class CartController extends GetxController {

  var _count = 0.obs;
  var _totalamount = 0.0.obs;
  var _totalcc = 0.0.obs;
  var _totalWeight = 0.0.obs;
  var _ipAddress;
  List<CartItemModel> cartModel=[];

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    _ipAddress = await Ipify.ipv64();
    _count.value = SessionManager.getInt(Constants.PREF_OpenCartCount);
  }

  set count(var val) {
    _count.value = val;
  }

  String get ipAddress  {
      return _ipAddress;
  }

  int get count {
    return _count.value;
  }

  double get totalAmount {
    return _totalamount.value;
  }

  double get totalCC {
    return _totalcc.value;
  }

  double get tottalWeight {
    return _totalWeight.value;
  }

  void addCartProduct(String pid,String qty) {
    Random random = Random();
    String SessionId;
    if (SessionManager.getString(Constants.PREF_OrderCartSSID) == '') {
      int ranint = random.nextInt(10000) + 10;
      SessionId = DateTime.now().millisecondsSinceEpoch.toString() + ranint.toString();
      SessionManager.setString(Constants.PREF_OrderCartSSID, SessionId);
    } else {
      SessionId = SessionManager.getString(Constants.PREF_OrderCartSSID);
    }
    Map<String, dynamic> param = {
      'Action':'Add',
      'Regid':SessionManager.getString(Constants.PREF_RegId),
      'Pid':pid,
      'Qty':qty,
      'fcode':'SP001',
      'Sesid':SessionId,
      'UQID':SessionManager.getString(Constants.PREF_OrderCartUUID),
    };
    NetworkCalls().callServer(Constants.apiTempRepurchaseItems, param).then((value) {
      var data = jsonDecode(value!.body) as List;
      if(data[0]['result'].toString().toUpperCase()==Constants.success) {
        cartModel.clear();
        SessionManager.setString(Constants.PREF_OrderCartUUID, data[0]['UQID']);
        _count.value = 0;
        _totalamount.value = 0.0;
        _totalcc.value = 0.0;
        _totalWeight.value = 0.0;
        data.forEach((element) {
          _count.value += int.parse(element['Qty']);
          _totalamount.value += double.parse(element['TotalDP']);
          _totalcc.value += double.parse(element['TotPV']);
          _totalWeight.value += double.parse(element['PrdWeight']) * int.parse(element['Qty']);
        });
        cartModel.addAll(data.map((e) => CartItemModel.fromJson(e)));
        SessionManager.setInt(Constants.PREF_OpenCartCount, _count.value);
        Logger.ShowSuccessAlert('Success', 'Product Added Successfully.');
      } else {
        Logger.ShowErrorAlert('Error', data[0]['result'].toString());
      }
    });
  }

  void updateCartProduct(String pid,String qty) {
    //Random random = Random();
    String SessionId;
    // if (SessionManager.getString(Constants.PREF_OrderCartSSID) == '') {
    //   int ranint = random.nextInt(10000) + 10;
    //   SessionId = DateTime.now().millisecondsSinceEpoch.toString() + ranint.toString();
    //   SessionManager.setString(Constants.PREF_OrderCartSSID, SessionId);
    // } else {
      SessionId = SessionManager.getString(Constants.PREF_OrderCartSSID);
    //}
    Map<String, dynamic> param = {
      'Action':'Add',
      'Regid':SessionManager.getString(Constants.PREF_RegId),
      'Pid':pid,
      'Qty':qty,
      'fcode':'SP001',
      'Sesid':SessionId,
      'UQID':SessionManager.getString(Constants.PREF_OrderCartUUID),
    };
    NetworkCalls().callServer(Constants.apiTempRepurchaseItems, param).then((value) {
      var data = jsonDecode(value!.body) as List;
      if(data[0]['result'].toString().toUpperCase()==Constants.success) {
        cartModel.clear();
        SessionManager.setString(Constants.PREF_OrderCartUUID, data[0]['UQID']);
        _count.value = 0;
        _totalamount.value = 0.0;
        _totalcc.value = 0.0;
        _totalWeight.value = 0.0;
        data.forEach((element) {
          _count.value += int.parse(element['Qty']);
          _totalamount.value += double.parse(element['TotalDP']);
          _totalcc.value += double.parse(element['TotPV']);
          _totalWeight.value += double.parse(element['PrdWeight']) * int.parse(element['Qty']);
        });
        cartModel.addAll(data.map((e) => CartItemModel.fromJson(e)));
        SessionManager.setInt(Constants.PREF_OpenCartCount, _count.value);
        Logger.log(cartModel.length);
       // Get.toNamed(CartView.routeName,arguments: cartModel,preventDuplicates: false);
        Logger.ShowSuccessAlert('Success', 'Product Updated Successfully.');
      } else {
        Logger.ShowErrorAlert('Error', data[0]['result'].toString());
      }
    });
  }

  void deleteCartProduct(String pid) {
   // Random random = Random();
    String SessionId;
    // if (SessionManager.getString(Constants.PREF_OrderCartSSID) == '') {
    //   int ranint = random.nextInt(10000) + 10;
    //   SessionId = DateTime.now().millisecondsSinceEpoch.toString() + ranint.toString();
    //   SessionManager.setString(Constants.PREF_OrderCartSSID, SessionId);
    // } else {
      SessionId = SessionManager.getString(Constants.PREF_OrderCartSSID);
    //}
    Map<String, dynamic> param = {
      'Action':'Delete',
      'Regid':SessionManager.getString(Constants.PREF_RegId),
      'Pid':pid,
      'Qty':0,
      'fcode':'SP001',
      'Sesid':SessionId,
      'UQID':SessionManager.getString(Constants.PREF_OrderCartUUID),
    };
    NetworkCalls().callServer(Constants.apiTempRepurchaseItems, param).then((value) {
      var data = jsonDecode(value!.body) as List;
      if(data[0]['result'].toString()=='Deleted') {
        if(data.length>1) {
          cartModel.clear();
          SessionManager.setString(Constants.PREF_OrderCartUUID, data[0]['UQID']);
          _count.value = 0;
          _totalamount.value = 0.0;
          _totalcc.value = 0.0;
          _totalWeight.value = 0.0;
          data.forEach((element) {
            _count.value += int.parse(element['Qty']);
            _totalamount.value += double.parse(element['TotalDP']);
            _totalcc.value += double.parse(element['TotPV']);
            _totalWeight.value += double.parse(element['PrdWeight']) * int.parse(element['Qty']);
          });
          cartModel.addAll(data.map((e) => CartItemModel.fromJson(e)));
          SessionManager.setInt(Constants.PREF_OpenCartCount, _count.value);
          // Get.offAndToNamed(CartView.routeName,arguments: cartModel);
          Logger.ShowSuccessAlert('Success', 'Product Deleted Successfully.');
        } else {
          if(data[0]['Pid']=='0'){
            _count.value = 0;
            _totalamount.value = 0.0;
            _totalcc.value = 0.0;
            _totalWeight.value = 0.0;
            SessionManager.setInt(Constants.PREF_OpenCartCount, 0);
            Get.back();
          } else {
            cartModel.clear();
            SessionManager.setString(Constants.PREF_OrderCartUUID, data[0]['UQID']);
            _count.value = 0;
            _totalamount.value = 0.0;
            _totalcc.value = 0.0;
            _totalWeight.value = 0.0;
            data.forEach((element) {
              _count.value += int.parse(element['Qty']);
              _totalamount.value += double.parse(element['TotalDP']);
              _totalcc.value += double.parse(element['TotPV']);
              _totalWeight.value += double.parse(element['PrdWeight']) * int.parse(element['Qty']);
            });
            cartModel.addAll(data.map((e) => CartItemModel.fromJson(e)));
            SessionManager.setInt(Constants.PREF_OpenCartCount, _count.value);
            // Get.offAndToNamed(CartView.routeName,arguments: cartModel);
            Logger.ShowSuccessAlert('Success', 'Product Deleted Successfully.');
          }
        }
      } else {
        Logger.ShowErrorAlert('Error', data[0]['result'].toString());
      }

    });
  }

}