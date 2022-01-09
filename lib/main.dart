import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/pages/index.dart' as pages;
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:shared_preferences/shared_preferences.dart';


//todo: coin update not always updating (probably has to do with it randomly selecting the same user)
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Attempt to login to the server using user information
  // Stored within the phone. if none found, present the login page.
  SharedPreferences? pref = await SharedPreferences.getInstance();

  if (!pref.containsKey("puapp_username")) { runApp(const App(page: pages.LoginPage())); }

  else {
    Object? username = pref.get("puapp_username");
    Object? password = pref.get("puapp_password");

    Future<dynamic> loadingScreenDelay() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return await API.get().groups();
    }

    API.initialize(username as String, password as String)
        .then((value) {
      runApp(App(page: FutureBuilder(
          future: loadingScreenDelay(),
          builder: (context, snap) {
            if (snap.data == null) {
              return const pages.LoadPage();
            } return pages.BaseLayout(
              username, snap.data as List<pojo.Group>);
            })));
    });
  }
}

class App extends StatelessWidget {

  final Widget page;
  const App({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "iPushup",
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey[900], fontFamily: "Helvetica"
        ),

        // Application
        home: page,

    );
  }
}

