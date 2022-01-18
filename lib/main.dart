import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/pages/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pushupapp/api/httpexceptions.dart';
import 'package:pushupapp/ui/widgets/index.dart';

//todo: coin update not always updating (probably has to do with it randomly selecting the same user)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Attempt to login to the server using user information
  // Stored within the phone. if none found, present the login page.
  SharedPreferences? pref = await SharedPreferences.getInstance();
  if (!pref.containsKey("puapp_username")) {
    runApp(const App(page: LoginPage()));
    return;
  }

  String username = pref.get("puapp_username") as String;
  String password = pref.get("puapp_password") as String;

  try {
    await API.initialize(username, password);
  } on SocketException {
    return;
  } on HttpException catch (e) {
    if (e.status == Status.unauthorized) {
      runApp(const App(page: LoginPage()));
    }
    return;
  }

  runApp(App(
      page: FutureBuilder(
          future: API.get().groups(),
          builder: (context, snap) {
            if (snap.hasError) {
              if ((snap.error as HttpException).status != Status.notFound) {
                MDialog.internalError(context);
                return const LoadPage();
              }
            }
            if (snap.data == null) {
              return const LoadPage();
            }
            return BaseLayout();
          })));
}

class App extends StatelessWidget {
  final Widget page;

  const App({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "iPushup",
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[900], fontFamily: "Helvetica"),

      // Application
      home: page,
    );
  }
}
