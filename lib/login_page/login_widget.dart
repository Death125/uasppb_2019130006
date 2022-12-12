import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uasppb_2019130006/main.dart';

import 'forgot_password_page.dart';
import '../utils/message.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;
  void tooglePasswordVisibility() =>
      setState(() => isPasswordHidden = !isPasswordHidden);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Widget separator(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget appTitle() {
    return const SizedBox(
      child: Center(
        child: Text(
          "",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(fontSize: 20),
      decoration: const InputDecoration(
          labelText: 'Email',
          hintText: 'Email',
          labelStyle: TextStyle(color: Colors.white),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          prefixIcon: Icon(
            Icons.email,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always),
      controller: emailController,
      validator: (value) {
        return (value!.isEmpty ? "email is empty" : null);
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
          border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          labelText: 'Password',
          hintText: 'Password',
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: isPasswordHidden
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: tooglePasswordVisibility,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always),
      obscureText: isPasswordHidden,
      controller: passwordController,
      validator: (value) {
        return (value!.isEmpty ? "Password is empty" : null);
      },
    );
  }

  Widget forgotPasswordField() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      onPressed: () {},
      child: GestureDetector(
        child: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forgot Password?',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ForgotPasswordPage(),
          ));
        },
      ),
    );
  }

  Widget changeToSignUp() {
    return Align(
      widthFactor: double.infinity,
      alignment: Alignment.bottomCenter,
      child: RichText(
        text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 20),
            text: "Don't Have an Account ",
            children: [
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onClickedSignUp,
                  text: 'Sign Up',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary))
            ]),
      ),
    );
  }

  Widget signInButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 230,
        height: 60,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              backgroundColor: const Color.fromARGB(255, 49, 103, 196),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
            ),
            icon: const Icon(
              Icons.lock_open,
              size: 32,
            ),
            label: const Text(
              'Sign in',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: signIn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                separator(15),
                appTitle(),
                separator(20),
                Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                          child: Column(children: [
                        separator(15),
                        const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40),
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  separator(48),
                                  emailField(),
                                  separator(10),
                                  passwordField(),
                                  separator(20),
                                  forgotPasswordField(),
                                  separator(40),
                                  signInButton(),
                                ])),
                      ])),
                    )),
                separator(60),
                changeToSignUp()
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future signIn() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

//After showing, then close logindialog
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);

      Message.showSnackBar(e.message);
    }

    //Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
