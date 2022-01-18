import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import "package:pushupapp/ui/widgets/index.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';
import 'package:pushupapp/api/httpexceptions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                child: Column(children: [
                  _logo(),
                  _inputField(
                      const Icon(Icons.person_outline,
                          size: 30, color: Color(0xffA6B0BD)),
                      "Username",
                      false,
                      username),
                  _inputField(
                      const Icon(Icons.lock_outline,
                          size: 30, color: Color(0xffA6B0BD)),
                      "Password",
                      true,
                      password),
                  Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      child: GlowingButton(
                          text: "Sign in",
                          height: 60,
                          onPressed: () async => await _login(
                              username.value.text, password.value.text))),
                  const Text("Don't have an account?",
                      style: TextStyle(
                          color: Color(0xffA6B0BD),
                          fontWeight: FontWeight.w400,
                          fontSize: 18)),
                  _signUp(),
                  _createdBy()
                ]))));
  }

  Widget _createdBy() {
    return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 18),
        child: const Text("Created by Benjamin Schreiber",
            style: TextStyle(
                color: Color(0xffA6B0BD),
                fontWeight: FontWeight.w400,
                fontSize: 12)));
  }

  Widget _signUp() {
    return TextButton(
        onPressed: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignupPage()))
            },
        child: const Text("SIGN UP NOW",
            style: TextStyle(
                color: Color(0xFF008FFF),
                fontWeight: FontWeight.w800,
                fontSize: 16)));
  }

  Widget _inputField(Icon prefixIcon, String hintText, bool isPassword,
      TextEditingController controller) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 25,
                  offset: Offset(0, 5),
                  spreadRadius: -25)
            ]),
        margin: const EdgeInsets.only(bottom: 20),
        child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xff000912)),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 25),
                hintText: hintText,
                hintStyle: const TextStyle(color: Color(0xffA6B0BD)),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: prefixIcon,
                prefixIconConstraints: const BoxConstraints(minWidth: 75),
                enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(color: Colors.white)))));
  }

  Widget _logo() {
    return Container(
        margin: const EdgeInsets.only(top: 100, bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
                width: 130,
                child: Image(image: AssetImage("assets/logoback.png"))),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("iPushup",
                  style: TextStyle(fontSize: 50, color: Colors.white)),
            )
          ],
        ));
  }

  Future<void> _login(String username, String password) async {

    try {
      await API.initialize(username, password);
    } on SocketException {
      MDialog.connectionError(context);
      return;
    } on HttpException catch (e) {
      switch (e.status) {
        case Status.unauthorized:
          MDialog.invalidCredentials(context);
          return;
        case Status.badRequest:
          MDialog.okDialog(context, "Enter a username and password.");
          return;
        case Status.ratelimit:
          MDialog.rateLimited(context);
          return;
        default:
          MDialog.internalError(context);
          return;
      }
    }

    LoadPage.push(context, (context) async {
      try {

        await API.get().groups();

        /// Save user login details in phone for easier future login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("puapp_username", username);
        prefs.setString("puapp_password", password);
        return BaseLayout();
      } on SocketException {
          MDialog.connectionError(context).then((_) => const LoginPage());
      } on HttpException {
          return MDialog.internalError(context).then((_) => const LoginPage());
      }
    });
  }
}
