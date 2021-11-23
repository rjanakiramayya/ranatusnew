import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/cartcontroller.dart';
import 'package:renatus/Models/order_products_model.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Views/Orders/cart_view.dart';
import 'package:renatus/Widgets/product_item.dart';

class OrderProducts extends StatelessWidget {
  static const String routeName = '/OrderProducts';

  OrderProducts({Key? key}) : super(key: key);
  final ScrollController _controller = ScrollController();
  final cartCtrl = Get.find<CartController>();


  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    List<OrderProductsModelOrderProducts> products = args['products'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Center(
            child: Stack(
              children: [
                IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if(cartCtrl.count==0) {
                        Logger.ShowWorningAlert('Warning', "Your Cart Is Empty");
                      } else {
                        Get.toNamed(CartView.routeName,arguments: cartCtrl.cartModel);
                      }
                    }),
                Positioned(
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    width: 30,
                    height: 22,
                    child: Center(
                      child: Obx(
                        () => Text('${cartCtrl.count}',
                            style: const TextStyle(fontSize: 10),),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: _controller,
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
                      height: 10,
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
                          '  ${args['name']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '  ${args['mobile']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '  ${args['city']} - ${args['pincode']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                return ProductItem(products[i]);
              },
              itemCount: products.length,
            )
          ],
        ),
      ),
    );
  }
}
