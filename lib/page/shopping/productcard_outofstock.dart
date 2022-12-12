// ignore_for_file: prefer_const_literals_to_create_immutables, depend_on_referenced_packages, unnecessary_string_interpolations

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:uasppb_2019130006/controller/cart_controller.dart';
import 'package:uasppb_2019130006/controller/product_controller.dart';

// ignore: must_be_immutable
class ProductCardOutOfStock extends StatefulWidget {
  final int index;

  // ignore: prefer_const_constructors_in_immutables
  ProductCardOutOfStock({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<ProductCardOutOfStock> createState() => _ProductCardOutOfStockState();
}

class _ProductCardOutOfStockState extends State<ProductCardOutOfStock> {
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
      color: const Color.fromARGB(82, 189, 183, 183),
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
                softWrap: true,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          separator(13),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          separator(20),
          const SizedBox(
            height: 100,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Center(
                child: Text(
                  "Out of stock",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
