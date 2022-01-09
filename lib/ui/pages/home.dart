import 'package:flutter/material.dart';
import 'package:pushupapp/api/pojo.dart' as pojo;
import 'package:pushupapp/api/requests.dart';
import 'package:pushupapp/ui/widgets/index.dart' as widgets;

class HomePage extends StatefulWidget {
  late List<pojo.Group> _groups;
  HomePage(this._groups, {Key? key}) : super(key: key);

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
      body: Column(
          // Column Alignment
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          // Main body of home page
          children:  [

            // Centered Flip Coin widget
            widgets.CenterDisplay(groups: widget._groups, onPageUpdated: _onPageUpdated, index: _displayingIndex),

            // Pushup button widget
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: widgets.GlowingButton(

                    text: API.username == widget._groups[_displayingIndex].coinHolder
                          ? "Click to do your pushups!"
                          : widget._groups[_displayingIndex].coinHolder + " is the coin holder",
                onPressed: _updateCoin)
            ),

            // Group information widget
             Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: widgets.GroupInfo(widget._groups[_displayingIndex]),
            ),
          ]),
        );
  }
  
  void _onPageUpdated(int page) {
    setState(() {
      _displayingIndex = page;
    });
  }
  
  void _updateCoin() {
    if (API.username == widget._groups[_displayingIndex].coinHolder) {
      API.post().coin(widget._groups[_displayingIndex].id)
          .then((value) => API.get().groups()
          .then((groups) => setState(() {widget._groups = groups;})));
    }
  }

}
