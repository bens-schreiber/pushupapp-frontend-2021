import 'package:flutter/material.dart';
import 'package:pushupapp/ui/pages/home.dart' as pages;

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

      body: const pages.HomePage(), // Main body

      bottomNavigationBar: _navigationBar(), // Bottom navigation bar
    );
  }
}

Widget _navigationBar() {
  return SizedBox(
    height: 51,
    child: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Groups",
          icon: Icon(Icons.groups),
        ),
        BottomNavigationBarItem(
          label: "My Group",
          icon: Icon(Icons.admin_panel_settings),
        ),
      ],
      backgroundColor: Colors.grey[850],
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey[600],
      selectedItemColor: Colors.deepOrangeAccent,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 22,
    ),
  );
}

AppBar _appBar() {
  return AppBar(
    toolbarHeight: 40,
    elevation: 0.0,
    title: Row(
      children: const [
        Icon(Icons.account_circle_rounded, size: 20),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text("Username", style: TextStyle(fontSize: 15)),
        ),
        Spacer(),
        Text("Push Up Challenge", style: TextStyle(fontSize: 15))
      ],
    ),
    backgroundColor: Colors.grey[850],
  );
}
