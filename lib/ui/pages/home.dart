import 'package:flutter/material.dart';
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:pushupapp/ui/widgets/index.dart' as widgets;

class HomePage extends StatefulWidget {
  final List<pojo.Group> _groups;
  const HomePage(this._groups, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  late int _displayingIndex;
  
  @override
  void initState() {
    super.initState();
    _displayingIndex = widget._groups.length > 2 ? 1 : 0;
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
                widgets.CenterDisplay(groups: widget._groups, onPageUpdated: _onPageUpdated, index: _displayingIndex),

                const Spacer(), // Spacing

                // Pushup button widget
                const Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: widgets.PushupButton()),

                // Group information widget
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widgets.GroupInfo(widget._groups[_displayingIndex]),
                ),
              ])),
        );
  }
  
  void _onPageUpdated(int page) {
    setState(() {
      _displayingIndex = page;
    });
  }
}
