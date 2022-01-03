import 'package:flutter/material.dart';
import 'package:pushupapp/ui/base.dart' as base;
import 'package:pushupapp/api/requests.dart';


void main() async {
  API api = await API.initialize("test", "123");
  print(api.token);
  print(await api.get().healthCheck());
  // runApp(const App());
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

