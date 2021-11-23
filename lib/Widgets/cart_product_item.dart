import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/cartcontroller.dart';
import 'package:renatus/Models/cart_item_model.dart';
import 'package:renatus/Utils/logger.dart';

class CartProductItem extends StatelessWidget {
  CartItemModel item;
  TextEditingController qtyController = TextEditingController();
  final _cartCtrl = Get.find<CartController>();

  CartProductItem(this.item, {Key? key})
      : super(key: key) {
    qtyController.text = item.Qty.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 5,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.bottomLeft,
                child: Text(
                  '${item.PName} ',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'DP ${double.parse(item.DP!).toStringAsFixed(2)} X ${item.Qty} : ${double.parse(item.TotalDP!).toStringAsFixed(2)}',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(5),
                          //   alignment: Alignment.bottomRight,
                          //   child: Text(
                          //     'MRP ${item.mRP} X ${item.qty} : ${item.totalMRP}',
                          //     textAlign: TextAlign.start,
                          //   ),
                          // ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child:
                            Text('CC ${item.PV} X ${item.Qty} : ${item.TotPV}'),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    height: 40,
                    child: TextField(
                      controller: qtyController,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[1234567890]"))
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: '',
                        labelText: '',
                        labelStyle: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.green),
                    width: 100,
                    height: 38,
                    child: TextButton(
                      onPressed: () {
                        if (qtyController.text != '0' &&
                            qtyController.text != '') {
                          FocusScope.of(context).unfocus();
                          _cartCtrl.updateCartProduct(item.Pid.toString(), qtyController.text);
                        } else {
                          Logger.ShowWorningAlert(
                              'Warning', 'Please Enter Valid Quantity');
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        Positioned(
          top: -5,
          right: -5,
          child: IconButton(
            onPressed: () =>  _cartCtrl.deleteCartProduct(item.Pid.toString()),
            icon: const Icon(
              Icons.delete_sharp,
              color: Colors.red,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
