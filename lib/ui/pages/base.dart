import 'package:flutter/material.dart';
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/pages/index.dart' as pages;

class BaseLayout extends StatefulWidget {
  const BaseLayout({Key? key}) : super(key: key);

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(), // Top bar of the application

      body: const pages.HomePage(),
    );
  }


  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 40,
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_circle_rounded, size: 22),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(API.username, style: const TextStyle(fontSize: 19)),
          ),
          const Spacer(),
          const Text("iPushup", style: TextStyle(fontSize: 19))
        ],
      ),
      backgroundColor: Colors.grey[850],
    );
  }
}
