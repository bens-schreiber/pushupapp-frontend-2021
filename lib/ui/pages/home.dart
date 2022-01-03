import 'package:flutter/material.dart';
import 'package:pushupapp/ui/pages/widgets/pushupbutton.dart' as widgets;
import 'package:pushupapp/ui/pages/widgets/coin.dart' as widgets;
import 'package:pushupapp/ui/pages/widgets/groupinfo.dart' as widgets;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 1;
  final List _coins = [widgets.Coin(1), widgets.Coin(2), widgets.Coin(3)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main homepage contents
      body: Center(
          child: Column(
              // Column Alignment
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,

              // Main body of home page
              children: [

                const Spacer(), // Spacing

                // Centered Flip Coin widget
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      // Back coin button
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600]),
                        onPressed: () {
                          if (_currentIndex != 0) {
                            setState(() {
                              _currentIndex--;
                            });
                          }}),

                      _coins[_currentIndex],   // Coin widget

                      // Forward coin button
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
                        onPressed: () {
                          if (_currentIndex < (_coins.length - 1)) {
                            setState(() {
                              _currentIndex++;
                            });
                          }})
                    ])),

                const Spacer(), // Spacing

                // Pushup button widget
                const Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: widgets.PushupButton()),

                // Group information widget
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: widgets.GroupInfo(),
                ),
              ])),
        );
  }
}
