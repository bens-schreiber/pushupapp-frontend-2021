import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/widgets/index.dart' as widgets;
import 'package:shared_preferences/shared_preferences.dart';
import 'index.dart' as pages;
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:pushupapp/api/httpexceptions.dart' as he;

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
          child: Column(
            children: [
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
                  child: widgets.GlowingButton(
                      text: "Sign in",
                      height: 60,
                      onPressed: () => login(username.value.text, password.value.text))
                  ),
              _dontHaveAcnt(),
              _signUp(),
              _createdBy(),
            ],
          ),
        ),
      ),
    );
  }

  void login(String username, String password) {

    errorHandle(he.HttpException e) {
      if (e.status == he.Status.unauthorized) {
        widgets.errorDialog(context, "Unknown username or password");
      } else {
        widgets.errorDialog(
            context, "An error has occurred connecting to the server.");
      }
    }

    // Delays the time it takes for the request so the loading screen
    // with logo can be displayed
    Future<List<pojo.Group>> loadingScreenDelay() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return await API.get().groups();
    }

    // Display a loading screen while awaiting a response from the server for
    // the API token, assuring the username and password are valid.
    // Put the username and password into SharedPreferences in order to
    // Automatically login the user everytime they open the app.
    API.initialize(username, password)
        .then((value) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return FutureBuilder(
                future: loadingScreenDelay(),
                builder: (context, snap) {
                  if (snap.data == null) {
                    return const pages.LoadPage();
                  }
                  return FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (context, s) {
                        if (s.data == null) {
                          return const pages.LoadPage();
                        }
                        SharedPreferences prefs = s.data as SharedPreferences;
                        prefs.setString("puapp_username", username);
                        prefs.setString("puapp_password", password);
                        return pages.BaseLayout(username, snap.data as List<pojo.Group>);
                      });
                });
          }));})
        .catchError((error) {errorHandle(error);});
  }

  Widget _createdBy() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 18),
      child: TextButton(
        onPressed: () => {},
        child: const Text(
          "Created by Benjamin Schreiber",
          style: TextStyle(
            color: Color(0xffA6B0BD),
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _signUp() {
    return TextButton(
      onPressed: () => {print("Sign up pressed.")},
      child: const Text(
        "SIGN UP NOW",
        style: TextStyle(
          color: Color(0xFF008FFF),
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _dontHaveAcnt() {
    return const Text(
      "Don't have an account?",
      style: TextStyle(
        color: Color(0xffA6B0BD),
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
    );
  }

  Widget _inputField(Icon prefixIcon, String hintText, bool isPassword,
      TextEditingController controller) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            offset: Offset(0, 5),
            spreadRadius: -25,
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Color(0xff000912),
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 25),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xffA6B0BD),
          ),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: prefixIcon,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 75,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
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
}
