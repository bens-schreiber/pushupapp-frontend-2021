import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart';
import 'package:pushupapp/api/httpexceptions.dart';

/// Sign up account page
class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                  Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: _inputField(
                        const Icon(Icons.person_outline,
                            size: 30, color: Color(0xffA6B0BD)),
                        "Enter a Username",
                        false,
                        username),
                  ),
                  _inputField(
                      const Icon(Icons.lock_outline,
                          size: 30, color: Color(0xffA6B0BD)),
                      "Enter a "
                      "Password",
                      true,
                      password),
                  Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      child: GlowingButton(
                          text: "Create account",
                          height: 60,
                          onPressed: () => _register(
                              username.value.text, password.value.text))),
                  _haveAccount(),
                  _loginButton(),
                  _createdBy()
                ]))));
  }

  Widget _createdBy() {
    return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 18),
        child: TextButton(
            onPressed: () => {},
            child: const Text("Created by Benjamin Schreiber",
                style: TextStyle(
                    color: Color(0xffA6B0BD),
                    fontWeight: FontWeight.w400,
                    fontSize: 12))));
  }

  Widget _loginButton() {
    return TextButton(
        onPressed: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()))
            },
        child: const Text("LOGIN",
            style: TextStyle(
                color: Color(0xFF008FFF),
                fontWeight: FontWeight.w800,
                fontSize: 16)));
  }

  Widget _haveAccount() {
    return const Text("Already have an account?",
        style: TextStyle(
            color: Color(0xffA6B0BD),
            fontWeight: FontWeight.w400,
            fontSize: 18));
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

  Future<void> _register(String username, String password) async {
    LoadPage.push(context, (context) async {
      try {
        await API.newUser(username, password);
      } on HttpException catch (e) {
        if (e.status == Status.badRequest) {
          MDialog.okDialog(context, "Username already exists");
        } else {
          MDialog.internalError(context);
        }
      }

      try {
        // Grab API token and cache user details
        await API.initialize(username, password);

        await API.get().groups(); // Grab page information

        // Save user login details in phone for easier future login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("puapp_username", username);
        prefs.setString("puapp_password", password);

        return BaseLayout();
      } on HttpException {
        return MDialog.internalError(context).then((_) => const SignupPage());
      } on Exception {
        return MDialog.noConnection(context).then((_) => const SignupPage());
      }
    });
  }
}
