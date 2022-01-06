import 'package:flutter/material.dart';
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:pushupapp/ui/pages/index.dart' as pages;

class BaseLayout extends StatefulWidget {
  final String _username;
  final List<pojo.Group> _groups;
  const BaseLayout(this._username, this._groups, {Key? key}) : super(key: key);

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(), // Top bar of the application

      body: pages.HomePage(widget._groups),
    );
  }


  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 40,
      elevation: 0.0,
      title: Row(
        children: [
          const Icon(Icons.account_circle_rounded, size: 20),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(widget._username, style: const TextStyle(fontSize: 15)),
          ),
          const Spacer(),
          const Text("Push Up Challenge", style: TextStyle(fontSize: 15))
        ],
      ),
      backgroundColor: Colors.grey[850],
    );
  }
}
