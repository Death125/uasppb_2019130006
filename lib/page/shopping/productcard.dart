// ignore_for_file: prefer_const_literals_to_create_immutables, depend_on_referenced_packages, unnecessary_string_interpolations

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:uasppb_2019130006/controller/cart_controller.dart';
import 'package:uasppb_2019130006/controller/product_controller.dart';
import 'package:uasppb_2019130006/page/view_product.dart';

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  final int index;

  // ignore: prefer_const_constructors_in_immutables
  ProductCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
    return Card(
      color: Colors.grey,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: "${productController.products[widget.index].imageUrl}",
            imageBuilder: (context, imageProvider) => Container(
              width: double.infinity,
              height: 380,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover)),
            ),
            placeholder: (context, url) => Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 380,
              child: const CircularProgressIndicator(),
            ),
          ),
          separator(20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              productController.products[widget.index].name,
              style: const TextStyle(fontSize: 24, fontFamily: "Adventure"),
            ),
          ),
          separator(20),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Genre : ${productController.products[widget.index].genre}",
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "RobotoMono",
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          separator(10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Stock : ${productController.products[widget.index].stock}",
              style: const TextStyle(fontSize: 16, fontFamily: 'RobotoMono'),
            ),
          ),
          separator(10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Price : ${currencyFormatter.format(productController.products[widget.index].price)}",
              style: const TextStyle(fontSize: 16, fontFamily: 'RobotoMono'),
            ),
          ),
          separator(10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Description :\n${productController.products[widget.index].description}",
              style: const TextStyle(fontSize: 16, fontFamily: 'RobotoMono'),
              textAlign: TextAlign.justify,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          separator(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade200,
                    ),
                    onPressed: () async {
                      Get.to(() => ViewProduct(
                            index: widget.index,
                          ));
                    },
                    child: const Text(
                      'Buy',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ],
          ),
          separator(20),
        ],
      ),
    );
  }
}
