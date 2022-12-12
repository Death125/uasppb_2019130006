import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uasppb_2019130006/page/admin/admin_homepage.dart';
import 'package:uasppb_2019130006/login_page/auth_page.dart';
import 'package:uasppb_2019130006/login_page/verify_email_page.dart';
import 'package:uasppb_2019130006/splash_screen.dart';
import 'package:uasppb_2019130006/utils/message.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  // ignore: prefer_const_declarations
  static final String title = 'Project UAS';

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          primaryColor: Colors.blue.shade300, dividerColor: Colors.black),
      scaffoldMessengerKey: Message.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: title,
      home: SplashScreen(
        title: 'Application',
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          } else if (snapshot.hasData &&
              snapshot.data!.uid == "kydl0r5ow0R9doHNVzuSWOLskN42") {
            return const AdminHomePage();
          } else if (snapshot.hasData) {
            //if login
            // return const HomePage();
            return const VerifyEmailPage();
          } else {
            //if logout
            return AuthPage();
          }
        },
      ));
}
