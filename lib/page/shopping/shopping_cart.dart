// ignore_for_file: unnecessary_brace_in_string_interps, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uasppb_2019130006/controller/cart_controller.dart';
import 'package:uasppb_2019130006/login_page/auth_page.dart';
import 'package:uasppb_2019130006/model/product_model.dart';
import 'package:uasppb_2019130006/page/about_page.dart';
import 'package:uasppb_2019130006/page/shopping/cart_total.dart';
import 'package:uasppb_2019130006/page/shopping/payment_page.dart';
import 'package:uasppb_2019130006/page/shopping/product_history.dart';
import 'package:uasppb_2019130006/page/user_home_page.dart';
import 'package:uasppb_2019130006/widgets/custom_alert_dialog.dart';

class ShoppingCart extends StatefulWidget {
  static bool isProductExist = false;
  ShoppingCart({Key? key}) : super(key: key);

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final CartController controller = Get.find();
  final user = FirebaseAuth.instance.currentUser!;

  Widget separator(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget drawer(BuildContext context) {
    return Drawer(
        backgroundColor: const Color.fromARGB(230, 115, 214, 214),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFF3366FF),
                        Color(0xFF00CCFF),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .where("uid", isEqualTo: user.uid)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return ListView.builder(
                            itemCount: streamSnapshot
                                .data!.docs.length, //number of rows
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];

                              return Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: "${documentSnapshot['urlp']}",
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 30,
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) => Container(
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  separator(7),
                                  const Text(
                                    "Sign In As",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  separator(6),
                                  Text(
                                    user.email!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              );
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )),
            ListTile(
              hoverColor: Colors.amber,
              leading: const Icon(Icons.description),
              trailing: const Icon(Icons.navigate_next),
              title: const Text(
                "About",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final action = await AlertDialogs.yesCancelDialog(
                    context,
                    'About page',
                    'Do you want to go to the about page ?',
                    Icons.history_edu);
                if (action == DialogsAction.yes) {
                  setState(() {
                    setState(() => Navigator.pop(context));
                    Get.to(() => const AboutPage());
                  });
                } else {
                  // setState(() => Navigator.pop(context));
                }
              },
            ),
            ListTile(
              hoverColor: Colors.amber,
              leading: const Icon(Icons.history),
              trailing: const Icon(Icons.navigate_next),
              title: const Text(
                "History Transaction",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final action = await AlertDialogs.yesCancelDialog(
                    context,
                    ' History Transaction',
                    'Do you want to go to the History Transaction?',
                    Icons.history);
                if (action == DialogsAction.yes) {
                  setState(() {
                    setState(() => Navigator.pop(context));
                    Get.to(() => const History());
                  });
                } else {
                  // setState(() => Navigator.pop(context));
                }
              },
            ),
            ListTile(
              hoverColor: Colors.amber,
              leading: const Icon(Icons.logout),
              trailing: const Icon(Icons.navigate_next),
              title: const Text(
                "Logout",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final action = await AlertDialogs.yesCancelDialog(
                    context, 'Logout', 'Are you sure ?', Icons.power_off);
                if (action == DialogsAction.yes) {
                  setState(() {
                    if (HomePage.newScreen == false) {
                      if (controller.products.length > 0) {
                        Get.delete<CartController>();
                      }
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                      HomePage.index = 0;
                    } else {
                      if (controller.products.length > 0) {
                        Get.delete<CartController>();
                      }
                      FirebaseAuth.instance.signOut();
                      Get.to(() => AuthPage());

                      HomePage.newScreen = false;
                      HomePage.index = 0;
                    }
                  });
                } else {
                  // setState(() => Navigator.pop(context));
                }
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    //OBX for update widget everytime there is a change in the product dictionary
    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        title: const Text('Product Cart'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF3366FF),
                  Color(0xFF00CCFF),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 33, 184, 243),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Obx(
            () => Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.blue, Colors.red])),
              height: 450,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ListView.builder(
                    itemCount: controller.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (controller.products.length == 0) {
                        return const SizedBox(
                          height: 100,
                          width: 100,
                          child: Text('Cart kosong'),
                        );
                      } else {
                        return CartProductCard(
                          controller: controller,
                          product: controller.products.keys.toList()[index],
                          quantity: controller.products.values.toList()[index],
                          index: index,
                        );
                      }
                    }),
              ),
            ),
          ),
          Material(
            color: const Color.fromARGB(255, 33, 184, 243),
            child: Column(children: [
              Container(
                width: double.infinity,
                height: 5,
                color: Colors.black,
              ),
              const SizedBox(
                height: 30,
              ),
              CartTotal(),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  height: 50,
                  width: 90,
                  child: controller.total != "Cart is empty"
                      ? TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 82, 100, 158)),
                          onPressed: () async {
                            final action = await AlertDialogs.yesCancelDialog(
                                context,
                                'Payment Method',
                                'Do you want to go to the payment page ?',
                                Icons.payment);
                            if (action == DialogsAction.yes) {
                              Get.to(() => const PaymentPage());
                            } else {}
                          },
                          child: const Text(
                            'Buy',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "RobotoMono"),
                          ),
                        )
                      : const Text('')),
            ]),
          )
        ],
      )),
    );
  }
}

class CartProductCard extends StatelessWidget {
  final CartController controller;
  final Product product;
  final int quantity;
  final int index;

  const CartProductCard({
    Key? key,
    required this.controller,
    required this.product,
    required this.quantity,
    required this.index,
  }) : super(key: key);

  Widget separator(double width) {
    return SizedBox(
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CachedNetworkImage(
            imageUrl: product.imageUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 40,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          ),
          separator(20),
          Expanded(
            child: Text(
              product.name,
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontFamily: "Adventure"),
              softWrap: true,
              maxLines: 5,
            ),
          ),
          IconButton(
              onPressed: () {
                controller.removeProduct(product);
              },
              icon: const Icon(Icons.remove_circle)),
          const SizedBox(
            width: 10,
          ),
          Text(
            "${quantity}",
            style: const TextStyle(fontSize: 16, fontFamily: "RobotoMono"),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                controller.addProductToCart(product);
              },
              icon: const Icon(Icons.add_circle)),
        ],
      ),
    );
  }
}
