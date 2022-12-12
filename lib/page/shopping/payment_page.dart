// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls, avoid_returning_null_for_void, avoid_print, depend_on_referenced_packages, unnecessary_brace_in_string_interps
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uasppb_2019130006/controller/cart_controller.dart';
import 'package:uasppb_2019130006/model/product_model.dart';
import 'package:uasppb_2019130006/page/shopping/cart_total.dart';
import 'package:uasppb_2019130006/page/user_home_page.dart';
import 'package:intl/intl.dart';
import 'package:uasppb_2019130006/widgets/custom_alert_dialog.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});
  static bool isBuy = false;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final CartController controller = Get.find();
  final GlobalKey<FormState> _keyform = GlobalKey<FormState>();
  String? paymentMethod = '';

  //Access table product in firestore
  final CollectionReference _product =
      FirebaseFirestore.instance.collection('product');

  Widget separator(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget paymentMethodRb() {
    return Theme(
      data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.white, disabledColor: Colors.blue),
      child: Column(children: [
        SizedBox(
          child: RadioListTile(
            selectedTileColor: Colors.white,
            tileColor: const Color.fromARGB(180, 0, 0, 0),
            value: "Credit Card",
            groupValue: paymentMethod,
            onChanged: (String? value) {
              setState(() {
                paymentMethod = value;
              });
            },
            title: const Text(
              'Credit Card',
              style: TextStyle(
                  fontSize: 24, color: Colors.white, fontFamily: "SuperBowl"),
            ),
          ),
        ),
        SizedBox(
          child: RadioListTile(
            selectedTileColor: Colors.white,
            tileColor: const Color.fromARGB(180, 0, 0, 0),
            value: "Bank Transfer",
            groupValue: paymentMethod,
            onChanged: (String? value) {
              setState(() {
                paymentMethod = value;
              });
            },
            title: const Text(
              'Bank Transfer',
              style: TextStyle(
                  fontSize: 24, color: Colors.white, fontFamily: "SuperBowl"),
            ),
          ),
        ),
        SizedBox(
          child: RadioListTile(
            selectedTileColor: Colors.white,
            tileColor: const Color.fromARGB(180, 0, 0, 0),
            value: "Gopay",
            groupValue: paymentMethod,
            onChanged: (String? value) {
              setState(() {
                paymentMethod = value;
              });
            },
            title: const Text(
              'Gopay',
              style: TextStyle(
                  fontSize: 24, color: Colors.white, fontFamily: "SuperBowl"),
            ),
          ),
        )
      ]),
    );
  }

  Widget chooseText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 7),
      child: Text(
        "Choose your payment method",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        textAlign: TextAlign.left,
      ),
    );
  }

  Future<void> _payment() async {
    Widget cancelPaymentButton() {
      return SizedBox(
        height: 50,
        width: 120,
        child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
      );
    }

    Product p;
    int qty;
    String productId;
    final user = FirebaseAuth.instance.currentUser!;
    String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

    var productList = [];
    var productQuantity = [];

    DateTime? now = DateTime.now();
    // DateTime date = DateTime(now.year, now.month, now.day);
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

    Widget confirmPaymentButton([DocumentSnapshot? documentSnapshot]) {
      return SizedBox(
        height: 50,
        width: 120,
        child: ElevatedButton(
          child: const Text(
            'Confirm',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () async {
            final action = await AlertDialogs.yesCancelDialog(
                context,
                'Buy Item',
                'Are you sure you want to buy this item ?',
                Icons.credit_card);
            if (action == DialogsAction.yes) {
              //Update Stock of product
              // for (var i = 0; i < controller.products.length; i++) {
              //   p = controller.products.keys.toList()[i];
              //   qty = controller.products.values.toList()[i];

              //   productId = p.id;
              //   productList.add(p.name);
              //   productQuantity.add(qty);

              //   _product.doc(productId).update({
              //     'stock': FieldValue.increment(-(qty))
              //   }).catchError((onError) =>
              //       print("Failed to update stock of products : $onError"));
              // }

              Get.delete<CartController>();
              HomePage.index = 0;
              HomePage.newScreen = true;
              Get.to(() => const HomePage());

              // //Write history of purchased item
              // final databaseReference = FirebaseFirestore.instance;

              // databaseReference
              //     .collection('purchaseHistory')
              //     .doc(user.email)
              //     .set({"email": user.email}).catchError((onError) =>
              //         print("Failed to add new collection : $onError"));

              // databaseReference
              //     .collection('purchaseHistory')
              //     .doc(user.email)
              //     .collection('purchasedItem')
              //     .doc(uniqueId)
              //     .set({
              //   "purchaseItemId": uniqueId,
              //   "purchaseItemDate": formattedDate,
              //   "purchaseItem": productList,
              //   "numberOfItemPurchased": productQuantity,
              //   "paymentMethod": paymentMethod,
              // }).catchError((onError) =>
              //         print("Failed to add new sub-collection : $onError"));

              // //Write history of sold item
              // final databaseReference1 = FirebaseFirestore.instance;

              // databaseReference1
              //     .collection('salesHistory')
              //     .doc(user.email)
              //     .set({"email": user.email}).catchError((onError) =>
              //         print("Failed to add new collection : $onError"));

              // databaseReference1
              //     .collection('salesHistory')
              //     .doc(user.email)
              //     .collection('soldItem')
              //     .doc(uniqueId)
              //     .set({
              //   "soldItemId": uniqueId,
              //   "soldItemDate": formattedDate,
              //   "soldItem": productList,
              //   "numberOfItemSold": productQuantity,
              //   "paymentMethod": paymentMethod,
              // }).catchError((onError) =>
              //         print("Failed to add new sub-collection : $onError"));

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(milliseconds: 1000),
                behavior: SnackBarBehavior.floating,
                content: Container(
                  padding: const EdgeInsets.all(8),
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: const Center(
                    child: Text('Payment Successfully'),
                  ),
                ),
              ));
            } else {
              // setState(() => Navigator.pop(context));
            }
          },
        ),
      );
    }

    await showModalBottomSheet(
        backgroundColor: const Color.fromARGB(240, 72, 204, 193),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return ListView(
            children: [
              separator(70),
              const Center(
                  child: Text(
                "List of items to buy",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: "SuperBowl"),
              )),
              Obx(() => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            CartProductCard(
                              controller: controller,
                              product: controller.products.keys.toList()[index],
                              quantity:
                                  controller.products.values.toList()[index],
                              index: index,
                            ),
                          ],
                        );
                      },
                    ),
                  )),
              Center(
                child: Text(
                  "Payment Method : $paymentMethod",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              separator(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cancelPaymentButton(),
                  const SizedBox(
                    width: 15,
                  ),
                  confirmPaymentButton(),
                ],
              ),
            ],
          );
        });
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Payment Method'),
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
          // floatingActionButton: confirmPayment(),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: SingleChildScrollView(
            child: Column(children: [
              Form(
                  key: _keyform,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      separator(20),
                      chooseText(),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 34, right: 40, bottom: 10),
                          child: paymentMethodRb()),
                      CartTotal(),
                      separator(25),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: SizedBox(
                          height: 70,
                          width: 120,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              if (_keyform.currentState!.validate()) {
                                if (paymentMethod == '') {
                                  Get.snackbar(
                                    "title",
                                    "message",
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 1),
                                    titleText: const Text(
                                      "Payment Method",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    messageText: const Text(
                                        "Please choose your payment method",
                                        style: TextStyle(fontSize: 14)),
                                    backgroundColor: Colors.blue.shade300,
                                  );
                                } else {
                                  _payment();
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Container(
                                    padding: const EdgeInsets.all(8),
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: const Center(
                                      child: Text('All data is empty'),
                                    ),
                                  ),
                                ));
                              }
                            },
                            child: const Text(
                              'Pay',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 26),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ]),
          )),
    );
  }
}

class CartProductCard extends StatelessWidget {
  static List productList = [];

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
          Text(
            product.name,
            style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontFamily: "Adventure"),
          ),
          Text(
            "${quantity}",
            style: const TextStyle(fontSize: 16, fontFamily: "RobotoMono"),
          ),
        ],
      ),
    );
  }
}
