import 'package:flutter/material.dart';
import 'package:pushupapp/ui/pages/base.dart' as base;
import 'package:pushupapp/api/requests.dart';


//todo: coin update not always updating (probably has to do with it randomly selecting the same user)
void main() async {
  await API.initialize("test", "123");
  await API.post().join("23c9f92e-e0cd-4e93-9ec0-312de0a27f12");

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Pushup App",
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey[900], fontFamily: "Helvetica"
        ),

        // Application
        home: const base.BaseLayout()

    );
  }
}

