// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final color = const Color(0XFF7C4DFF);
  final user = FirebaseAuth.instance.currentUser!;

  Widget separator(double height) {
    return SizedBox(
      height: height,
    );
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
        appBar: AppBar(
          title: const Text("About"),
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
        body: Column(
          children: const [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 17),
                child: Text(
                  "Bright's Store",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: "NatureBeauty"),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "\t Bright's Store is a store that sells game cd for PC, we provide various types of PC games and we sell them at relatively cheap prices.",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "RobotoMono"),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 0),
                child: Text(
                  "\t What are you waiting for, let's order now and play the game!",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "RobotoMono"),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Text(
                  "@ Created by Viki Fernando",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: "RobotoMono"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
