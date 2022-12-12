import 'package:flutter/material.dart';
import 'login_widget.dart';
import 'signup_widget.dart';

// ignore: use_key_in_widget_constructors
class AuthPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  static bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(
          onClickedSignUp: toogle,
        )
      : SignUpWidget(
          onClickedSignIn: toogle,
        );

  void toogle() => setState(() => isLogin = !isLogin);
}
