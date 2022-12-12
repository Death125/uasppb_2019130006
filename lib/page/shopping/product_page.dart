import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uasppb_2019130006/controller/cart_controller.dart';
import 'package:uasppb_2019130006/controller/product_controller.dart';
import 'package:uasppb_2019130006/login_page/auth_page.dart';
import 'package:uasppb_2019130006/page/about_page.dart';
import 'package:uasppb_2019130006/page/shopping/product_history.dart';
import 'package:uasppb_2019130006/page/shopping/productcard.dart';
import 'package:uasppb_2019130006/page/shopping/productcard_outofstock.dart';
import 'package:uasppb_2019130006/page/user_home_page.dart';
import 'package:uasppb_2019130006/widgets/custom_alert_dialog.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final color = const Color(0XFF7C4DFF);
  final user = FirebaseAuth.instance.currentUser!;

  int _index = 0;
  final ProductController productController = Get.put(ProductController());

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
                    Icons.history_edu);
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
                      Get.delete<CartController>();
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                      HomePage.index = 0;
                    } else {
                      Navigator.pop(context);
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
    return Obx(
      () => Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.red])),
          child: Scaffold(
              drawer: drawer(context),
              appBar: AppBar(
                title: const Text("Bright's Store"),
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
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                  child: SizedBox(
                height: 750,
                child: PageView.builder(
                    itemCount: productController.products.length,
                    controller: PageController(viewportFraction: 0.8),
                    onPageChanged: (int index) =>
                        setState(() => _index = index),
                    itemBuilder: (BuildContext context, int index) {
                      if (productController.products[index].stock > 0) {
                        return Container(
                            margin: const EdgeInsets.only(
                                top: 7, left: 2, right: 2),
                            padding: const EdgeInsets.all(4),
                            child: Transform.scale(
                              scale: index == _index ? 1 : 0.9,
                              child: ProductCard(index: index),
                            ));
                      } else {
                        return Container(
                            margin: const EdgeInsets.only(
                                top: 7, left: 2, right: 2),
                            padding: const EdgeInsets.all(4),
                            child: Transform.scale(
                              scale: index == _index ? 1 : 0.9,
                              child: ProductCardOutOfStock(index: index),
                            ));
                      }
                    }),
              )))),
    );
  }
}
