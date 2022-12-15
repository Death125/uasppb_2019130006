import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uasppb_2019130006/page/admin/history_ofuser.dart';

class ChooseHistoryOfUser extends StatefulWidget {
  const ChooseHistoryOfUser({super.key});

  @override
  State<ChooseHistoryOfUser> createState() => _ChooseHistoryOfUserState();
}

class _ChooseHistoryOfUserState extends State<ChooseHistoryOfUser> {
  final collectionReference = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Widget separator(double height) {
    return SizedBox(
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sold History'),
        centerTitle: true,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.red])),
        child: StreamBuilder(
          stream: collectionReference.collection('salesHistory').snapshots(),
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
                          TextButton(
                              onPressed: () {
                                Get.to(HistoryOfUser(
                                  documentSnapshot: documentSnapshot,
                                ));
                              },
                              child: Text(
                                "${documentSnapshot['email']}",
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
        ),
      ),
    );
  }
}
