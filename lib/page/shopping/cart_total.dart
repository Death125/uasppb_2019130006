import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uasppb_2019130006/controller/cart_controller.dart';

class CartTotal extends StatelessWidget {
  final CartController controller = Get.find();
  CartTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.black.withAlpha(50)),
          ),
          Container(
            margin: const EdgeInsets.all(5.0),
            height: 90,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Text(
                ' ${controller.total}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w200,
                    fontFamily: "RobotoMono"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
