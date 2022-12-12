// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uasppb_2019130006/model/product_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CartController extends GetxController {
  //Add a dictionary to store the products in the cart
  //observe value of _proudcts to another screen
  final _products = {}.obs;
  static bool isProductExist = false;

  final currencyFormatter = NumberFormat.currency(locale: 'ID');

  void addProduct(Product product) {
    if (_products.containsKey(product)) {
      if (_products[product] < product.stock) {
        Get.snackbar(
          "title",
          "message",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 850),
          titleText: const Text(
            "Product Added To Cart",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          messageText: Text("You have added the ${product.name} to the cart",
              style: const TextStyle(fontSize: 14)),
          backgroundColor: Colors.blue.shade300,
        );

        _products[product] += 1;
      } else {
        Get.snackbar(
          "title",
          "message",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 850),
          titleText: const Text(
            "Overstock",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          messageText: const Text(
              "The number of products added exceeds the stock we have",
              style: TextStyle(fontSize: 14)),
          backgroundColor: Colors.blue.shade300,
        );

        _products[product] = product.stock;
      }
    } else {
      Get.snackbar(
        "title",
        "message",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 850),
        titleText: const Text(
          "Product Added To Cart",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        messageText: Text("You have added the ${product.name} to the cart",
            style: const TextStyle(fontSize: 14)),
        backgroundColor: Colors.blue.shade300,
      );

      _products[product] = 1;

      checkProduct();
      print("total : $total");
      print("is product exist : $isProductExist");
    }
  }

//containsKey(object)
  void addProductToCart(Product product) {
    if (_products.containsKey(product)) {
      if (_products[product] < product.stock) {
        _products[product] += 1;
      } else {
        Get.snackbar(
          "title",
          "message",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 850),
          titleText: const Text(
            "Overstock",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          messageText: const Text(
              "The number of products added exceeds the stock we have",
              style: TextStyle(fontSize: 14)),
          backgroundColor: Colors.blue.shade300,
        );

        _products[product] = product.stock;
      }
    } else {
      _products[product] = 1;
    }
  }

  get products => _products;

  void removeProduct(Product product) {
    if (_products.containsKey(product) && _products[product] == 1) {
      _products.removeWhere((key, value) => key == product);
      checkProduct();
      print("total : $total");
      print("is product exist : $isProductExist");
    } else {
      //if quantity > 1
      _products[product] -= 1;
    }
  }

  get productSubTotal => _products.entries
      .map((product) => product.key.price * product.value)
      .toList();

  get total {
    if (_products.isNotEmpty) {
      int total = _products.entries
          .map((product) => product.key.price * product.value)
          .toList()
          .reduce((value, element) => value + element);

      return "Total : ${currencyFormatter.format(total)}";
    } else {
      return "Cart is empty";
    }
  }

  get totalPay {
    int total = _products.entries
        .map((product) => product.key.price * product.value)
        .toList()
        .reduce((value, element) => value + element);

    return "Total : ${currencyFormatter.format(total)}";
  }

  void checkProduct() {
    if (total == "Cart is empty") {
      isProductExist = false;
    } else {
      isProductExist = true;
    }
  }
}
