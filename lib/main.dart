import 'package:flutter/material.dart';
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:pushupapp/ui/pages/index.dart' as pages;
import 'package:pushupapp/api/requests.dart';


//todo: coin update not always updating (probably has to do with it randomly selecting the same user)
void main() {
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
        home: FutureBuilder(
          future: API.initialize("test", "123"),
          builder: (context, snap) {
            if (snap.data == null) {
              return const pages.LoadPage();
            } return FutureBuilder(
                future: API.get().groups(),
                builder: (context, snap) {
                  if (snap.data == null) {
                    return const pages.LoadPage();
                  } return pages.BaseLayout("test", snap.data as List<pojo.Group>);
                }
            );
          }
        )

    );
  }
}

