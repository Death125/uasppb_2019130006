// ignore_for_file: unnecessary_string_interpolations

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:uasppb_2019130006/controller/cart_controller.dart';
import 'package:uasppb_2019130006/controller/product_controller.dart';

class ViewProduct extends StatefulWidget {
  final int index;
  const ViewProduct({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  final cartController = Get.put(CartController());
  final ProductController productController = Get.find();

  final currencyFormatter = NumberFormat.currency(locale: 'ID');

  Widget separator(double height) {
    return SizedBox(
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.red])),
      child: Scaffold(
        appBar: AppBar(title: const Text("Produk")),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "${productController.products[widget.index].imageUrl}",
                  imageBuilder: (context, imageProvider) => Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.contain)),
                  ),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 300,
                    child: const CircularProgressIndicator(),
                  ),
                ),
                separator(15),
                Text(
                  productController.products[widget.index].name,
                  style: const TextStyle(fontSize: 30, fontFamily: "Adventure"),
                  textAlign: TextAlign.justify,
                ),
                separator(15),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    productController.products[widget.index].description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "RobotoMono",
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                separator(20),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Genre : ${productController.products[widget.index].genre}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "RobotoMono",
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.justify,
                      ),
                    )),
                separator(10),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Stock : ${productController.products[widget.index].stock}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "RobotoMono",
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.justify,
                      ),
                    )),
                separator(10),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Price : ${currencyFormatter.format(productController.products[widget.index].price)}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "RobotoMono",
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.justify,
                      ),
                    )),
                separator(30),
                Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                        height: 60,
                        width: 180,
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              backgroundColor:
                                  const Color.fromARGB(255, 49, 103, 196),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                            ),
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              size: 32,
                            ),
                            label: const Text(
                              'Add to cart',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              cartController.addProduct(
                                  productController.products[widget.index]);
                            })))
              ],
            )),
      ),
    );
  }
}
