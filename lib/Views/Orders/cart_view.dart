import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/cartcontroller.dart';
import 'package:renatus/Models/cart_item_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Views/Orders/check_out_view.dart';
import 'package:renatus/Widgets/cart_product_item.dart';

class CartView extends StatelessWidget {
  static const String routeName = '/CartView';
  final ScrollController _controller = ScrollController();
  final _cartCtrl = Get.find<CartController>();
  CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Items'),
      ),
      body: SingleChildScrollView(
        child: Obx((){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: (Get.height-Get.statusBarHeight-30)-90,
                  child: ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      return CartProductItem(_cartCtrl.cartModel[i]);
                    },
                    itemCount: _cartCtrl.cartModel.length,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  //height: 70,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        // Container(
                        //   padding: EdgeInsets.all(5),
                        //   alignment: Alignment.bottomRight,
                        //   child: Text(
                        //     'Total: ${Constants.rupeesymbol} ${grandtotal.toStringAsFixed(2)}/-',
                        //     style: TextStyle(
                        //         fontSize: 19,
                        //         color: Colors.red,
                        //         fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      'Grand Total: ${Constants.rupeesymbol} ${_cartCtrl.totalAmount.toStringAsFixed(2)}/-',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      'Total CC: ${_cartCtrl.totalCC.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Expanded(
                            //   flex: 1,
                            //   child: Container(
                            //     margin: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                            //     decoration: buttonDecoration,
                            //     height: 40,
                            //     child: TextButton(
                            //       onPressed: () =>  Get.offAndToNamed(MainView.routeName),
                            //       child: Text(
                            //         'Continue to Shop',
                            //         style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: Constants.getForntSize(20)),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              flex: 1,
                              child:Center(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.green),
                                  width: 150,
                                  child: TextButton(
                                    onPressed: () => Get.toNamed(CheckOutView.routeName),
                                    child: const Text(
                                      'Check Out',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
