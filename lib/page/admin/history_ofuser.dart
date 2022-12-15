import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryOfUser extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const HistoryOfUser({super.key, required this.documentSnapshot});

  @override
  State<HistoryOfUser> createState() => _HistoryOfUserState();
}

class _HistoryOfUserState extends State<HistoryOfUser> {
  final collectionReference = FirebaseFirestore.instance;

  final user = FirebaseAuth.instance.currentUser!;

  Widget separator(double height) {
    return SizedBox(
      height: height,
    );
  }

  Future<void> _showSoldHistory([DocumentSnapshot? documentSnapshot]) async {
    Widget backButton() {
      return SizedBox(
        height: 50,
        width: 130,
        child: TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Back",
            style: TextStyle(
                color: Colors.white, fontFamily: "RobotoMono", fontSize: 20),
          ),
        ),
      );
    }

    await showModalBottomSheet(
        backgroundColor: const Color.fromARGB(210, 72, 204, 193),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return StreamBuilder(
            stream: collectionReference
                .collection('salesHistory')
                .doc(widget.documentSnapshot['email'])
                .collection('soldItem')
                .where("soldItemId", isEqualTo: documentSnapshot!['soldItemId'])
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      var items = documentSnapshot['soldItem'];
                      var quantityOfItem = documentSnapshot['numberOfItemSold'];

                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            const Text(
                              "Sold Date : ",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            separator(4),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  "${documentSnapshot['soldItemDate']}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                      fontFamily: "RobotoMono"),
                                ),
                              ),
                            ),
                            separator(20),
                            const Text(
                              "Selling number : ",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            separator(4),
                            Text(
                              "${documentSnapshot['soldItemId']} ",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  fontFamily: "RobotoMono"),
                            ),
                            separator(20),
                            const Text(
                              "Payment Method : ",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            separator(4),
                            Text(
                              "${documentSnapshot['paymentMethod']} ",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  fontFamily: "RobotoMono"),
                            ),
                            separator(20),
                            const Text(
                              "Sold Item : ",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 60, left: 60, bottom: 7),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${items[index]}',
                                          style: const TextStyle(fontSize: 20),
                                          softWrap: true,
                                          maxLines: 5,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Center(
                                          child: Text(
                                              '${quantityOfItem[index]}',
                                              style: const TextStyle(
                                                  fontSize: 20)))
                                    ],
                                  ),
                                );
                              },
                            ),
                            separator(20),
                            const Text(
                              "Total price : ",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            separator(4),
                            Text(
                              "${documentSnapshot['totalPrice']} ",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  fontFamily: "RobotoMono"),
                            ),
                            separator(50),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: backButton()),
                            separator(15),
                          ],
                        ),
                      );
                    });
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History Of User"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.red])),
        child: StreamBuilder(
          stream: collectionReference
              .collection('salesHistory')
              .doc(widget.documentSnapshot['email'])
              .collection('soldItem')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];

                    return SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${documentSnapshot['soldItemDate']}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "RobotoMono"),
                                  softWrap: true,
                                  maxLines: 5,
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              TextButton(
                                  onPressed: () {
                                    _showSoldHistory(documentSnapshot);
                                  },
                                  child: Text(
                                    "${documentSnapshot['soldItemId']}",
                                    style: const TextStyle(
                                        shadows: [
                                          Shadow(
                                              color: Colors.white,
                                              offset: Offset(0, -9))
                                        ],
                                        color: Colors.transparent,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                        fontFamily: "RobotoMono",
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.grey,
                                        decorationThickness: 1.5,
                                        decorationStyle:
                                            TextDecorationStyle.double),
                                  )),
                            ],
                          ),
                          separator(20),
                        ],
                      ),
                    );
                  });
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
