import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/cartcontroller.dart';
import 'package:renatus/Models/order_products_model.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/logger.dart';
import 'package:renatus/Utils/session_manager.dart';

class ProductItem extends StatefulWidget {
  final OrderProductsModelOrderProducts product;

  const ProductItem(this.product, {Key? key}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  TextEditingController qtyCtrl = TextEditingController(text: '1');
  final _cartCtrl = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Constants.paddingS),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Constants.hexToColor('#FDE2C5'),
              borderRadius: BorderRadius.circular(15),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.product.ThumbImage!,
              placeholder: (context, url) => const SizedBox(
                height: 120,
                width: 120,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              imageBuilder: (context, imageProvider) => Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              errorWidget: (context, url, error) => SizedBox(
                height: 120,
                width: 120,
                child: Image.asset('${Constants.imagePath}No_Product.png'),
              ),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Text(
                  '${widget.product.Name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: Constants.spaceM,
                ),
                Row(
                  children: [
                    Text(
                      'MRP ${Constants.rupeesymbol} ${double.parse(widget.product.MRP!).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'DP ${Constants.rupeesymbol} ${double.parse(widget.product.DP!).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'CC',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          ' : ${double.parse(widget.product.PV!).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(
                          width: Constants.spaceM,
                        ),
                        // Container(
                        //   child: Text(
                        //     'RP',
                        //     style: TextStyle(
                        //       fontSize: Constants.getForntSize(18),fontWeight: FontWeight.w600,color: Colors.black54,
                        //     ),
                        //   ),
                        // ),
                        // Text(
                        //   ' : ${product.rewardPoints.toStringAsFixed(2)}',
                        //   style: TextStyle(
                        //     fontSize: Constants.getForntSize(18),fontWeight: FontWeight.w600,color: Colors.black54,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 45,
                          child: TextField(
                            controller: qtyCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(), hintText: 'Qty'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 100,
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.green),
                            child: TextButton(
                              onPressed: () {
                                if(qtyCtrl.text=='0' || qtyCtrl.text.isEmpty || qtyCtrl.text==''){
                                  Logger.ShowWorningAlert('Warning', 'Enter Valid Quantity.');
                                } else {
                                  _cartCtrl.addCartProduct(
                                      widget.product.Pid.toString(),
                                      qtyCtrl.text);
                                }
                              },
                              child: const Text(
                                'Add To Cart',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
