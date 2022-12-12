// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uasppb_2019130006/main.dart';

class SplashScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  _SplashScreenState() {
    // ignore: unnecessary_new
    new Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false);
      });
    });

    // ignore: unnecessary_new
    new Timer(const Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: unnecessary_new
      decoration: new BoxDecoration(
        // ignore: unnecessary_new
        gradient: new LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).primaryColor
          ],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: const Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 250.0,
            width: 250.0,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 36, 180, 72),
                      Color.fromARGB(255, 0, 17, 255),
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
                color: Colors.black26,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(5.0, 2.0),
                    spreadRadius: 9.0,
                  )
                ]),
            child: const Center(
                child: Image(
              image: AssetImage("assets/images/LauncherIcon.png"),
              fit: BoxFit.fill,
            )),
          ),
        ),
      ),
    );
  }
}
