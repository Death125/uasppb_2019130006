import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uasppb_2019130006/main.dart';

import '../utils/message.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
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

  Widget title() {
    return SizedBox(
        child: Column(
      children: const [
        SizedBox(
          height: 5,
        ),
        Center(
          child: Text(
            'Hey There, \n Welcome Back !',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ));
  }

  Widget emailField() {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(fontSize: 20),
      controller: emailController,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
          labelText: 'Email',
          hintText: 'Email',
          labelStyle: TextStyle(color: Colors.white),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.email)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value != null && !EmailValidator.validate(value)
          ? ' Enter a valid Email'
          : null,
    );
  }

  Widget changeToSignIn() {
    return RichText(
        text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 20),
            text: 'Already have an account ',
            children: [
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = widget.onClickedSignIn,
              text: 'Log In',
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).colorScheme.secondary))
        ]));
  }

  Widget passwordField() {
    return TextFormField(
      controller: passwordController,
      style: const TextStyle(fontSize: 20),
      textInputAction: TextInputAction.next,
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      obscureText: isPasswordHidden,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) =>
          value != null && value.length < 6 ? ' Enter min. 6 characters' : null,
    );
  }

  Widget signUpButton() {
    return SizedBox(
      width: 250,
      height: 70,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 49, 103, 196),
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        ),
        icon: const Icon(
          Icons.arrow_forward,
          size: 32,
        ),
        label: const Text(
          'Sign up',
          style: TextStyle(fontSize: 24),
        ),
        onPressed: signUp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
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
                title(),
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
                          "Sign Up",
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
                                separator(40),
                                emailField(),
                                separator(10),
                                passwordField(),
                                separator(90),
                                signUpButton(),
                              ],
                            )),
                      ])),
                    )),
                separator(10),
                changeToSignIn()
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future signUp() async {
    String userName = emailController.text;

    //Removes everything after first '.'
    String result = userName.substring(0, userName.indexOf('@'));

    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(value.user!.uid)
            .set({
          "urlp":
              "https://firebasestorage.googleapis.com/v0/b/uas-ppb-2019130006.appspot.com/o/profileImage%2FDefault.png?alt=media&token=563b0f3b-297a-455f-820f-4c0c9b96c3c3",
          "urlbp":
              "https://firebasestorage.googleapis.com/v0/b/uas-ppb-2019130006.appspot.com/o/profileImage%2FbpDefault.png?alt=media&token=c790a94b-ad32-4752-8a29-ba2d39d692fb",
          "uid": value.user!.uid,
          "email": value.user!.email,
          "username": result,
          "profession": "I'm a user",
          "about": "New here",
        });
      });
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);

      Message.showSnackBar(e.message);
    }

    //Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
