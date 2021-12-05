import 'package:flutter/material.dart';
import 'package:pushupapp/widgets/button.dart';
import 'package:pushupapp/widgets/coin.dart';

final TextStyle _basic = TextStyle(fontSize: 15, color: Colors.grey[600]);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.account_circle_rounded),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text("Username"),
            ),
            Spacer(),
            Text("Push Up Challenge")
          ],
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: FlipCoin(),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _groupInfo(),
            ),
            const Padding(
                padding: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: PushupButton())
          ])),
      bottomNavigationBar: _navigationBar(),
    );
  }
}

Container _groupInfo() {
  return Container(
    color: Colors.grey[850],
    child: Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Group Info", style: _basic),
          Divider(color: Colors.grey[600], thickness: .65),
          Row(children: [
            Text("Current Coin Holder", style: _basic),
            Spacer(),
            Text("tim", style: _basic)
          ]),
          Row(children: [
            Text("Group Creator", style: _basic),
            Spacer(),
            Text("tim", style: _basic)
          ])
        ]),
      ),
    ),
  );
}

BottomNavigationBar _navigationBar() {
  return BottomNavigationBar(
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
    selectedFontSize: 14,
    unselectedFontSize: 14,
    iconSize: 27,
  );
}
