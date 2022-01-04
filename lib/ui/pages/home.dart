import 'package:flutter/material.dart';
import 'package:pushupapp/ui/pages/widgets/index.dart' as widgets;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
              children: const [

                Spacer(), // Spacing

                // Centered Flip Coin widget
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 40),
                  child: widgets.CenterDisplay()
                  ),

                Spacer(), // Spacing

                // Pushup button widget
                Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: widgets.PushupButton()),

                // Group information widget
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: widgets.GroupInfo(),
                ),
              ])),
        );
  }
}
