import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AdminViewProduct extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const AdminViewProduct({Key? key, required this.documentSnapshot})
      : super(key: key);

  Widget separator(double height) {
    return SizedBox(
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'ID');

    return Scaffold(
      appBar: AppBar(title: const Text("Produk")),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.red])),
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(documentSnapshot['url']),
                ),
                separator(10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SelectableText(
                    "ImageUrl : \n ${documentSnapshot['url']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: "RobotoMono"),
                    textAlign: TextAlign.left,
                  ),
                ),
                separator(15),
                Text(
                  documentSnapshot['name'],
                  style: const TextStyle(fontSize: 24, fontFamily: "Adventure"),
                  textAlign: TextAlign.justify,
                ),
                separator(15),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SelectableText(
                    documentSnapshot['description'],
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "RobotoMono",
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.justify,
                  ),
                ),
                separator(20),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Genre : ${documentSnapshot['genre']}",
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
                        "Price : ${currencyFormatter.format(documentSnapshot['price'])}",
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
                        "Stock : ${documentSnapshot['stock']}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "RobotoMono",
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.justify,
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
