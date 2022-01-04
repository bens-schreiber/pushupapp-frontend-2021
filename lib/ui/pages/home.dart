import 'package:flutter/material.dart';
import 'package:pushupapp/api/pojos.dart' as pojo;
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/pages/widgets/index.dart' as widgets;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<pojo.Group>> groups;

  @override
  void initState() {
    super.initState();

    // Request for groups everytime the page is initialized
    groups = API.get().groups();
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      // Main homepage contents
      body: Center(
          child: Column(
              // Column Alignment
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,

              // Main body of home page
              children:  [

                const Spacer(), // Spacing

                // Centered Flip Coin widget
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  child: FutureBuilder(
                    future: groups,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return widgets.CenterDisplay(
                            snapshot.data as List<pojo.Group>);
                      } return (Text("bruh"));
                    }

                  )
                  ),

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
